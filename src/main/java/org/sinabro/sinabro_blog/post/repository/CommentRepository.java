package org.sinabro.sinabro_blog.post.repository;


import org.sinabro.sinabro_blog.post.domain.Comment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommentRepository extends JpaRepository<Comment, Long> {
}
