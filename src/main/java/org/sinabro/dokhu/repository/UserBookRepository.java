package org.sinabro.dokhu.repository;

import org.sinabro.dokhu.domain.ReadingStatus;
import org.sinabro.dokhu.domain.UserBook;
import org.sinabro.commonness.user.domain.Account;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserBookRepository extends JpaRepository<UserBook, Long> {
    List<UserBook> findAllByAccountOrderByUpdatedAtDesc(Account account);
    List<UserBook> findAllByAccountAndStatusOrderByUpdatedAtDesc(Account account, ReadingStatus status);
    Optional<UserBook> findByAccountAndBookId(Account account, Long bookId);
    boolean existsByAccountAndBookId(Account account, Long bookId);
}
