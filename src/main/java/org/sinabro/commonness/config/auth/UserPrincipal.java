package org.sinabro.commonness.config.auth;

import org.sinabro.commonness.user.domain.Account;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.List;

public class UserPrincipal extends User {

    private final Long accountId;

    public UserPrincipal(Account account) {
        super(account.getUsername(), account.getPassword(), List.of(new SimpleGrantedAuthority("ROLE_ADMIN")));
        //DB에서 사용자마다 권한이 다르면 적용해주어야함

        //TODO if문으로 들어오는 계정 정보에 따라 권한 변경 관련 내용 더 공부해야함
        this.accountId = account.getId();
    }

    public Long getUserId() {
        return accountId;
    }
}
