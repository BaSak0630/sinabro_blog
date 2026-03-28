package org.sinabro.commonness.user.repository;

import org.sinabro.commonness.user.domain.LocalAccount;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface LocalAccountRepository extends JpaRepository<LocalAccount, Long> {
    Optional<LocalAccount> findByAccountId(String accountId);
    Optional<LocalAccount> findByEmail(String email);
}
