package org.sinabro.sinabro_blog.post.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.sinabro.sinabro_blog.annotation.SinabroMockUser;
import org.sinabro.sinabro_blog.post.domain.Post;
import org.sinabro.sinabro_blog.post.repository.PostRepository;
import org.sinabro.sinabro_blog.post.request.CommentCreate;
import org.sinabro.sinabro_blog.post.request.CommentDelete;
import org.sinabro.sinabro_blog.post.service.CommentService;
import org.sinabro.sinabro_blog.user.domain.LocalAccount;
import org.sinabro.sinabro_blog.user.domain.Role;
import org.sinabro.sinabro_blog.user.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.restdocs.RestDocumentationExtension;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.http.MediaType.APPLICATION_JSON;
import static org.springframework.restdocs.mockmvc.MockMvcRestDocumentation.document;
import static org.springframework.restdocs.payload.PayloadDocumentation.*;
import static org.springframework.restdocs.request.RequestDocumentation.parameterWithName;
import static org.springframework.restdocs.request.RequestDocumentation.pathParameters;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.post;



@SpringBootTest
@AutoConfigureMockMvc
@AutoConfigureRestDocs(uriScheme = "https",uriHost = "api.sinabro.org",uriPort = 443)
@ExtendWith(RestDocumentationExtension.class)
class CommentControllerDocTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;
    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private CommentService commentService;

    private LocalAccount testAccount;

    private Post testPost;


    @BeforeEach
    public void setUp() {
        // 테스트 계정 생성
        testAccount = LocalAccount.builder()
                .accountId("testuser")
                .email("test@example.com")
                .username("테스트유저")
                .password(passwordEncoder.encode("1234"))
                .role(Role.USER)
                .build();
        accountRepository.save(testAccount);

        // 테스트 게시글 생성
        testPost = Post.builder()
                .title("테스트 게시글")
                .content("테스트 내용입니다.")
                .account(testAccount)
                .build();
        postRepository.save(testPost);
    }

    @AfterEach
    public void clean() {
        postRepository.deleteAll();
        accountRepository.deleteAll();
    }



    @Test
    @SinabroMockUser
    @DisplayName("댓글 작성 성공")
    public void postCommentSuccess() throws Exception {
        // given
        CommentCreate request = CommentCreate.builder()
                .content("좋은 글이네요!")
                .author("댓글작성자")
                .password("comment123")
                .build();

        String json = objectMapper.writeValueAsString(request);

        // expected
        mockMvc.perform(post("/posts/{postId}/comments", testPost.getId())
                        .contentType(APPLICATION_JSON)
                        .accept(APPLICATION_JSON)
                        .content(json))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("comment-create",
                        pathParameters(
                                parameterWithName("postId").description("게시글 ID")
                        ),
                        requestFields(
                                fieldWithPath("content").description("댓글 내용"),
                                fieldWithPath("author").description("작성자 이름"),
                                fieldWithPath("password").description("댓글 비밀번호 (수정/삭제 시 사용)")
                        )
                ));
    }

    @Test
    @SinabroMockUser
    @DisplayName("댓글 삭제 성공")
    public void deleteCommentSuccess() throws Exception {
        CommentCreate request = CommentCreate.builder()
                .content("좋은 글이네요!")
                .author("댓글작성자")
                .password("comment123")
                .build();

        commentService.write(testPost.getId(),request);

        // given
        Long commentId = 1L;
        CommentDelete request1 = CommentDelete.builder()
                .password("comment123")
                .build();

        String json1 = objectMapper.writeValueAsString(request1);

        // expected
        mockMvc.perform(post("/comments/{commentId}/delete", commentId)
                        .contentType(APPLICATION_JSON)
                        .accept(APPLICATION_JSON)
                        .content(json1))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("comment-delete-success",
                        pathParameters(
                                parameterWithName("commentId").description("삭제할 댓글의 ID")
                        ),
                        requestFields(
                                fieldWithPath("password").description("댓글 작성 시 설정한 비밀번호")
                        )
                ));
    }

//    @Test
//    @SinabroMockUser
//    @DisplayName("댓글 작성 실패 - 필수값 누락")
//    public void postCommentFailMissingFields() throws Exception {
//        // given - author와 password 누락
//        CommentCreate request = CommentCreate.builder()
//                .content("내용만 있음")
//                .build();
//
//        String json = objectMapper.writeValueAsString(request);
//
//        // expected
//        mockMvc.perform(post("/posts/{postId}/comments", testPost.getId())
//                        .contentType(APPLICATION_JSON)
//                        .accept(APPLICATION_JSON)
//                        .content(json))
//                .andDo(print())
//                .andExpect(status().isBadRequest())
//                .andDo(document("comment-create-fail-validation",
//                        pathParameters(
//                                parameterWithName("postId").description("게시글 ID")
//                        ),
//                        requestFields(
//                                fieldWithPath("content").description("댓글 내용"),
//                                fieldWithPath("author").description("작성자 이름 (필수)").optional(),
//                                fieldWithPath("password").description("댓글 비밀번호 (필수)").optional()
//                        )
//                ));
//    }
}