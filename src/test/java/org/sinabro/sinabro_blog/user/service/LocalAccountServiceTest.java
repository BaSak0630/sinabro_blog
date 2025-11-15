package org.sinabro.sinabro_blog.user.service;

import jakarta.validation.ValidationException;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.sinabro.sinabro_blog.user.domain.Account;
import org.sinabro.sinabro_blog.user.domain.LocalAccount;
import org.sinabro.sinabro_blog.user.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Optional;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;

@SpringBootTest
class LocalAccountServiceTest {

    @Autowired
    private AccountService accountService;

    @Autowired
    private AccountRepository accountRepository;

    @AfterEach
    public void clean() {
        accountRepository.deleteAll();
    }

    @Test
    @DisplayName("로컬 계정 저장 성공 테스트")
    public void localAccountJoinTest() throws Exception {
        //given
        LocalAccount localAccount = LocalAccount.builder()
                .accountId("testUser")
                .email("test@example.com")
                .password("password123")
                .username("testerName1")
                .build();

        //when
        accountService.join(localAccount);

        //then
        Optional<Account> byAccountId = accountRepository.findByAccountId(localAccount.getAccountId());
        byAccountId.ifPresent(account -> {
            assertThat(account.getUsername()).isEqualTo(localAccount.getUsername());
            assertThat(account.getPassword()).isEqualTo(localAccount.getPassword());
            assertThat(account.getEmail()).isEqualTo(localAccount.getEmail());
            assertThat(account.getAccountId()).isEqualTo(localAccount.getAccountId());
        });
    }

    @Test
    @DisplayName("로컬 계정 저장 실패 테스트 - id blank")
    public void localAccountJoinIdBlankTest() throws Exception {
        //given
        LocalAccount localAccount = LocalAccount.builder()
                .accountId("")
                .email("test@example.com")
                .password("password123")
                .username("testerName1")
                .build();

        //expect
        ValidationException e = assertThrows(ValidationException.class, () -> {
            accountService.join(localAccount);
        });
        assertThat(e.getMessage()).isEqualTo("아이디는 필수입니다.");
    }

    @Test
    @DisplayName("로컬 계정 저장 실패 테스트 - id min length")
    public void localAccountJoinIdMinLengthTest() throws Exception {
        //given
        LocalAccount localAccount = LocalAccount.builder()
                .accountId("test")
                .email("test@example.com")
                .password("password123")
                .username("testerName1")
                .build();

        //expect
        ValidationException e = assertThrows(ValidationException.class, () -> {
            accountService.join(localAccount);
        });
        assertThat(e.getMessage()).isEqualTo("아이디는 최소 8자 이상이어야 합니다.");
    }

    @Test
    @DisplayName("로컬 계정 저장 실패 테스트 - id max length")
    public void localAccountJoinIdMaxLengthTest() throws Exception {
        //given
        LocalAccount localAccount = LocalAccount.builder()
                .accountId("abcdefghijklmnopqrstuvwxyz")
                .email("test@example.com")
                .password("password123")
                .username("testerName1")
                .build();

        //expect
        ValidationException e = assertThrows(ValidationException.class, () -> {
            accountService.join(localAccount);
        });
        assertThat(e.getMessage()).isEqualTo("아이디는 최대 20자 이하이어야 합니다.");
    }

    //email
    @Test
    @DisplayName("로컬 계정 저장 실패 테스트 - email @ ")
    public void localAccountJoinEmailTest() throws Exception {
        //given
        LocalAccount localAccount = LocalAccount.builder()
                .accountId("test1234")
                .email("testexampl")
                .password("password123")
                .username("testerName1")
                .build();

        //expect
        ValidationException e = assertThrows(ValidationException.class, () -> {
            accountService.join(localAccount);
        });
        assertThat(e.getMessage()).isEqualTo("유효하지 않은 이메일입니다.");
    }

    //password
        //min
    @Test
    @DisplayName("로컬 계정 저장 실패 테스트 - email min length")
    public void localAccountJoinPasswordMinTest() throws Exception {
        //given
        LocalAccount localAccount = LocalAccount.builder()
                .accountId("test1234")
                .email("test1234@exampl.com")
                .password("pass")
                .username("testerName1")
                .build();

        //expect
        ValidationException e = assertThrows(ValidationException.class, () -> {
            accountService.join(localAccount);
        });
        assertThat(e.getMessage()).isEqualTo("비밀번호는 최소 8자 이상이어야 합니다.");
    }
        //max
        @Test
        @DisplayName("로컬 계정 저장 실패 테스트 - email max length")
        public void localAccountJoinPasswordMaxTest() throws Exception {
            //given
            LocalAccount localAccount = LocalAccount.builder()
                    .accountId("test1234")
                    .email("test1234@exampl.com")
                    .password("passddkfjdkfjsklfj2dkfjdkfjdflks")
                    .username("testerName1")
                    .build();

            //expect
            ValidationException e = assertThrows(ValidationException.class, () -> {
                accountService.join(localAccount);
            });
            assertThat(e.getMessage()).isEqualTo("비밀번호는 최대 20자 이하이어야 합니다.");
        }
}