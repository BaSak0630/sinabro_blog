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
public class BookMemo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_book_id", nullable = false)
    private UserBook userBook;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String content;

    private Integer pageNumber;

    private LocalDateTime createdAt;

    @Builder
    public BookMemo(Account account, UserBook userBook, String content, Integer pageNumber) {
        this.account = account;
        this.userBook = userBook;
        this.content = content;
        this.pageNumber = pageNumber;
        this.createdAt = LocalDateTime.now();
    }
}
