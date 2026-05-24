package org.sinabro.dokhu.domain;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QBookNote is a Querydsl query type for BookNote
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QBookNote extends EntityPathBase<BookNote> {

    private static final long serialVersionUID = -831514526L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QBookNote bookNote = new QBookNote("bookNote");

    public final org.sinabro.commonness.user.domain.QAccount account;

    public final StringPath content = createString("content");

    public final DateTimePath<java.time.LocalDateTime> createdAt = createDateTime("createdAt", java.time.LocalDateTime.class);

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public final StringPath title = createString("title");

    public final DateTimePath<java.time.LocalDateTime> updatedAt = createDateTime("updatedAt", java.time.LocalDateTime.class);

    public final QUserBook userBook;

    public QBookNote(String variable) {
        this(BookNote.class, forVariable(variable), INITS);
    }

    public QBookNote(Path<? extends BookNote> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QBookNote(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QBookNote(PathMetadata metadata, PathInits inits) {
        this(BookNote.class, metadata, inits);
    }

    public QBookNote(Class<? extends BookNote> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.account = inits.isInitialized("account") ? new org.sinabro.commonness.user.domain.QAccount(forProperty("account"), inits.get("account")) : null;
        this.userBook = inits.isInitialized("userBook") ? new QUserBook(forProperty("userBook"), inits.get("userBook")) : null;
    }

}

