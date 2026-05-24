package org.sinabro.dokhu.response;

import lombok.Getter;
import org.sinabro.dokhu.domain.ReadingStatus;
import org.sinabro.dokhu.domain.UserBook;

import java.time.LocalDateTime;

@Getter
public class UserBookResponse {
    private final Long id;
    private final BookResponse book;
    private final ReadingStatus status;
    private final int currentPage;
    private final int progressPercent;
    private final int starRating;
    private final LocalDateTime registeredAt;
    private final LocalDateTime updatedAt;

    public UserBookResponse(UserBook userBook) {
        this.id = userBook.getId();
        this.book = new BookResponse(userBook.getBook());
        this.status = userBook.getStatus();
        this.currentPage = userBook.getCurrentPage();
        this.progressPercent = userBook.getProgressPercent();
        this.starRating = userBook.getStarRating();
        this.registeredAt = userBook.getRegisteredAt();
        this.updatedAt = userBook.getUpdatedAt();
    }
}
