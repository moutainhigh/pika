package com.wenlincheng.pika.auth.security;

import com.wenlincheng.pika.auth.feign.dto.Permission;
import com.wenlincheng.pika.auth.entity.AuthUser;
import com.wenlincheng.pika.common.core.enums.YnEnum;
import org.springframework.beans.BeanUtils;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Security 用户对象
 *
 * @author Pikaman
 * @version 1.0.0
 * @date 2021/1/1 10:10 上午
 */
public class AuthUserDetails extends AuthUser implements UserDetails {
    private static final long serialVersionUID = 1L;

    public AuthUserDetails(AuthUser user) {
        if (user != null) {
            BeanUtils.copyProperties(user, this);
        }
    }

    public AuthUserDetails(Long id, String username, String password) {
        this.setId(id);
        this.setUsername(username);
        this.setPassword(password);
    }


    /**
     * 将角色权限 放入GrantedAuthorit的自定义实现类MyGrantedAuthority中  为权限判定提供数据
     *
     * @return java.util.Collection<? extends org.springframework.security.core.GrantedAuthority>
     */
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<GrantedAuthority> authorityList = new ArrayList<>();
        List<Permission> permissionList = this.getPermissionList();
        for (Permission permission : permissionList) {
            GrantedAuthority grantedAuthority = new PikaGrantedAuthority(permission.getPermission(), permission.getMethod());
            authorityList.add(grantedAuthority);
        }
        return authorityList;
    }

    /**
     * 账户是否未过期,过期无法验证
     */
    @Override
    public boolean isAccountNonExpired() {
        return YnEnum.YES.getValue() == this.getAccountNonExpired();
    }

    /**
     * 指定用户是否解锁,锁定的用户无法进行身份验证
     */
    @Override
    public boolean isAccountNonLocked() {
        return YnEnum.YES.getValue() == this.getAccountNonLocked();
    }

    /**
     * 指示是否已过期的用户的凭据(密码),过期的凭据防止认证
     */
    @Override
    public boolean isCredentialsNonExpired() {
        return YnEnum.YES.getValue() == this.getCredentialsNonExpired();
    }

    /**
     * 是否可用 ,禁用的用户不能身份验证
     */
    @Override
    public boolean isEnabled() {
        return YnEnum.YES.getValue() == this.getStatus();
    }
}
