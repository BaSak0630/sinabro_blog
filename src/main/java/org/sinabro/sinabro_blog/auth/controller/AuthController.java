package org.sinabro.sinabro_blog.auth.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.sinabro.sinabro_blog.auth.request.Login;
import org.sinabro.sinabro_blog.auth.request.SignUp;
import org.sinabro.sinabro_blog.auth.service.AuthService;
import org.sinabro.sinabro_blog.config.AppConfig;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final AuthenticationManager authenticationManager;
    private final AppConfig appConfig;

    @PostMapping("/auth/signup")
    public void signup(@RequestBody @Valid SignUp signup) {
        authService.signup(signup);
    }



    @PostMapping("/auth/login")
    public ResponseEntity<?> login(@RequestBody Login request) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.getAccountId(),
                            request.getPassword()
                    )
            );

            // 인증 성공
            return ResponseEntity.ok().body("로그인 성공");

        } catch (AuthenticationException e) {
            // 인증 실패
            return ResponseEntity.status(401).body("아이디 또는 비밀번호가 잘못되었습니다.");
        }
    }
}
