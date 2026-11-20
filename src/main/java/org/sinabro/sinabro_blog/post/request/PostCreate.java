package org.sinabro.sinabro_blog.post.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class PostCreate {

    @NotBlank(message = "타이틀을 입력해주세요") //값이 주입될때 검증을 해줌
    private final String title;

    @NotBlank(message = "콘텐츠을 입력해주세요")
    private final String content;

    private final Long categoryId;

    @Builder
    public PostCreate(String title, String content, Long categoryId) {
        this.title = title;
        this.content = content;
        this.categoryId = categoryId;
    }

    public PostCreate changeTitle(String title) {
        return PostCreate.builder()
                .title(title)
                .content(content)
                .categoryId(categoryId)
                .build();
    }
    //빌더의 장점
    // 가독성이 좋다.
    // 값 생성의 유연함
    // 필요한 값만 받을 수 있다. 조건별로 생성자 오버로딩의 반복줄일수 있다.
    //(오버로딩이 가증한 조건 찾아보기)
}
