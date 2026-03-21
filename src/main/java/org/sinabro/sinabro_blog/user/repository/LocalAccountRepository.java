package org.sinabro.sinabro_blog.user.repository;

import org.sinabro.sinabro_blog.user.domain.LocalAccount;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface LocalAccountRepository extends JpaRepository<LocalAccount, Long> {
    Optional<LocalAccount> findByAccountId(String accountId);
    Optional<LocalAccount> findByEmail(String email);
}
