package org.sinabro.fintree.repository;

import org.sinabro.fintree.domain.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuizRepository extends JpaRepository<Quiz, Long> {

    List<Quiz> findAllBySkillNodeId(Long skillNodeId);
}
