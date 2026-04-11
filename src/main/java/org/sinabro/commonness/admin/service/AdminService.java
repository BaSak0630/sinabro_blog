package org.sinabro.commonness.admin.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.sinabro.commonness.admin.response.AdminPageResponse;
import org.sinabro.commonness.admin.response.AdminStatsResponse;
import org.sinabro.commonness.admin.response.UserAdminResponse;
import org.sinabro.commonness.exception.AccountNotFound;
import org.sinabro.commonness.user.domain.Account;
import org.sinabro.commonness.user.domain.Role;
import org.sinabro.commonness.user.repository.AccountRepository;
import org.sinabro.sinabro_blog.post.domain.Post;
import org.sinabro.sinabro_blog.post.repository.CommentRepository;
import org.sinabro.sinabro_blog.post.repository.PostRepository;
import org.sinabro.sinabro_blog.post.response.PostResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final AccountRepository accountRepository;
    private final PostRepository postRepository;
    private final CommentRepository commentRepository;

    public AdminStatsResponse getStats() {
        long userCount = accountRepository.count();
        long postCount = postRepository.count();
        long commentCount = commentRepository.count();
        long totalViewCount = postRepository.sumViewCount();

        List<AdminStatsResponse.PostSummary> recentPosts = postRepository.findTop5ByOrderByRegDateDesc()
                .stream()
                .map(AdminStatsResponse.PostSummary::new)
                .toList();

        List<AdminStatsResponse.UserSummary> recentUsers = accountRepository.findTop5ByOrderByCreateAtDesc()
                .stream()
                .map(AdminStatsResponse.UserSummary::new)
                .toList();

        return AdminStatsResponse.builder()
                .userCount(userCount)
                .postCount(postCount)
                .commentCount(commentCount)
                .totalViewCount(totalViewCount)
                .recentPosts(recentPosts)
                .recentUsers(recentUsers)
                .build();
    }

    public AdminPageResponse<UserAdminResponse> getUsers(Pageable pageable) {
        Page<Account> page = accountRepository.findAll(pageable);
        List<UserAdminResponse> items = page.getContent().stream()
                .map(UserAdminResponse::new)
                .toList();
        return new AdminPageResponse<>(page.getNumber() + 1, page.getSize(), page.getTotalElements(), items);
    }

    @Transactional
    public void updateRole(Long id, Role role) {
        Account account = accountRepository.findById(id)
                .orElseThrow(AccountNotFound::new);
        account.changeRole(role);
    }

    public AdminPageResponse<PostResponse> getPosts(Pageable pageable) {
        Page<Post> page = postRepository.findAll(pageable);
        List<PostResponse> items = page.getContent().stream()
                .map(PostResponse::new)
                .toList();
        return new AdminPageResponse<>(page.getNumber() + 1, page.getSize(), page.getTotalElements(), items);
    }
}
