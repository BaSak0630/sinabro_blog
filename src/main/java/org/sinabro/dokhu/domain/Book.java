package org.sinabro.dokhu.domain;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AccessLevel;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String author;
    private String isbn;
    private String coverImageUrl;
    private String publisher;
    private String genre;
    private Integer totalPages;
    private String publishDate;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String synopsis;

    @Builder
    public Book(String title, String author, String isbn, String coverImageUrl,
                String publisher, String genre, Integer totalPages,
                String publishDate, String synopsis) {
        this.title = title;
        this.author = author;
        this.isbn = isbn;
        this.coverImageUrl = coverImageUrl;
        this.publisher = publisher;
        this.genre = genre;
        this.totalPages = totalPages;
        this.publishDate = publishDate;
        this.synopsis = synopsis;
    }
}
