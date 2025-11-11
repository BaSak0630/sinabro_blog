package org.sinabro.sinabro_blog.post.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Getter;
import org.hibernate.validator.constraints.Length;

@Getter
public class CommentCreate {

    @Length(min = 1, max = 1000, message = "작성글은 1~1000글자까지 입력해주세요")
    @NotBlank(message = "내용을 입력해주세요")
    private String content;

    @Length(min = 1, max = 8, message = "작성글은 1~8 글자로 입력해주세요")
    @NotBlank(message = "작성자를 입력해주세요")
    private String author;

    @Length(min = 4, max = 30, message = "작성글은 4~30 글자로 입력해주세요")
    @NotBlank(message = "비밀번를을 입력해주세요")
    private String password;

    @Builder
    public CommentCreate(String content, String author, String password) {
        this.content = content;
        this.author = author;
        this.password = password;
    }
}
