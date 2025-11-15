package org.sinabro.sinabro_blog.auth.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.sinabro.sinabro_blog.annotation.SinabroMockUser;
import org.sinabro.sinabro_blog.auth.request.Login;
import org.sinabro.sinabro_blog.auth.request.SignUp;
import org.sinabro.sinabro_blog.user.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.restdocs.RestDocumentationExtension;
import org.springframework.test.web.servlet.MockMvc;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.http.MediaType.APPLICATION_JSON;
import static org.springframework.restdocs.mockmvc.MockMvcRestDocumentation.document;
import static org.springframework.restdocs.payload.PayloadDocumentation.fieldWithPath;
import static org.springframework.restdocs.payload.PayloadDocumentation.requestFields;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


@SpringBootTest
@AutoConfigureMockMvc
@AutoConfigureRestDocs(uriScheme = "https",uriHost = "api.sinabro.org",uriPort = 443)
@ExtendWith(RestDocumentationExtension.class)
class AuthControllerDocTest {
    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private ObjectMapper objectMapper;

    @AfterEach
    public void clean() {
        accountRepository.deleteAll();
    }

    @BeforeEach
    void setUp() {
    }

    @Test
    @SinabroMockUser
    @DisplayName("로그인 테스트 테스트 ")
    public void loginTest() throws Exception {
        SignUp request = SignUp.builder()
                .accountId("test123")
                .password("password124")
                .email("test123@naver.com")
                .username("김동혁")
                .build();

        String json = objectMapper.writeValueAsString(request);
        //expected
        mockMvc.perform(post("/auth/signup")
                .contentType(APPLICATION_JSON)
                .accept(APPLICATION_JSON)
                .content(json));

        Login request1 = Login.builder()
                .accountId("test123")
                .password("password124").build();
        String json1 = objectMapper.writeValueAsString(request1);
        //expected
        mockMvc.perform(post("/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .accept(APPLICATION_JSON)
                        .content(json1))
                .andDo(print())
                .andExpect(status().isOk()) // 302 redirection이 발생했는지 확인
                .andDo(document("login",
                        requestFields(
                                fieldWithPath("accountId").description("id"),
                                fieldWithPath("password").description("password")
                        )
                ));
    }

    @Test
    @DisplayName("회원 가입 테스트 테스트 ")
    public void signupTest() throws Exception {
        SignUp request = SignUp.builder()
                .accountId("test123")
                .password("password124")
                .email("test123@naver.com")
                .username("김동혁")
                .build();

        String json = objectMapper.writeValueAsString(request);
        //expected
        mockMvc.perform(post("/auth/signup")
                        .contentType(APPLICATION_JSON)
                        .accept(APPLICATION_JSON)
                        .content(json))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("signup",
                        requestFields(
                                fieldWithPath("accountId").description("id"),
                                fieldWithPath("password").description("password"),
                                fieldWithPath("email").description("email"),
                                fieldWithPath("username").description("이름")
                        )
                ));
    }

}