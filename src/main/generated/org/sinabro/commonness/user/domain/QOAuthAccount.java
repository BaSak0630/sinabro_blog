package org.sinabro.commonness.user.domain;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QOAuthAccount is a Querydsl query type for OAuthAccount
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QOAuthAccount extends EntityPathBase<OAuthAccount> {

    private static final long serialVersionUID = 2106180743L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QOAuthAccount oAuthAccount = new QOAuthAccount("oAuthAccount");

    public final QAccount _super;

    public final StringPath access_token = createString("access_token");

    //inherited
    public final StringPath accountId;

    //inherited
    public final DateTimePath<java.time.LocalDateTime> createAt;

    //inherited
    public final StringPath email;

    //inherited
    public final NumberPath<Long> id;

    public final DateTimePath<java.time.LocalDateTime> linkedAt = createDateTime("linkedAt", java.time.LocalDateTime.class);

    //inherited
    public final StringPath password;

    // inherited
    public final QUserProfile profile;

    public final StringPath provider = createString("provider");

    public final StringPath providerUserid = createString("providerUserid");

    public final StringPath refresh_token = createString("refresh_token");

    //inherited
    public final EnumPath<Role> role;

    //inherited
    public final DateTimePath<java.time.LocalDateTime> updateAt;

    //inherited
    public final StringPath username;

    public QOAuthAccount(String variable) {
        this(OAuthAccount.class, forVariable(variable), INITS);
    }

    public QOAuthAccount(Path<? extends OAuthAccount> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QOAuthAccount(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QOAuthAccount(PathMetadata metadata, PathInits inits) {
        this(OAuthAccount.class, metadata, inits);
    }

    public QOAuthAccount(Class<? extends OAuthAccount> type, PathMetadata metadata, PathInits inits) {
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

