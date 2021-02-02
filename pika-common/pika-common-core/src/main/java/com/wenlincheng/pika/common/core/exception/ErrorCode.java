package com.wenlincheng.pika.common.core.exception;

/**
 * 错误码
 *
 * @author  wenlincheng
 * @date    2019/11/24 12:47 下午
 * @version 1.0
 */
public interface ErrorCode {
    /**
     * 错误类型
     *
     * @return ErrorTypeEnum
     */
    ErrorTypeEnum getType();

    /**
     * 返回code
     *
     * @return int
     */
    int getCode();

    /**
     * 返回msg
     *
     * @return String
     */
    String getMsg();
}