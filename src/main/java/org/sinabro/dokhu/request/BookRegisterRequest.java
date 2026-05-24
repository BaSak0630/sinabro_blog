package org.sinabro.dokhu.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class BookRegisterRequest {
    @NotBlank
    private String title;
    @NotBlank
    private String author;
    private String isbn;
    private String coverImageUrl;
    private String publisher;
    private String genre;
    private Integer totalPages;
    private String publishDate;
    private String synopsis;
}
