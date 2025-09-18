package org.sinabro.sinabro_blog.user.response;

import lombok.Getter;
import org.sinabro.sinabro_blog.user.domain.Account;

@Getter
public class AccountResponse {
    private final Long id;
    private final String username;

    public AccountResponse(Account account) {
        this.id = account.getId();
        this.username = account.getUsername();
    }
}
