package org.sinabro.dokhu.response;

import lombok.Getter;
import org.sinabro.dokhu.domain.BookNote;

import java.time.LocalDateTime;

@Getter
public class BookNoteResponse {
    private final Long id;
    private final Long userBookId;
    private final String title;
    private final String content;
    private final LocalDateTime createdAt;
    private final LocalDateTime updatedAt;

    public BookNoteResponse(BookNote note) {
        this.id = note.getId();
        this.userBookId = note.getUserBook().getId();
        this.title = note.getTitle();
        this.content = note.getContent();
        this.createdAt = note.getCreatedAt();
        this.updatedAt = note.getUpdatedAt();
    }
}
