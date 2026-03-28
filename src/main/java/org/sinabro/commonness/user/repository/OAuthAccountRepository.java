package org.sinabro.commonness.user.repository;

import org.sinabro.commonness.user.domain.OAuthAccount;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface OAuthAccountRepository extends JpaRepository<OAuthAccount, Long> {
    Optional<OAuthAccount> findByEmail(String email);
    Optional<OAuthAccount> findByAccountId(String accountId);
}
