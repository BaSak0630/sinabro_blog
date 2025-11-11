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

    @Builder.Default
    private Integer page = 1;

    @Builder.Default
    private Integer size = 10;

    public void setPage(Integer page) {
        this.page = page <= 0 ? 1 : min(page, MAX_PAGE);
    }

    public long getOffset() {
        return (long) (page - 1) * min(size, MAX_SIZE);
    }

    public Pageable getPageable() {
        return PageRequest.of(page - 1, size);
    } //getPageable 에서 기존 -1을 안해서 컨테츠 개수+ page.size가 됨
   /* private static final int MAX_SIZE = 200;

    @Builder.Default
    private Integer page = 1;

    @Builder.Default
    private Integer size = 10;

    public long getOffset(){
        return (long)(max(1,page )- 1) * min(size, MAX_SIZE);
    }

    public Pageable getPageable(){
        return PageRequest.of(page, size);
    }*/
}
