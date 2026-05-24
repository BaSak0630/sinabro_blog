package org.sinabro.dokhu.repository;

import org.sinabro.dokhu.domain.FlowSession;
import org.sinabro.dokhu.domain.UserBook;
import org.sinabro.commonness.user.domain.Account;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FlowSessionRepository extends JpaRepository<FlowSession, Long> {
    List<FlowSession> findAllByUserBookOrderByStartTimeDesc(UserBook userBook);
    Optional<FlowSession> findTopByAccountAndEndTimeIsNullOrderByStartTimeDesc(Account account);
}
