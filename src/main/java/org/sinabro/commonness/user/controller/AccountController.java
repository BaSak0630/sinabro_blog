package org.sinabro.commonness.user.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.sinabro.commonness.config.auth.PrincipalDetails;
import org.sinabro.commonness.user.response.AccountResponse;
import org.sinabro.commonness.user.response.PublicProfileResponse;
import org.sinabro.commonness.user.service.AccountService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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

    @GetMapping("/users/{accountId}")
    public ResponseEntity<PublicProfileResponse> getPublicProfile(@PathVariable String accountId) {
        return ResponseEntity.ok(accountService.getPublicProfile(accountId));
    }
}

