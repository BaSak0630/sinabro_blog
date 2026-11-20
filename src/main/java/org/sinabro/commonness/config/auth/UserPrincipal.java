package org.sinabro.commonness.config.auth;

import org.sinabro.commonness.user.domain.Account;
import org.sinabro.commonness.user.domain.Role;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.List;

public class UserPrincipal extends User {

    private final Long accountId;

    public UserPrincipal(Account account) {
        super(account.getUsername(), account.getPassword(), List.of(new SimpleGrantedAuthority(resolveAuthority(account))));
        this.accountId = account.getId();
    }

    private static String resolveAuthority(Account account) {
        Role role = account.getRole();
        if (role == null) {
            return "ROLE_USER";
        }
        return "ROLE_" + role.getRole();
    }

    public Long getUserId() {
        return accountId;
    }
}
