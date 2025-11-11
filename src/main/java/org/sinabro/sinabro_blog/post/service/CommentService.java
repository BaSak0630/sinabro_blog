package org.sinabro.sinabro_blog.post.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.sinabro.sinabro_blog.exception.CommentNotFound;
import org.sinabro.sinabro_blog.exception.InvalidPassword;
import org.sinabro.sinabro_blog.exception.PostNotFound;
import org.sinabro.sinabro_blog.post.domain.Comment;
import org.sinabro.sinabro_blog.post.domain.Post;
import org.sinabro.sinabro_blog.post.repository.CommentRepository;
import org.sinabro.sinabro_blog.post.repository.PostRepository;
import org.sinabro.sinabro_blog.post.request.CommentCreate;
import org.sinabro.sinabro_blog.post.request.CommentDelete;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CommentService {
    private final CommentRepository commentRepository;
    private final PostRepository postRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public void write(Long postId, CommentCreate request) {
        Post post = postRepository.findById(postId).orElseThrow(() -> new PostNotFound());

        String encryptedPassword = passwordEncoder.encode(request.getPassword());
        Comment comment = Comment.builder()
                .author(request.getAuthor())
                .password(encryptedPassword)
                .content(request.getContent())
                .build();

        post.addComment(comment);
    }

    public void delete(Long commentId, CommentDelete request) {
        Comment comment = commentRepository.findById(commentId).orElseThrow(() -> new CommentNotFound());

        String encryptedPassword = comment.getPassword();

        if (!passwordEncoder.matches(request.getPassword(), encryptedPassword)) {
            throw new InvalidPassword();
        }

        commentRepository.delete(comment);
    }
}
