package org.sinabro.fintree.repository;

import org.sinabro.fintree.domain.SkillNode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface SkillNodeRepository extends JpaRepository<SkillNode, Long> {

    @Query("SELECT n FROM SkillNode n ORDER BY n.orderIndex ASC")
    List<SkillNode> findAllOrdered();
}
