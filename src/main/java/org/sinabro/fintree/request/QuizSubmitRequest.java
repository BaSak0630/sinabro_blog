package org.sinabro.fintree.request;

import lombok.Getter;

import java.util.Map;

@Getter
public class QuizSubmitRequest {
    // quizId -> 선택한 optionId
    private Map<Long, Long> answers;
}
