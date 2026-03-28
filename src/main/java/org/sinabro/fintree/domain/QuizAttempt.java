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
public class QuizAttempt {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id")
    private Account account;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id")
    private Quiz quiz;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "selected_option_id")
    private QuizOption selectedOption;

    private boolean correct;

    private LocalDateTime attemptedAt;

    @Builder
    public QuizAttempt(Account account, Quiz quiz, QuizOption selectedOption, boolean correct) {
        this.account = account;
        this.quiz = quiz;
        this.selectedOption = selectedOption;
        this.correct = correct;
        this.attemptedAt = LocalDateTime.now();
    }
}
