package org.sinabro.sinabro_blog.user.controller;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.sinabro.commonness.config.auth.PrincipalDetails;
import org.sinabro.commonness.user.domain.LocalAccount;
import org.sinabro.commonness.user.domain.Role;
import org.sinabro.commonness.user.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.restdocs.RestDocumentationExtension;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.springframework.http.MediaType.APPLICATION_JSON;
import static org.springframework.restdocs.mockmvc.MockMvcRestDocumentation.document;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.get;
import static org.springframework.restdocs.payload.PayloadDocumentation.fieldWithPath;
import static org.springframework.restdocs.payload.PayloadDocumentation.responseFields;
import static org.springframework.restdocs.request.RequestDocumentation.parameterWithName;
import static org.springframework.restdocs.request.RequestDocumentation.pathParameters;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.authentication;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@AutoConfigureRestDocs(uriScheme = "https", uriHost = "api.sinabro.org", uriPort = 443)
@ExtendWith(RestDocumentationExtension.class)
public class AccountControllerDocTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @AfterEach
    public void clean() {
        accountRepository.deleteAll();
    }

    @Test
    @DisplayName("내 정보 조회")
    public void getMeTest() throws Exception {
        // given
        LocalAccount account = LocalAccount.builder()
                .accountId("daile1234")
                .password(passwordEncoder.encode("password1234"))
                .email("daile@example.com")
                .username("김동혁")
                .role(Role.USER)
                .build();
        accountRepository.save(account);

        PrincipalDetails principalDetails = new PrincipalDetails(account);
        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                principalDetails, account.getPassword(),
                List.of(new SimpleGrantedAuthority("ROLE_USER"))
        );

        // expected
        mockMvc.perform(get("/users/me")
                        .accept(APPLICATION_JSON)
                        .with(authentication(auth)))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("user-me",
                        responseFields(
                                fieldWithPath("id").description("회원 DB ID"),
                                fieldWithPath("accountId").description("계정 아이디"),
                                fieldWithPath("username").description("이름"),
                                fieldWithPath("role").description("권한 (USER, ROLE_ADMIN, MANAGER)").optional()
                        )
                ));
    }

    @Test
    @DisplayName("공개 프로필 조회")
    public void getPublicProfileTest() throws Exception {
        // given
        LocalAccount account = LocalAccount.builder()
                .accountId("publicuser")
                .password(passwordEncoder.encode("password1234"))
                .email("publicuser@example.com")
                .username("공개유저")
                .role(Role.USER)
                .build();
        accountRepository.save(account);

        // expected
        mockMvc.perform(get("/users/{accountId}", account.getAccountId())
                        .accept(APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("user-public-profile",
                        pathParameters(
                                parameterWithName("accountId").description("조회할 계정 아이디")
                        ),
                        responseFields(
                                fieldWithPath("accountId").description("계정 아이디"),
                                fieldWithPath("username").description("이름"),
                                fieldWithPath("postCount").description("작성한 게시글 수")
                        )
                ));
    }
}
