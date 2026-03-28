package org.sinabro.commonness.user.response;

import lombok.Getter;
import org.sinabro.commonness.user.domain.Account;

@Getter
public class PublicProfileResponse {
    private final String accountId;
    private final String username;
    private final long postCount;

    public PublicProfileResponse(Account account, long postCount) {
        this.accountId = account.getAccountId();
        this.username = account.getUsername();
        this.postCount = postCount;
    }
}
