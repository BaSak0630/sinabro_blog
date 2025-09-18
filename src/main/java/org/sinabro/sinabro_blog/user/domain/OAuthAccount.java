package org.sinabro.sinabro_blog.user.domain;

import jakarta.persistence.Entity;
import jakarta.persistence.PrimaryKeyJoinColumn;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Entity
@SuperBuilder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@PrimaryKeyJoinColumn(name = "id")
public class OAuthAccount extends Account {

    private String provider;
    private String providerUserid;
    private String access_token;
    private String refresh_token;
    private LocalDateTime linkedAt;

    public OAuthAccount(
            String accountId,
            String password,
            String email,
            String username,
            UserProfile profile,
            Role role,
            String provider,
            String providerUserid,
            String linkedAt)
    {
        this.accountId = accountId;
        this.password = password;
        this.email = email;
        this.username = username;
        this.createAt = LocalDateTime.now();
        this.updateAt = LocalDateTime.now();
        this.profile = profile;
        this.role = role;
        this.provider = provider;
        this.providerUserid = providerUserid;
        this.linkedAt = LocalDateTime.now();
    }
}
