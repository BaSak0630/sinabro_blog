package org.sinabro.fintree.domain;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QQuizAttempt is a Querydsl query type for QuizAttempt
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QQuizAttempt extends EntityPathBase<QuizAttempt> {

    private static final long serialVersionUID = -742117995L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QQuizAttempt quizAttempt = new QQuizAttempt("quizAttempt");

    public final org.sinabro.commonness.user.domain.QAccount account;

    public final DateTimePath<java.time.LocalDateTime> attemptedAt = createDateTime("attemptedAt", java.time.LocalDateTime.class);

    public final BooleanPath correct = createBoolean("correct");

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public final QQuiz quiz;

    public final QQuizOption selectedOption;

    public QQuizAttempt(String variable) {
        this(QuizAttempt.class, forVariable(variable), INITS);
    }

    public QQuizAttempt(Path<? extends QuizAttempt> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QQuizAttempt(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QQuizAttempt(PathMetadata metadata, PathInits inits) {
        this(QuizAttempt.class, metadata, inits);
    }

    public QQuizAttempt(Class<? extends QuizAttempt> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.account = inits.isInitialized("account") ? new org.sinabro.commonness.user.domain.QAccount(forProperty("account"), inits.get("account")) : null;
        this.quiz = inits.isInitialized("quiz") ? new QQuiz(forProperty("quiz"), inits.get("quiz")) : null;
        this.selectedOption = inits.isInitialized("selectedOption") ? new QQuizOption(forProperty("selectedOption"), inits.get("selectedOption")) : null;
    }

}

