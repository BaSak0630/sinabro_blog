package org.sinabro.fintree.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.sinabro.commonness.user.domain.Account;

import java.time.LocalDateTime;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(uniqueConstraints = @UniqueConstraint(columnNames = {"account_id", "skill_node_id"}))
public class UserNodeProgress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id")
    private Account account;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "skill_node_id")
    private SkillNode skillNode;

    private LocalDateTime completedAt;

    @Builder
    public UserNodeProgress(Account account, SkillNode skillNode) {
        this.account = account;
        this.skillNode = skillNode;
        this.completedAt = LocalDateTime.now();
    }
}
