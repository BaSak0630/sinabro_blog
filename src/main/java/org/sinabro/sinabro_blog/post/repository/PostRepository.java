package org.sinabro.sinabro_blog.post.repository;

import org.sinabro.sinabro_blog.post.domain.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface PostRepository extends JpaRepository<Post,Long> , PostRepositoryCustom {
    long countByAccountAccountId(String accountId);
    List<Post> findTop5ByOrderByRegDateDesc();
    @Query("SELECT COALESCE(SUM(p.viewCount), 0) FROM Post p")
    Long sumViewCount();
}
