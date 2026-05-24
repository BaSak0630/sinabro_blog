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
public class FlowSession {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_book_id", nullable = false)
    private UserBook userBook;

    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Long totalSeconds;

    private String videoUrl;

    private Integer bookmarkPage;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String memo;

    @Builder
    public FlowSession(Account account, UserBook userBook, String videoUrl) {
        this.account = account;
        this.userBook = userBook;
        this.videoUrl = videoUrl;
        this.startTime = LocalDateTime.now();
    }

    public void end(String memo, Integer bookmarkPage) {
        this.endTime = LocalDateTime.now();
        this.totalSeconds = java.time.Duration.between(startTime, endTime).getSeconds();
        this.memo = memo;
        this.bookmarkPage = bookmarkPage;
    }
}
