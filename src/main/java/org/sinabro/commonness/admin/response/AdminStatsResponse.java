package org.sinabro.commonness.admin.response;

import lombok.Builder;
import lombok.Getter;
import org.sinabro.commonness.user.domain.Role;
import org.sinabro.sinabro_blog.post.domain.Post;
import org.sinabro.commonness.user.domain.Account;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Builder
public class AdminStatsResponse {
    private final long userCount;
    private final long postCount;
    private final long commentCount;
    private final long totalViewCount;
    private final List<PostSummary> recentPosts;
    private final List<UserSummary> recentUsers;

    @Getter
    public static class PostSummary {
        private final Long id;
        private final String title;
        private final String author;
        private final LocalDateTime regDate;
        private final long viewCount;

        public PostSummary(Post post) {
            this.id = post.getId();
            this.title = post.getTitle();
            this.author = post.getAccount().getAccountId();
            this.regDate = post.getRegDate();
            this.viewCount = post.getViewCount();
        }
    }

    @Getter
    public static class UserSummary {
        private final Long id;
        private final String accountId;
        private final String username;
        private final Role role;
        private final LocalDateTime createAt;

        public UserSummary(Account account) {
            this.id = account.getId();
            this.accountId = account.getAccountId();
            this.username = account.getUsername();
            this.role = account.getRole();
            this.createAt = account.getCreateAt();
        }
    }
}
