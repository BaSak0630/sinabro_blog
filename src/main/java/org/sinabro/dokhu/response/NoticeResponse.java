package org.sinabro.dokhu.response;

import lombok.Getter;
import org.sinabro.dokhu.domain.Notice;

import java.time.LocalDateTime;

@Getter
public class NoticeResponse {
    private final Long id;
    private final String title;
    private final String content;
    private final LocalDateTime createdAt;

    public NoticeResponse(Notice notice) {
        this.id = notice.getId();
        this.title = notice.getTitle();
        this.content = notice.getContent();
        this.createdAt = notice.getCreatedAt();
    }
}
