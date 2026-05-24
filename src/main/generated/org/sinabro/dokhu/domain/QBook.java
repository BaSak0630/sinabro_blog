package org.sinabro.dokhu.domain;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;


/**
 * QBook is a Querydsl query type for Book
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QBook extends EntityPathBase<Book> {

    private static final long serialVersionUID = -1542349744L;

    public static final QBook book = new QBook("book");

    public final StringPath author = createString("author");

    public final StringPath coverImageUrl = createString("coverImageUrl");

    public final StringPath genre = createString("genre");

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public final StringPath isbn = createString("isbn");

    public final StringPath publishDate = createString("publishDate");

    public final StringPath publisher = createString("publisher");

    public final StringPath synopsis = createString("synopsis");

    public final StringPath title = createString("title");

    public final NumberPath<Integer> totalPages = createNumber("totalPages", Integer.class);

    public QBook(String variable) {
        super(Book.class, forVariable(variable));
    }

    public QBook(Path<? extends Book> path) {
        super(path.getType(), path.getMetadata());
    }

    public QBook(PathMetadata metadata) {
        super(Book.class, metadata);
    }

}

