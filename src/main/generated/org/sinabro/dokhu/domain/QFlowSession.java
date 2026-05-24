package org.sinabro.dokhu.domain;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QFlowSession is a Querydsl query type for FlowSession
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QFlowSession extends EntityPathBase<FlowSession> {

    private static final long serialVersionUID = -1286433215L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QFlowSession flowSession = new QFlowSession("flowSession");

    public final org.sinabro.commonness.user.domain.QAccount account;

    public final NumberPath<Integer> bookmarkPage = createNumber("bookmarkPage", Integer.class);

    public final DateTimePath<java.time.LocalDateTime> endTime = createDateTime("endTime", java.time.LocalDateTime.class);

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public final StringPath memo = createString("memo");

    public final DateTimePath<java.time.LocalDateTime> startTime = createDateTime("startTime", java.time.LocalDateTime.class);

    public final NumberPath<Long> totalSeconds = createNumber("totalSeconds", Long.class);

    public final QUserBook userBook;

    public final StringPath videoUrl = createString("videoUrl");

    public QFlowSession(String variable) {
        this(FlowSession.class, forVariable(variable), INITS);
    }

    public QFlowSession(Path<? extends FlowSession> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QFlowSession(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QFlowSession(PathMetadata metadata, PathInits inits) {
        this(FlowSession.class, metadata, inits);
    }

    public QFlowSession(Class<? extends FlowSession> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.account = inits.isInitialized("account") ? new org.sinabro.commonness.user.domain.QAccount(forProperty("account"), inits.get("account")) : null;
        this.userBook = inits.isInitialized("userBook") ? new QUserBook(forProperty("userBook"), inits.get("userBook")) : null;
    }

}

