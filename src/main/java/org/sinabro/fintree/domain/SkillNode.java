package org.sinabro.fintree.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class SkillNode {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    private String description;

    @Lob
    @Column(columnDefinition = "LONGTEXT")
    private String content; // 마크다운 학습 컨텐츠

    @Enumerated(EnumType.STRING)
    private Difficulty difficulty;

    private int estimatedMinutes;

    private int orderIndex; // 같은 레벨 내 정렬 순서

    @ManyToMany
    @JoinTable(
            name = "skill_node_prerequisites",
            joinColumns = @JoinColumn(name = "node_id"),
            inverseJoinColumns = @JoinColumn(name = "prerequisite_id")
    )
    private List<SkillNode> prerequisites = new ArrayList<>();

    @OneToMany(mappedBy = "skillNode", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Quiz> quizzes = new ArrayList<>();

    @Builder
    public SkillNode(String title, String description, String content,
                     Difficulty difficulty, int estimatedMinutes, int orderIndex) {
        this.title = title;
        this.description = description;
        this.content = content;
        this.difficulty = difficulty;
        this.estimatedMinutes = estimatedMinutes;
        this.orderIndex = orderIndex;
    }

    public void addPrerequisite(SkillNode node) {
        this.prerequisites.add(node);
    }
}
