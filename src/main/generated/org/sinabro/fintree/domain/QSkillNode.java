package org.sinabro.fintree.domain;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QSkillNode is a Querydsl query type for SkillNode
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QSkillNode extends EntityPathBase<SkillNode> {

    private static final long serialVersionUID = -1562464752L;

    public static final QSkillNode skillNode = new QSkillNode("skillNode");

    public final StringPath content = createString("content");

    public final StringPath description = createString("description");

    public final EnumPath<Difficulty> difficulty = createEnum("difficulty", Difficulty.class);

    public final NumberPath<Integer> estimatedMinutes = createNumber("estimatedMinutes", Integer.class);

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public final NumberPath<Integer> orderIndex = createNumber("orderIndex", Integer.class);

    public final ListPath<SkillNode, QSkillNode> prerequisites = this.<SkillNode, QSkillNode>createList("prerequisites", SkillNode.class, QSkillNode.class, PathInits.DIRECT2);

    public final ListPath<Quiz, QQuiz> quizzes = this.<Quiz, QQuiz>createList("quizzes", Quiz.class, QQuiz.class, PathInits.DIRECT2);

    public final StringPath title = createString("title");

    public QSkillNode(String variable) {
        super(SkillNode.class, forVariable(variable));
    }

    public QSkillNode(Path<? extends SkillNode> path) {
        super(path.getType(), path.getMetadata());
    }

    public QSkillNode(PathMetadata metadata) {
        super(SkillNode.class, metadata);
    }

}

