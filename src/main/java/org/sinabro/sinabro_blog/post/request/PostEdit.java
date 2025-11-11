package org.sinabro.sinabro_blog.post.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PostEdit {

    @NotBlank(message = "타이틀을 입력해주세요") //값이 주입될때 검증을 해줌
    public final String title;

    @NotBlank(message = "콘텐츠을 입력해주세요")
    public final String content;

    @Builder
    public PostEdit(String title, String content) {
        this.title = title;
        this.content = content;
    }
}
