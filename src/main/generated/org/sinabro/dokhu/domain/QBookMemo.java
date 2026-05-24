package org.sinabro.dokhu.domain;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QBookMemo is a Querydsl query type for BookMemo
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QBookMemo extends EntityPathBase<BookMemo> {

    private static final long serialVersionUID = -831554134L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QBookMemo bookMemo = new QBookMemo("bookMemo");

    public final org.sinabro.commonness.user.domain.QAccount account;

    public final StringPath content = createString("content");

    public final DateTimePath<java.time.LocalDateTime> createdAt = createDateTime("createdAt", java.time.LocalDateTime.class);

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public final NumberPath<Integer> pageNumber = createNumber("pageNumber", Integer.class);

    public final QUserBook userBook;

    public QBookMemo(String variable) {
        this(BookMemo.class, forVariable(variable), INITS);
    }

    public QBookMemo(Path<? extends BookMemo> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QBookMemo(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QBookMemo(PathMetadata metadata, PathInits inits) {
        this(BookMemo.class, metadata, inits);
    }

    public QBookMemo(Class<? extends BookMemo> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.account = inits.isInitialized("account") ? new org.sinabro.commonness.user.domain.QAccount(forProperty("account"), inits.get("account")) : null;
        this.userBook = inits.isInitialized("userBook") ? new QUserBook(forProperty("userBook"), inits.get("userBook")) : null;
    }

}

