package org.sinabro.sinabro_blog.user.service;

import jakarta.validation.constraints.NotBlank;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.sinabro.sinabro_blog.exception.*;
import org.sinabro.sinabro_blog.user.domain.Account;
import org.sinabro.sinabro_blog.user.domain.LocalAccount;
import org.sinabro.sinabro_blog.user.domain.OAuthAccount;
import org.sinabro.sinabro_blog.user.repository.AccountRepository;
import org.sinabro.sinabro_blog.user.repository.LocalAccountRepository;
import org.sinabro.sinabro_blog.user.repository.OAuthAccountRepository;
import org.sinabro.sinabro_blog.user.response.AccountResponse;

import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class AccountService {
    private final AccountRepository accountRepository;
    private final LocalAccountRepository localAccountRepository;
    private final OAuthAccountRepository oAuthAccountRepository;

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
}
