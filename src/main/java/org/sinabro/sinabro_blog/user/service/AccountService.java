package org.sinabro.sinabro_blog.user.service;

import jakarta.validation.constraints.NotBlank;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.sinabro.sinabro_blog.exception.*;
import org.sinabro.sinabro_blog.user.domain.Account;
import org.sinabro.sinabro_blog.user.domain.LocalAccount;
import org.sinabro.sinabro_blog.user.domain.OAuthAccount;
import org.sinabro.sinabro_blog.user.repository.AccountRepository;
import org.sinabro.sinabro_blog.user.response.AccountResponse;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AccountService {
    private final AccountRepository accountRepository;

    public AccountResponse getUserProfile(Long accountId) {
        Account account = accountRepository.findById(accountId)
                .orElseThrow(UserNotFound::new);

        return new AccountResponse(account);
    }

    public Optional<Account> findByUsername(String username) {
        Account account = accountRepository.findByUsername(username);
        return Optional.ofNullable(account);
    }

    public void oauthJoin(OAuthAccount accountEntity) {
        accountRepository.save(accountEntity);
    }

    public Optional<Account> findByEmail(String email) {
        Account account = accountRepository.findByEmail(email);
        return Optional.ofNullable(account);
    }

    public Optional<Account> findByAccountId(@NotBlank(message = "아이디 입력해주세요") String accountId) {
        return accountRepository.findByAccountId(accountId);
    }

    public void join(LocalAccount accountEntity) {
        accountRepository.save(accountEntity);
    }
}
