package com.wenlincheng.pika.common.core.session;

import lombok.Data;

/**
 * 用户上下文信息
 *
 * @author Pikaman
 * @version 1.0.0
 * @date 2021/1/1 10:10 上午
 */
@Data
public class UserSession {

    /**
     * 用户信息
     */
    private PikaUser user;

    /**
     * 卖家信息
     */
    private PikaSeller seller;

}
