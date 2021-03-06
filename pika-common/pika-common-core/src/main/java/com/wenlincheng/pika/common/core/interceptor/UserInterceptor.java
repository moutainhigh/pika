package com.wenlincheng.pika.common.core.interceptor;

import com.alibaba.fastjson.JSON;
import com.wenlincheng.pika.common.core.session.PikaUser;
import com.wenlincheng.pika.common.core.session.UserSessionHolder;
import com.wenlincheng.pika.common.core.session.UserSession;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.lang.Nullable;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import static com.wenlincheng.pika.common.core.constant.SecurityConstants.X_CLIENT_TOKEN;
import static com.wenlincheng.pika.common.core.constant.SecurityConstants.X_CLIENT_TOKEN_USER;

/**
 * 用户信息拦截器
 *
 * @author Pikaman
 * @version 1.0.0
 * @date 2021/1/1 10:10 上午
 */
@Slf4j
public class UserInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        checkToken(request.getHeader(X_CLIENT_TOKEN));
        String userInfoString = StringUtils.defaultIfBlank(request.getHeader(X_CLIENT_TOKEN_USER), "{}");
        UserSession userSession = new UserSession();
        if (StringUtils.isNotBlank(userInfoString)) {
            PikaUser user = JSON.parseObject(userInfoString, PikaUser.class);
            userSession.setUser(user);
        }
        UserSessionHolder.getInstance().setSession(userSession);
        return true;
    }

    /**
     * TODO 校验服务间调用的认证token
     *
     * @param token 服务间令牌
     */
    private void checkToken(String token) {
        log.debug("校验token:{}", token);
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable Exception ex) throws Exception {
        UserSessionHolder.getInstance().clear();
    }
}
