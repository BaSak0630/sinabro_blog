package org.sinabro.dokhu.response;

import lombok.Getter;
import org.sinabro.dokhu.domain.BookMemo;

import java.time.LocalDateTime;

@Getter
public class BookMemoResponse {
    private final Long id;
    private final Long userBookId;
    private final String content;
    private final Integer pageNumber;
    private final LocalDateTime createdAt;

    public BookMemoResponse(BookMemo memo) {
        this.id = memo.getId();
        this.userBookId = memo.getUserBook().getId();
        this.content = memo.getContent();
        this.pageNumber = memo.getPageNumber();
        this.createdAt = memo.getCreatedAt();
    }
}
