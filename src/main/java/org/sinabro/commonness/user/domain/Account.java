package org.sinabro.commonness.user.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

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
    @OneToOne(cascade = CascadeType.ALL)
    protected UserProfile profile;
    protected Role role;

    public abstract void validate();

    public void changeRole(Role role) {
        this.role = role;
    }
}
