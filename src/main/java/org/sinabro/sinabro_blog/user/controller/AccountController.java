package org.sinabro.sinabro_blog.user.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.sinabro.sinabro_blog.config.auth.UserPrincipal;
import org.sinabro.sinabro_blog.user.response.AccountResponse;
import org.sinabro.sinabro_blog.user.service.AccountService;

@RestController
@RequiredArgsConstructor
@CrossOrigin(origins = "http://localhost:8080")
public class AccountController {

    private final AccountService accountService;

    @GetMapping("/users/me")
    public ResponseEntity<AccountResponse> getMe(@AuthenticationPrincipal UserPrincipal userPrincipal){
        if(userPrincipal == null){
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        AccountResponse userResponse = accountService.getUserProfile(userPrincipal.getUserId());

        return ResponseEntity.status(HttpStatus.OK).body(userResponse);
    }
}

