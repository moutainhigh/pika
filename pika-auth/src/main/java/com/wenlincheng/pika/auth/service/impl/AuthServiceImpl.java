package com.wenlincheng.pika.auth.service.impl;

import com.alibaba.fastjson.JSON;
import com.wenlincheng.pika.auth.entity.ValidateCode;
import com.wenlincheng.pika.auth.feign.api.PermissionService;
import com.wenlincheng.pika.auth.feign.api.UserService;
import com.wenlincheng.pika.auth.feign.dto.Permission;
import com.wenlincheng.pika.auth.feign.dto.User;
import com.wenlincheng.pika.auth.entity.AuthUser;
import com.wenlincheng.pika.auth.exception.AuthErrorCodeEnum;
import com.wenlincheng.pika.auth.manager.JwtTokenManager;
import com.wenlincheng.pika.auth.service.AuthService;
import com.wenlincheng.pika.common.core.base.vo.Result;
import com.wenlincheng.pika.common.core.constant.SecurityConstants;
import com.wenlincheng.pika.common.core.exception.PikaException;
import com.wenlincheng.pika.common.core.exception.SystemErrorCodeEnum;
import com.wenlincheng.pika.common.core.redis.RedisUtils;
import com.wenlincheng.pika.common.core.util.UUIDUtils;
import com.wf.captcha.ArithmeticCaptcha;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.SecurityConfig;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.PathMatcher;

import javax.servlet.http.HttpServletRequestWrapper;
import java.util.Collection;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

import static com.wenlincheng.pika.auth.exception.AuthErrorCodeEnum.USER_NOT_FOUND;
import static com.wenlincheng.pika.common.core.constant.SecurityConstants.PERMISSIONS_REDIS_KEY;
import static com.wenlincheng.pika.common.core.constant.SecurityConstants.VALIDATE_CODE_REDIS_KEY;

/**
 * ??????????????????????????????
 *
 * @author Pikaman
 * @version 1.0.0
 * @date 2021/1/1 10:10 ??????
 */
@Slf4j
@Service
public class AuthServiceImpl implements AuthService {

    @Autowired
    private PermissionService permissionService;
    @Autowired
    private UserService userService;
    @Autowired
    private JwtTokenManager jwtTokenManager;
    @Autowired
    private RedisUtils redisUtils;

    @Override
    public boolean logout(String token) {
        AuthUser authUser = this.getUserInfoByToken(token);
        redisUtils.delete(SecurityConstants.JWT_TOKEN_REDIS_PREFIX + authUser.getId());
        return true;
    }

    @Override
    public AuthUser getUserInfoByToken(String token) {
        AuthUser authUser = new AuthUser();
        try {
            // ??????token
            Claims claims = jwtTokenManager.parserToken(token);
            // ?????????????????????
            String username = claims.getSubject();
            Result<User> userResult = userService.getUserByUsername(username);
            if (userResult != null) {
                User user = userResult.getData();
                if (user != null) {
                    authUser.setId(user.getId());
                    authUser.setUsername(user.getUsername());
                    authUser.setName(user.getName());
                    authUser.setAvatar(user.getAvatar());
                    authUser.setStatus(user.getStatus());
                    authUser.setRoleList(user.getRoleList());
                }
            }

        } catch (ExpiredJwtException e) {
            throw PikaException.construct(AuthErrorCodeEnum.TOKEN_EXPIRED).build();
        } catch (Exception e) {
            throw PikaException.construct(AuthErrorCodeEnum.TOKEN_MALFORMED).build();
        }

        return authUser;
    }

