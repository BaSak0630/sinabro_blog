package org.sinabro.sinabro_blog.auth.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.sinabro.sinabro_blog.user.domain.Account;

import java.util.UUID;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Session {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String accessToken;

    @ManyToOne()
    private Account account;

    @Builder
    public Session(Account account) {
        this.accessToken = UUID.randomUUID().toString();
        this.account = account;
    }

    //TODO 토큰 만료
}