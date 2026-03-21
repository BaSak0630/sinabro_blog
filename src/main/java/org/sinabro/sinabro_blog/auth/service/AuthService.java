package org.sinabro.sinabro_blog.auth.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.sinabro.sinabro_blog.auth.request.SignUp;
import org.sinabro.sinabro_blog.exception.AlreadyExistsAccountException;
import org.sinabro.sinabro_blog.user.domain.Account;
import org.sinabro.sinabro_blog.user.domain.LocalAccount;
import org.sinabro.sinabro_blog.user.domain.Role;
import org.sinabro.sinabro_blog.user.domain.UserProfile;
import org.sinabro.sinabro_blog.user.service.AccountService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    private final AccountService accountService;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public void signup(SignUp signup) {
        Optional<Account> userOptional = accountService.findByAccountId(signup.getAccountId());
        if (userOptional.isPresent()) {
            throw new AlreadyExistsAccountException();
        }

        String encryptedPassword = passwordEncoder.encode(signup.getPassword());

        accountService.join(LocalAccount.builder()
                .accountId(signup.getAccountId())
                .username(signup.getUsername())
                .password(encryptedPassword)
                .createAt(LocalDateTime.now())
                .updateAt(LocalDateTime.now())
                .email(signup.getEmail())
                .profile(
                        UserProfile.builder()
                                .accountId(signup.getAccountId())
                                .profileImageUrl(null)
                                .bio(null)
                                .build()
                )
                .role(Role.USER)
                .build());

        log.info("signup accountId: {}", signup.getAccountId());
    }
}
