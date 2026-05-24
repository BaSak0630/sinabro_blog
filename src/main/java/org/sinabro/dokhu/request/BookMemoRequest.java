package org.sinabro.dokhu.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class BookMemoRequest {
    private Long userBookId;
    private String content;
    private Integer pageNumber;
}
