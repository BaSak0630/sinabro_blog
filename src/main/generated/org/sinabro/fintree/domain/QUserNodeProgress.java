package org.sinabro.fintree.domain;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QUserNodeProgress is a Querydsl query type for UserNodeProgress
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QUserNodeProgress extends EntityPathBase<UserNodeProgress> {

    private static final long serialVersionUID = 1605180669L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QUserNodeProgress userNodeProgress = new QUserNodeProgress("userNodeProgress");

    public final org.sinabro.commonness.user.domain.QAccount account;

    public final DateTimePath<java.time.LocalDateTime> completedAt = createDateTime("completedAt", java.time.LocalDateTime.class);

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public final QSkillNode skillNode;

    public QUserNodeProgress(String variable) {
        this(UserNodeProgress.class, forVariable(variable), INITS);
    }

    public QUserNodeProgress(Path<? extends UserNodeProgress> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QUserNodeProgress(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QUserNodeProgress(PathMetadata metadata, PathInits inits) {
        this(UserNodeProgress.class, metadata, inits);
    }

    public QUserNodeProgress(Class<? extends UserNodeProgress> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.account = inits.isInitialized("account") ? new org.sinabro.commonness.user.domain.QAccount(forProperty("account"), inits.get("account")) : null;
        this.skillNode = inits.isInitialized("skillNode") ? new QSkillNode(forProperty("skillNode")) : null;
    }

}

