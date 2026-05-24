package org.sinabro.dokhu.domain;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AccessLevel;
import org.sinabro.commonness.user.domain.Account;

import java.time.LocalDateTime;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class UserBook {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "book_id", nullable = false)
    private Book book;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ReadingStatus status;

    private int currentPage;

    private int starRating; // 0~5

    private LocalDateTime registeredAt;
    private LocalDateTime updatedAt;

    @Builder
    public UserBook(Account account, Book book, ReadingStatus status) {
        this.account = account;
        this.book = book;
        this.status = status;
        this.currentPage = 0;
        this.starRating = 0;
        this.registeredAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public void updateProgress(int currentPage) {
        this.currentPage = currentPage;
        this.updatedAt = LocalDateTime.now();
        if (book.getTotalPages() != null && book.getTotalPages() > 0
                && currentPage >= book.getTotalPages()) {
            this.status = ReadingStatus.COMPLETED;
        } else if (currentPage > 0 && this.status == ReadingStatus.ADDING) {
            this.status = ReadingStatus.READING;
        }
    }

    public void updateRating(int starRating) {
        this.starRating = starRating;
        this.updatedAt = LocalDateTime.now();
    }

    public int getProgressPercent() {
        if (book.getTotalPages() == null || book.getTotalPages() == 0) return 0;
        return Math.min(100, currentPage * 100 / book.getTotalPages());
    }
}
