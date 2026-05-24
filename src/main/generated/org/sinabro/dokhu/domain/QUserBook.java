package org.sinabro.dokhu.domain;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QUserBook is a Querydsl query type for UserBook
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QUserBook extends EntityPathBase<UserBook> {

    private static final long serialVersionUID = 1191973691L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QUserBook userBook = new QUserBook("userBook");

    public final org.sinabro.commonness.user.domain.QAccount account;

    public final QBook book;

    public final NumberPath<Integer> currentPage = createNumber("currentPage", Integer.class);

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public final DateTimePath<java.time.LocalDateTime> registeredAt = createDateTime("registeredAt", java.time.LocalDateTime.class);

    public final NumberPath<Integer> starRating = createNumber("starRating", Integer.class);

    public final EnumPath<ReadingStatus> status = createEnum("status", ReadingStatus.class);

    public final DateTimePath<java.time.LocalDateTime> updatedAt = createDateTime("updatedAt", java.time.LocalDateTime.class);

    public QUserBook(String variable) {
        this(UserBook.class, forVariable(variable), INITS);
    }

    public QUserBook(Path<? extends UserBook> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QUserBook(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QUserBook(PathMetadata metadata, PathInits inits) {
        this(UserBook.class, metadata, inits);
    }

    public QUserBook(Class<? extends UserBook> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.account = inits.isInitialized("account") ? new org.sinabro.commonness.user.domain.QAccount(forProperty("account"), inits.get("account")) : null;
        this.book = inits.isInitialized("book") ? new QBook(forProperty("book")) : null;
    }

}

