package org.sinabro.sinabro_blog.auth.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.sinabro.sinabro_blog.user.domain.UserProfile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.sinabro.sinabro_blog.auth.request.Login;
import org.sinabro.sinabro_blog.auth.request.SignUp;
import org.sinabro.sinabro_blog.exception.AlreadyExistsAccountException;
import org.sinabro.sinabro_blog.exception.InvalidPassword;
import org.sinabro.sinabro_blog.exception.UserNotFound;
import org.sinabro.sinabro_blog.user.domain.Account;
import org.sinabro.sinabro_blog.user.domain.LocalAccount;
import org.sinabro.sinabro_blog.user.domain.Role;
import org.sinabro.sinabro_blog.user.service.AccountService;

import java.time.LocalDateTime;
import java.util.Optional;

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

        System.out.println("signup accountId: " + signup.getAccountId());
        System.out.println("signup email: " + signup.getEmail());
        System.out.println("signup name: " + signup.getUsername());
        System.out.println("signup password: " + signup.getPassword());
    }

    public void login(Login login) {
        // 사용자 존재 확인
        Account account = accountService.findByAccountId(login.getAccountId())
                .orElseThrow(() -> {
                    System.out.printf("존재하지 않는 계정 - accountId: {}", login.getAccountId());
                    return new UserNotFound();
                });

        // 비밀번호 검증
        if (!passwordEncoder.matches(login.getPassword(), account.getPassword())) {
            System.out.printf("비밀번호 불일치 - accountId: {}", login.getAccountId());
            throw new InvalidPassword();
        }

        System.out.printf("수동 로그인 검증 성공 - accountId: {}, email: {}",
                account.getAccountId(), account.getEmail());
        //return responsetn
    }
}
