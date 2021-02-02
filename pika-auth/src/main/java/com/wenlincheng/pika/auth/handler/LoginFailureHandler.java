package com.wenlincheng.pika.auth.handler;

import com.wenlincheng.pika.common.core.base.vo.Result;
import com.wenlincheng.pika.auth.utils.ResponseUtil;
import com.wenlincheng.pika.common.core.redis.RedisUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.concurrent.TimeUnit;

import static com.wenlincheng.pika.common.core.constant.SecurityConstants.LOGIN_FAIL_FLAG_REDIS_PREFIX;
import static com.wenlincheng.pika.common.core.constant.SecurityConstants.LOGIN_TIME_LIMIT_REDIS_PREFIX;
import static com.wenlincheng.pika.auth.exception.AuthErrorCodeEnum.*;

/**
 * 登录失败处理器
 *
 * @author Pikaman
 * @version 1.0.0
 * @date 2021/1/1 10:10 上午
 */
@Component
public class LoginFailureHandler implements AuthenticationFailureHandler {
    /**
     * 限制用户登陆错误次数（次）
     */
    @Value("${security.loginTimeLimit}")
    private Integer loginTimeLimit;
    /**
     * 错误超过次数后多少分钟后才能继续登录（分钟）
     */
    @Value("${security.loginAfterTime}")
    private Integer loginAfterTime;

    @Autowired
    private RedisUtils redisUtils;

    /**
     * 用户登陆失败处理类  记录用户登陆错误次数
     *
     * @param request
     * @param response
     * @param e
     * @return void 空
     */
    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException e) throws IOException {
        if (e instanceof UsernameNotFoundException) {
            Object username = request.getAttribute("username");
            // 判断登录错误次数是否用完
            boolean loginTimeUp = recordLoginTime((String) username);
            if (loginTimeUp) {
                String key = LOGIN_TIME_LIMIT_REDIS_PREFIX + username;
                String value = redisUtils.get(key);
                if (StringUtils.isBlank(value)) {
                    value = "0";
                }
                // 获取已登录错误次数
                int loginFailTime = Integer.parseInt(value);
                // 剩余登录次数
                int restLoginTime = loginTimeLimit - loginFailTime;
                ResponseUtil.out(response, Result.fail(USERNAME_PASSWORD_WRONG, "用户名或密码错误，可再尝试"+ restLoginTime +"次"));
            }

            ResponseUtil.out(response, Result.fail(USER_LIMIT_TIME_UP, e.getMessage()));
        } else if (e instanceof DisabledException) {
            ResponseUtil.out(response, Result.fail(USER_DISABLED));
        }else if (e instanceof BadCredentialsException) {
            ResponseUtil.out(response, Result.fail(BAD_CREDENTIALS));
        } else {
            ResponseUtil.out(response, Result.fail(LOGIN_FAIL));

        }
    }
    /**
     * 判断用户登陆错误次数
     */
    public boolean recordLoginTime(String username) {

        String value = redisUtils.get(LOGIN_TIME_LIMIT_REDIS_PREFIX + username);
        if (StringUtils.isBlank(value)) {
            value = "0";
        }
        // 获取已登录错误次数
        int loginFailTime = Integer.parseInt(value) + 1;
        redisUtils.setEx(LOGIN_TIME_LIMIT_REDIS_PREFIX + username, String.valueOf(loginFailTime), loginAfterTime, TimeUnit.MINUTES);

        if (loginFailTime == loginTimeLimit) {
            redisUtils.setEx(LOGIN_FAIL_FLAG_REDIS_PREFIX + username, "fail", loginAfterTime, TimeUnit.MINUTES);
            return true;
        } else if (loginFailTime > loginTimeLimit){
            redisUtils.setEx(LOGIN_FAIL_FLAG_REDIS_PREFIX + username, "fail", loginAfterTime, TimeUnit.MINUTES);
            return false;
        } else {
            return true;
        }
    }
}