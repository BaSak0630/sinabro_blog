package org.sinabro.sinabro_blog.post.request;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import static java.lang.Math.min;

@Builder
@Getter
@Setter
public class PostSearch {

    private static final int MAX_PAGE = 999;
    private static final int MAX_SIZE = 2000;
    private static final int DEFAULT_SIZE = 10;

    @Builder.Default
    private Integer page = 1;

    @Builder.Default
    private Integer size = 10;

    private String author;

    // 요청 바인딩은 @Builder 의 all-args 생성자를 타서 @Builder.Default 가 적용되지 않으므로 getter 에서 보정
    public Integer getPage() {
        return page == null || page < 1 ? 1 : min(page, MAX_PAGE);
    }

    public Integer getSize() {
        return size == null || size < 1 ? DEFAULT_SIZE : min(size, MAX_SIZE);
    }

    public long getOffset() {
        return (long) (getPage() - 1) * getSize();
    }

    public Pageable getPageable() {
        return PageRequest.of(getPage() - 1, getSize());
    }
}
