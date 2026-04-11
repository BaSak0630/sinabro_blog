package org.sinabro.sinabro_blog.post.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.sinabro.commonness.config.auth.PrincipalDetails;
import org.sinabro.commonness.user.domain.LocalAccount;
import org.sinabro.commonness.user.domain.Role;
import org.sinabro.sinabro_blog.post.repository.PostRepository;
import org.sinabro.sinabro_blog.post.request.PostCreate;
import org.sinabro.commonness.user.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.springframework.http.MediaType.APPLICATION_JSON;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.post;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.authentication;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@AutoConfigureMockMvc
@SpringBootTest
class PostControllerTest {

    @Autowired
    ObjectMapper objectMapper;

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private AccountRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private LocalAccount testAccount;

    @BeforeEach
    void setUp() {
        testAccount = LocalAccount.builder()
                .accountId("daile1234")
                .password(passwordEncoder.encode("password1234"))
                .email("daile1234@gmail.com")
                .username("김동혁")
                .role(Role.USER)
                .build();
        userRepository.save(testAccount);
    }

    @AfterEach
    void clean() {
        postRepository.deleteAll();
        userRepository.deleteAll();
    }

    @Test
    @DisplayName("글 작성 요청시 ")
    void test() throws Exception {
        //when
        PostCreate request = PostCreate.builder()
                .title("제목입니다.")
                .content("내용입니다.")
                .build();

        String json = objectMapper.writeValueAsString(request);

        PrincipalDetails principalDetails = new PrincipalDetails(testAccount);
        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                principalDetails, null,
                List.of(new SimpleGrantedAuthority("ROLE_ADMIN"))
        );

        //expected
        mockMvc.perform(post("/posts")
                        .contentType(APPLICATION_JSON)
                        .content(json)
                        .with(authentication(auth))
                )
                .andExpect(status().isOk())
                .andExpect(content().string(""))
                .andDo(print());
    }
}
