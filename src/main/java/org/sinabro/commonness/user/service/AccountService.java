package org.sinabro.commonness.user.service;

import jakarta.validation.constraints.NotBlank;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.sinabro.commonness.exception.UserNotFound;
import org.springframework.stereotype.Service;
import org.sinabro.sinabro_blog.post.repository.PostRepository;
import org.sinabro.commonness.user.domain.Account;
import org.sinabro.commonness.user.domain.LocalAccount;
import org.sinabro.commonness.user.domain.OAuthAccount;
import org.sinabro.commonness.user.repository.AccountRepository;
import org.sinabro.commonness.user.repository.LocalAccountRepository;
import org.sinabro.commonness.user.repository.OAuthAccountRepository;
import org.sinabro.commonness.user.response.AccountResponse;
import org.sinabro.commonness.user.response.PublicProfileResponse;

import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class AccountService {
    private final AccountRepository accountRepository;
    private final LocalAccountRepository localAccountRepository;
    private final OAuthAccountRepository oAuthAccountRepository;
    private final PostRepository postRepository;

    public AccountResponse getUserProfile(Long accountId) {
        Account account = accountRepository.findById(accountId)
                .orElseThrow(UserNotFound::new);

        AccountResponse accountResponse = new AccountResponse(account);

        log.info("accountResponse: {}", accountResponse);
        return accountResponse;
    }

    public Optional<Account> findByUsername(String username) {
        Optional<LocalAccount> local = localAccountRepository.findByAccountId(username);
        if (local.isPresent()) return local.map(a -> a);
        return Optional.empty();
    }

    public void oauthJoin(OAuthAccount accountEntity) {
        accountEntity.validate();
        accountRepository.save(accountEntity);
    }

    public Optional<Account> findByEmail(String email) {
        Optional<LocalAccount> local = localAccountRepository.findByEmail(email);
        if (local.isPresent()) return local.map(a -> a);
        return oAuthAccountRepository.findByEmail(email).map(a -> a);
    }

    public Optional<Account> findByAccountId(@NotBlank(message = "아이디 입력해주세요") String accountId) {
        Optional<LocalAccount> local = localAccountRepository.findByAccountId(accountId);
        if (local.isPresent()) return local.map(a -> a);
        return oAuthAccountRepository.findByAccountId(accountId).map(a -> a);
    }

    public void join(LocalAccount accountEntity) {
        accountRepository.save(accountEntity);
    }

    public PublicProfileResponse getPublicProfile(String accountId) {
        Account account = findByAccountId(accountId).orElseThrow(UserNotFound::new);
        long postCount = postRepository.countByAccountAccountId(accountId);
        return new PublicProfileResponse(account, postCount);
    }
}
