package com.wenlincheng.pika.auth.filter;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.util.StreamUtils;
import org.springframework.util.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

import static com.wenlincheng.pika.common.core.constant.SecurityConstants.LOGIN_URL;

/**
 * 重写用户form登陆方式  采用json方式登陆
 *
 * @author Pikaman
 * @version 1.0.0
 * @date 2021/1/1 10:10 上午
 */
public class PikaUsernamePasswordAuthenticationFilter extends AbstractAuthenticationProcessingFilter {

    public PikaUsernamePasswordAuthenticationFilter() {
        // 指定登录路径
        super(new AntPathRequestMatcher(LOGIN_URL, "POST"));
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException, IOException {
        String body = StreamUtils.copyToString(request.getInputStream(), StandardCharsets.UTF_8);
        String username = null, password = null;
        if (StringUtils.hasText(body)) {
            JSONObject jsonObj = JSON.parseObject(body);
            username = jsonObj.getString("username");
            password = jsonObj.getString("password");
        }

        if (username == null) {
            username = "";
        }
        if (password == null) {
            password = "";
        }
        request.setAttribute("username", username);
        username = username.trim();
        //封装到security提供的用户认证接口中
        UsernamePasswordAuthenticationToken authRequest = new UsernamePasswordAuthenticationToken(username, password);
        /*
            将登陆请求提交给认证 AuthenticationManager管理模块下的authenticate方法
            再由authenticate具体的实现类完成认证服务,使用默认提供的DaoAuthenticationProvider这个用户信息查询及存储实现类
        */
        return this.getAuthenticationManager().authenticate(authRequest);
    }

}