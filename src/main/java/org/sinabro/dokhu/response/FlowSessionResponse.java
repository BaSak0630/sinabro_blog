package org.sinabro.dokhu.response;

import lombok.Getter;
import org.sinabro.dokhu.domain.FlowSession;

import java.time.LocalDateTime;

@Getter
public class FlowSessionResponse {
    private final Long id;
    private final Long userBookId;
    private final LocalDateTime startTime;
    private final LocalDateTime endTime;
    private final Long totalSeconds;
    private final String videoUrl;
    private final Integer bookmarkPage;
    private final String memo;

    public FlowSessionResponse(FlowSession session) {
        this.id = session.getId();
        this.userBookId = session.getUserBook().getId();
        this.startTime = session.getStartTime();
        this.endTime = session.getEndTime();
        this.totalSeconds = session.getTotalSeconds();
        this.videoUrl = session.getVideoUrl();
        this.bookmarkPage = session.getBookmarkPage();
        this.memo = session.getMemo();
    }
}
