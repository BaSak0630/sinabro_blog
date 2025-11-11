package org.sinabro.sinabro_blog.post.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;
import org.sinabro.sinabro_blog.exception.InvalidRequest;

@ToString
@Getter
public class PostCreate {

    @NotBlank(message = "타이틀을 입력해주세요") //값이 주입될때 검증을 해줌
    public final String title;

    @NotBlank(message = "콘텐츠을 입력해주세요")
    public final String content;

    @Builder
    public PostCreate(String title, String content) {
        this.title = title;
        this.content = content;
    }

    public PostCreate changeTitle(String title) {
        return PostCreate.builder()
                .title(title)
                .content(content)
                .build();
    }

    public void validate() {
        if (this.title.contains("바보")) {
            throw new InvalidRequest("title","제목에 바보를 포함할 수 없읍니다.");
        }
    }
    //빌더의 장점
    // 가독성이 좋다.
    // 값 생성의 유연함
    // 필요한 값만 받을 수 있다. 조건별로 생성자 오버로딩의 반복줄일수 있다.
    //(오버로딩이 가증한 조건 찾아보기)
}
