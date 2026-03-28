package org.sinabro.sinabro_blog.post.repository;


import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.sinabro.sinabro_blog.post.domain.Post;
import org.sinabro.sinabro_blog.post.request.PostSearch;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;

import java.util.List;

import static org.sinabro.sinabro_blog.post.domain.QPost.post;


@RequiredArgsConstructor
public class PostRepositoryImpl implements PostRepositoryCustom {

    private final JPAQueryFactory jpaQueryFactory;

    @Override
    public Page<Post> getList(PostSearch postSearch) {
        BooleanExpression authorFilter = postSearch.getAuthor() != null
                ? post.account.accountId.eq(postSearch.getAuthor())
                : null;

        long totalCount = jpaQueryFactory.select(post.count())
                .from(post)
                .where(authorFilter)
                .fetchFirst();
        List<Post> items = jpaQueryFactory.selectFrom(post)
                .where(authorFilter)
                .limit(postSearch.getSize())
                .offset(postSearch.getOffset())
                .orderBy(post.id.desc())
                .fetch();

        return new PageImpl<>(items, postSearch.getPageable(), totalCount);
    }
}
