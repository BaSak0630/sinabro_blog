package org.sinabro.fintree.response;

import lombok.Getter;
import org.sinabro.fintree.domain.Quiz;
import org.sinabro.fintree.domain.QuizOption;

import java.util.List;

@Getter
public class QuizResponse {
    private final Long id;
    private final String question;
    private final List<QuizOptionResponse> options;

    public QuizResponse(Quiz quiz) {
        this.id = quiz.getId();
        this.question = quiz.getQuestion();
        this.options = quiz.getOptions().stream()
                .map(QuizOptionResponse::new)
                .toList();
    }

    @Getter
    public static class QuizOptionResponse {
        private final Long id;
        private final String text;

        public QuizOptionResponse(QuizOption option) {
            this.id = option.getId();
            this.text = option.getText();
            // isCorrect 는 클라이언트에 노출하지 않음
        }
    }
}
