package org.sinabro.sinabro_blog.user.response;

import lombok.Getter;
import org.sinabro.sinabro_blog.user.domain.Account;
import org.sinabro.sinabro_blog.user.domain.Role;

@Getter
public class AccountResponse {
    private final Long id;
    private final String accountId;
    private final String username;
    private final Role role;

    public AccountResponse(Account account) {
        this.id = account.getId();
        this.accountId = account.getAccountId();
        this.username = account.getUsername();
        this.role = account.getRole();
    }
}
