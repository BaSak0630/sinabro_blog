package org.sinabro.dokhu.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class BookNoteRequest {
    private Long userBookId;
    private String title;
    private String content;
}
