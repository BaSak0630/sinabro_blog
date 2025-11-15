package org.sinabro.sinabro_blog.user.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class UserProfile {
    private static final int STREAK_START_DAY = 1; //연속출석 시작일
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String accountId;
    private String profileImageUrl;
    private String bio;
    private int streakDays;
    private LocalDateTime updateAt;
    private LocalDateTime lastAccessAt;

    @Builder
    public UserProfile(String accountId, String profileImageUrl, String bio) {
        this.accountId = accountId;
        this.profileImageUrl = profileImageUrl;
        this.bio = bio;
        this.streakDays = STREAK_START_DAY;
        this.updateAt = LocalDateTime.now();
        this.lastAccessAt = LocalDateTime.now();
    }
}
