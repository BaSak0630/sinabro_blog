package org.sinabro.sinabro_blog.auth.service;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.sinabro.commonness.auth.request.SignUp;
import org.sinabro.commonness.auth.service.AuthService;
import org.sinabro.commonness.user.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;

@SpringBootTest
class AuthServiceTest {
    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private AuthService authService;

    @AfterEach
    public void clean() {
        accountRepository.deleteAll();
    }

    @BeforeEach
    void setUp() {
    }

    @Test
    void signup() {

        //given
        SignUp signup = SignUp.builder()
                .accountId("test1234")
                .email("test1@gmail.com")
                .password("pass1234")
                .build();

        //then
        authService.signup(signup);

        //expected
        assertThat(accountRepository.findByAccountId("test1")).isNotNull();
    }

    @Test
    void login() {
    }
}