package org.sinabro.fintree.repository;

import org.sinabro.fintree.domain.SkillNode;
import org.sinabro.fintree.domain.UserNodeProgress;
import org.sinabro.commonness.user.domain.Account;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserNodeProgressRepository extends JpaRepository<UserNodeProgress, Long> {

    List<UserNodeProgress> findAllByAccount(Account account);

    Optional<UserNodeProgress> findByAccountAndSkillNode(Account account, SkillNode skillNode);

    boolean existsByAccountAndSkillNode(Account account, SkillNode skillNode);
}
