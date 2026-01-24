package org.sinabro.sinabro_blog.user.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.sinabro.sinabro_blog.auth.domain.Session;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Entity
@SuperBuilder
@Inheritance(strategy = InheritanceType.JOINED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public abstract class Account {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    protected Long id;
    protected String accountId; // 로그인아이디  //OAuth -> providerUserid
    protected String password;
    protected String email;
    protected String username;
    protected LocalDateTime createAt;
    protected LocalDateTime updateAt;
    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "user_profile_id")
    protected UserProfile profile;
    protected Role role;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "account")
    protected List<Session> sessions =  new ArrayList<>();

    public abstract void validate();

    public Session addSession() {
        Session session = Session.builder()
                .account(this)
                .build();
        sessions.add(session);

        return session;
    }
}
