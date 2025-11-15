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

    @Override
    public void validate() {

    }
}
