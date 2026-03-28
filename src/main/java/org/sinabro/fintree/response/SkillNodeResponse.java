package org.sinabro.fintree.response;

import lombok.Getter;
import org.sinabro.fintree.domain.Difficulty;
import org.sinabro.fintree.domain.NodeStatus;
import org.sinabro.fintree.domain.SkillNode;

import java.util.List;

@Getter
public class SkillNodeResponse {
    private final Long id;
    private final String title;
    private final String description;
    private final Difficulty difficulty;
    private final int estimatedMinutes;
    private final int orderIndex;
    private final NodeStatus status;
    private final List<Long> prerequisiteIds;

    public SkillNodeResponse(SkillNode node, NodeStatus status) {
        this.id = node.getId();
        this.title = node.getTitle();
        this.description = node.getDescription();
        this.difficulty = node.getDifficulty();
        this.estimatedMinutes = node.getEstimatedMinutes();
        this.orderIndex = node.getOrderIndex();
        this.status = status;
        this.prerequisiteIds = node.getPrerequisites().stream()
                .map(SkillNode::getId)
                .toList();
    }
}
