package org.sinabro.fintree.response;

import lombok.Builder;
import lombok.Getter;

import java.util.Map;

@Getter
@Builder
public class QuizSubmitResponse {
    private final boolean passed;           // 전부 정답 여부
    private final Map<Long, Boolean> results; // quizId -> 정답 여부
    private final boolean nodeCompleted;    // 이번에 노드가 완료됐는지
    private final int correctCount;
    private final int totalCount;
}
