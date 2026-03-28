package org.sinabro.fintree.response;

import lombok.Getter;
import org.sinabro.fintree.domain.Difficulty;
import org.sinabro.fintree.domain.NodeStatus;
import org.sinabro.fintree.domain.Quiz;
import org.sinabro.fintree.domain.SkillNode;

import java.util.List;

@Getter
public class SkillNodeDetailResponse {
    private final Long id;
    private final String title;
    private final String content;
    private final Difficulty difficulty;
    private final int estimatedMinutes;
    private final NodeStatus status;
    private final List<Long> prerequisiteIds;
    private final List<QuizResponse> quizzes;

    public SkillNodeDetailResponse(SkillNode node, NodeStatus status, List<Quiz> quizzes) {
        this.id = node.getId();
        this.title = node.getTitle();
        this.content = status == NodeStatus.LOCKED ? null : node.getContent();
        this.difficulty = node.getDifficulty();
        this.estimatedMinutes = node.getEstimatedMinutes();
        this.status = status;
        this.prerequisiteIds = node.getPrerequisites().stream()
                .map(SkillNode::getId)
                .toList();
        this.quizzes = status != NodeStatus.LOCKED
                ? quizzes.stream().map(QuizResponse::new).toList()
                : List.of();
    }
}
