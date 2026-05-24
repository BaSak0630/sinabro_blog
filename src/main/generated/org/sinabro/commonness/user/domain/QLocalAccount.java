package org.sinabro.commonness.user.domain;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QLocalAccount is a Querydsl query type for LocalAccount
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QLocalAccount extends EntityPathBase<LocalAccount> {

    private static final long serialVersionUID = -1730972333L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QLocalAccount localAccount = new QLocalAccount("localAccount");

    public final QAccount _super;

    //inherited
    public final StringPath accountId;

    //inherited
    public final DateTimePath<java.time.LocalDateTime> createAt;

    //inherited
    public final StringPath email;

    //inherited
    public final NumberPath<Long> id;

    //inherited
    public final StringPath password;

    // inherited
    public final QUserProfile profile;

    //inherited
    public final EnumPath<Role> role;

    //inherited
    public final DateTimePath<java.time.LocalDateTime> updateAt;

    //inherited
    public final StringPath username;

    public QLocalAccount(String variable) {
        this(LocalAccount.class, forVariable(variable), INITS);
    }

    public QLocalAccount(Path<? extends LocalAccount> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QLocalAccount(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QLocalAccount(PathMetadata metadata, PathInits inits) {
        this(LocalAccount.class, metadata, inits);
    }

    public QLocalAccount(Class<? extends LocalAccount> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this._super = new QAccount(type, metadata, inits);
        this.accountId = _super.accountId;
        this.createAt = _super.createAt;
        this.email = _super.email;
        this.id = _super.id;
        this.password = _super.password;
        this.profile = _super.profile;
        this.role = _super.role;
        this.updateAt = _super.updateAt;
        this.username = _super.username;
    }

}

