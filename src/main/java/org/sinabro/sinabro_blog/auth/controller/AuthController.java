package org.sinabro.sinabro_blog.auth.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.sinabro.sinabro_blog.auth.request.Login;
import org.sinabro.sinabro_blog.auth.request.SignUp;
import org.sinabro.sinabro_blog.auth.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final AuthenticationManager authenticationManager;
    private final SecurityContextRepository securityContextRepository;

    @PostMapping("/auth/signup")
    public void signup(@RequestBody @Valid SignUp signup) {
        authService.signup(signup);
    }

    @PostMapping("/auth/login")
    public ResponseEntity<?> login(@RequestBody Login request,
                                   HttpServletRequest httpRequest,
                                   HttpServletResponse httpResponse) {
        log.info("Login attempt: {}", request.getAccountId());

        try {
            // Spring Security 인증
            UsernamePasswordAuthenticationToken authToken =
                    new UsernamePasswordAuthenticationToken(request.getAccountId(), request.getPassword());

            Authentication authentication = authenticationManager.authenticate(authToken);

            // SecurityContext에 인증 정보 저장
            SecurityContext context = SecurityContextHolder.createEmptyContext();
            context.setAuthentication(authentication);
            SecurityContextHolder.setContext(context);

            // 세션에 SecurityContext 저장
            httpRequest.getSession(true);
            securityContextRepository.saveContext(context, httpRequest, httpResponse);

            log.info("Login successful for user: {}", request.getAccountId());

            return ResponseEntity.ok().body("로그인 성공");

        } catch (AuthenticationException e) {
            log.warn("Login failed for user: {}", request.getAccountId());
            return ResponseEntity.status(401).body("아이디 또는 비밀번호가 잘못되었습니다.");
        }
    }
}
