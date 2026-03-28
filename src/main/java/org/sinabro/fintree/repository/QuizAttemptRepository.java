package org.sinabro.fintree.repository;

import org.sinabro.fintree.domain.QuizAttempt;
import org.sinabro.commonness.user.domain.Account;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuizAttemptRepository extends JpaRepository<QuizAttempt, Long> {

    List<QuizAttempt> findAllByAccountAndQuiz_SkillNodeId(Account account, Long skillNodeId);
}
