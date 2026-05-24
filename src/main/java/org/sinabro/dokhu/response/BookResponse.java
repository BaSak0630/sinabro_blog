package org.sinabro.dokhu.response;

import lombok.Getter;
import org.sinabro.dokhu.domain.Book;

@Getter
public class BookResponse {
    private final Long id;
    private final String title;
    private final String author;
    private final String isbn;
    private final String coverImageUrl;
    private final String publisher;
    private final String genre;
    private final Integer totalPages;
    private final String publishDate;
    private final String synopsis;

    public BookResponse(Book book) {
        this.id = book.getId();
        this.title = book.getTitle();
        this.author = book.getAuthor();
        this.isbn = book.getIsbn();
        this.coverImageUrl = book.getCoverImageUrl();
        this.publisher = book.getPublisher();
        this.genre = book.getGenre();
        this.totalPages = book.getTotalPages();
        this.publishDate = book.getPublishDate();
        this.synopsis = book.getSynopsis();
    }
}
