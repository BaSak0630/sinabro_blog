package org.sinabro.sinabro_blog.user.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.sinabro.sinabro_blog.config.auth.PrincipalDetails;
import org.sinabro.sinabro_blog.user.response.AccountResponse;
import org.sinabro.sinabro_blog.user.service.AccountService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
public class AccountController {

    private final AccountService accountService;

    @GetMapping("/users/me")
    public ResponseEntity<AccountResponse> getMe(@AuthenticationPrincipal PrincipalDetails principalDetails) {
        if (principalDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        AccountResponse userResponse = accountService.getUserProfile(principalDetails.getAccount().getId());

        log.info("userResponse: {}", userResponse);
        return ResponseEntity.status(HttpStatus.OK).body(userResponse);
    }
}

