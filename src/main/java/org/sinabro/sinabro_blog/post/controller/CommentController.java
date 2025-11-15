package org.sinabro.sinabro_blog.post.controller;


import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.sinabro.sinabro_blog.post.request.CommentCreate;
import org.sinabro.sinabro_blog.post.request.CommentDelete;
import org.sinabro.sinabro_blog.post.service.CommentService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@CrossOrigin(origins = "http://localhost:8080")
public class CommentController {

    private final CommentService commentService;

    @PostMapping("/posts/{postId}/comments")
    private void write(@PathVariable Long postId, @RequestBody @Valid CommentCreate request){
        commentService.write(postId, request);
    }

    @PostMapping("/comments/{commentId}/delete")//delete requestBody 를 못넣는다
    private void delete(@PathVariable Long commentId, @RequestBody @Valid CommentDelete request) {
        commentService.delete(commentId, request);
    }
}