    @Override
    public AuthUser authDecide(HttpServletRequestWrapper requestWrapper, String uri, String method) throws JwtException{
        String token = requestWrapper.getHeader(SecurityConstants.JWT_TOKEN_HEADER);
        if (StringUtils.isBlank(token) || !token.startsWith(SecurityConstants.JWT_TOKEN_PREFIX)) {
            throw PikaException.construct(AuthErrorCodeEnum.TOKEN_EMPTY).build();
        }
        Long userId = jwtTokenManager.getUserIdByToken(token);
        String redisToken = redisUtils.get(SecurityConstants.JWT_TOKEN_REDIS_PREFIX + userId);
        if (StringUtils.isBlank(redisToken)) {
            throw PikaException.construct(AuthErrorCodeEnum.TOKEN_LOGOUT).build();
        }
        if (!redisToken.equals(token.replace(SecurityConstants.JWT_TOKEN_PREFIX, ""))) {
            throw PikaException.construct(AuthErrorCodeEnum.TOKEN_EXPIRED).build();
        }
        // ????????????????????????
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        ConfigAttribute urlConfigAttribute = getPermissionByUrl(uri, method);
        if (Objects.isNull(urlConfigAttribute)) {
            throw PikaException.construct(SystemErrorCodeEnum.RESOURCE_NOT_FOUND).build();
        }
        if (!isMatch(urlConfigAttribute, authorities)) {
            throw PikaException.construct(AuthErrorCodeEnum.UNAUTHORIZED).build();
        }
        return getUserInfo(authentication.getName());
    }

    @Override
    public ValidateCode getValidateCode() {
        String uuid = UUIDUtils.getUUID(16);
        ArithmeticCaptcha captcha = new ArithmeticCaptcha(120, 49);
        // ?????????????????????????????????
        captcha.setLen(2);
        redisUtils.setEx(VALIDATE_CODE_REDIS_KEY + uuid, captcha.text(), 5, TimeUnit.MINUTES);
        ValidateCode validateCode = new ValidateCode();
        validateCode.setUuid(uuid);
        validateCode.setCodeImg(captcha.toBase64());
        return validateCode;
    }

    /**
     * ???????????????????????????
     *
     *
     * @param uri ????????????
     * @param method ????????????
     * @return ConfigAttribute
     */
    private ConfigAttribute getPermissionByUrl(String uri, String method) {
        List<Permission> permissionList;
        String allPermissionRedis = redisUtils.get(PERMISSIONS_REDIS_KEY);
        if (StringUtils.isBlank(allPermissionRedis)) {
            permissionList = permissionService.queryAllPermissions().getData();
            redisUtils.setEx(PERMISSIONS_REDIS_KEY, JSON.toJSONString(permissionList), 480, TimeUnit.MINUTES);
        } else {
            permissionList = JSON.parseArray(allPermissionRedis, Permission.class);
        }
        PathMatcher pathMatcher = new AntPathMatcher();
        for (Permission permission : permissionList) {
            if (pathMatcher.match(permission.getUri() + " " + permission.getMethod(), uri + " " + method)) {
               return new SecurityConfig(permission.getPermission());
            }
        }
        return null;
    }

    /**
     * ????????????????????????????????????????????????
     *
     * @param urlConfigAttribute
     * @param authorities
     * @return boolean
     */
    public boolean isMatch(ConfigAttribute urlConfigAttribute, Collection<? extends GrantedAuthority> authorities) {
        return authorities.stream().anyMatch(authority -> authority.getAuthority().equals(urlConfigAttribute.getAttribute()));
    }

    /**
     * ?????????????????????????????????
     *
     * @param username ?????????
     * @return AuthUser
     */
    public AuthUser getUserInfo(String username) {
        Result<User> userResult = userService.getUserByUsername(username);
        User user = userResult.getData();
        if (Objects.isNull(user)) {
            throw PikaException.construct(USER_NOT_FOUND).build();
        }
        AuthUser authUser = new AuthUser();
        authUser.setId(user.getId());
        authUser.setUsername(user.getUsername());
        authUser.setName(user.getName());
        authUser.setAvatar(user.getAvatar());
        authUser.setStatus(user.getStatus());
        return authUser;
    }

    public static void main(String[] args) {
        PathMatcher pathMatcher = new AntPathMatcher();
        boolean match = pathMatcher.match("/menu/{id}" + " " + "GET", "/menu/101" + " " + "GET");
        System.out.println(match);
    }
}
