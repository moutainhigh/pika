package com.wenlincheng.pika.common.resource.file.alioss.entity;

import lombok.Data;

import java.util.ArrayList;

/**
 * 跨域
 *
 * @author  wenlincheng
 * @date  2019-09-06 13:21
 * @version 1.0
 */
@Data
public class CorsRoleEntity extends AbstractEntity {
    /**
     * 指定允许跨域请求的来源
     */
    private ArrayList<String> allowedOrigin;

    /**
     * 指定允许的跨域请求方法(GET/PUT/DELETE/POST/HEAD)
     */
    private ArrayList<String> allowedMethod;

    /**
     * 控制在OPTIONS预取指令中Access-Control-Request-Headers头中指定的header是否允许
     */
    private ArrayList<String> allowedHeader;

    /**
     * 指定允许用户从应用程序中访问的响应头
     */
    private ArrayList<String> exposedHeader;

    /**
     * 指定浏览器对特定资源的预取(OPTIONS)请求返回结果的缓存时间,单位为秒
     */
    private int maxAgeSeconds;

    public CorsRoleEntity(String bucket) {
        super(bucket);
        this.maxAgeSeconds = 300;
    }

    public CorsRoleEntity setAllowedOrigin(ArrayList<String> allowedOrigin) {
        this.allowedOrigin = allowedOrigin;
        return this;
    }

    public CorsRoleEntity setAllowedMethod(ArrayList<String> allowedMethod) {
        this.allowedMethod = allowedMethod;
        return this;
    }

    public CorsRoleEntity setAllowedHeader(ArrayList<String> allowedHeader) {
        this.allowedHeader = allowedHeader;
        return this;
    }

    public CorsRoleEntity setExposedHeader(ArrayList<String> exposedHeader) {
        this.exposedHeader = exposedHeader;
        return this;
    }

    public void setMaxAgeSeconds(int maxAgeSeconds) {
        this.maxAgeSeconds = maxAgeSeconds;
    }

}
