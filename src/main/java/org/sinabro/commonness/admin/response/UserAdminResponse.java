package org.sinabro.commonness.admin.response;

import lombok.Getter;
import org.sinabro.commonness.user.domain.Account;
import org.sinabro.commonness.user.domain.Role;

import java.time.LocalDateTime;

@Getter
public class UserAdminResponse {
    private final Long id;
    private final String accountId;
    private final String username;
    private final String email;
    private final Role role;
    private final LocalDateTime createAt;

    public UserAdminResponse(Account account) {
        this.id = account.getId();
        this.accountId = account.getAccountId();
        this.username = account.getUsername();
        this.email = account.getEmail();
        this.role = account.getRole();
        this.createAt = account.getCreateAt();
    }
}
