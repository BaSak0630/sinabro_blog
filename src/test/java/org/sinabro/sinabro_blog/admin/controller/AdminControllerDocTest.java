package org.sinabro.sinabro_blog.admin.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.sinabro.sinabro_blog.annotation.SinabroMockUser;
import org.sinabro.sinabro_blog.post.domain.Post;
import org.sinabro.sinabro_blog.post.repository.PostRepository;
import org.sinabro.commonness.admin.request.RoleUpdateRequest;
import org.sinabro.commonness.user.domain.LocalAccount;
import org.sinabro.commonness.user.domain.Role;
import org.sinabro.commonness.user.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.restdocs.RestDocumentationExtension;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.http.MediaType.APPLICATION_JSON;
import static org.springframework.restdocs.mockmvc.MockMvcRestDocumentation.document;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.*;
import static org.springframework.restdocs.payload.PayloadDocumentation.*;
import static org.springframework.restdocs.request.RequestDocumentation.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@AutoConfigureRestDocs(uriScheme = "https", uriHost = "api.sinabro.org", uriPort = 443)
@ExtendWith(RestDocumentationExtension.class)
public class AdminControllerDocTest {

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

    private LocalAccount testAccount;
    private Post testPost;

    @BeforeEach
    public void setUp() {
        testAccount = LocalAccount.builder()
                .accountId("testuser123")
                .password(passwordEncoder.encode("password1234"))
                .email("testuser@example.com")
                .username("테스트유저")
                .role(Role.USER)
                .build();
        accountRepository.save(testAccount);

        testPost = Post.builder()
                .title("관리자 테스트 게시글")
                .content("관리자 테스트 내용입니다.")
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
    @DisplayName("관리자 통계 조회")
    public void getStatsTest() throws Exception {
        mockMvc.perform(get("/admin/stats")
                        .accept(APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("admin-stats",
                        responseFields(
                                fieldWithPath("userCount").description("전체 유저 수"),
                                fieldWithPath("postCount").description("전체 게시글 수"),
                                fieldWithPath("commentCount").description("전체 댓글 수"),
                                fieldWithPath("totalViewCount").description("전체 조회수 합계"),
                                fieldWithPath("recentPosts[]").description("최근 게시글 목록 (최대 5개)"),
                                fieldWithPath("recentPosts[].id").description("게시글 ID"),
                                fieldWithPath("recentPosts[].title").description("게시글 제목"),
                                fieldWithPath("recentPosts[].author").description("작성자 계정 아이디"),
                                fieldWithPath("recentPosts[].regDate").description("등록일"),
                                fieldWithPath("recentPosts[].viewCount").description("조회수"),
                                fieldWithPath("recentUsers[]").description("최근 가입 유저 목록 (최대 5개)"),
                                fieldWithPath("recentUsers[].id").description("유저 DB ID"),
                                fieldWithPath("recentUsers[].accountId").description("계정 아이디"),
                                fieldWithPath("recentUsers[].username").description("이름"),
                                fieldWithPath("recentUsers[].role").description("권한").optional(),
                                fieldWithPath("recentUsers[].createAt").description("가입일").optional()
                        )
                ));
    }

    @Test
    @SinabroMockUser
    @DisplayName("관리자 유저 목록 조회")
    public void getUsersTest() throws Exception {
        mockMvc.perform(get("/admin/users")
                        .param("page", "0")
                        .param("size", "10")
                        .accept(APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("admin-users",
                        queryParameters(
                                parameterWithName("page").description("페이지 번호 (0부터 시작)"),
                                parameterWithName("size").description("한 페이지당 유저 수")
                        ),
                        responseFields(
                                fieldWithPath("page").description("현재 페이지"),
                                fieldWithPath("size").description("페이지당 항목 수"),
                                fieldWithPath("totalCount").description("전체 유저 수"),
                                fieldWithPath("items[]").description("유저 목록"),
                                fieldWithPath("items[].id").description("유저 DB ID"),
                                fieldWithPath("items[].accountId").description("계정 아이디"),
                                fieldWithPath("items[].username").description("이름"),
                                fieldWithPath("items[].email").description("이메일"),
                                fieldWithPath("items[].role").description("권한").optional(),
                                fieldWithPath("items[].createAt").description("가입일").optional()
                        )
                ));
    }

    @Test
    @SinabroMockUser
    @DisplayName("관리자 유저 권한 변경")
    public void updateRoleTest() throws Exception {
        // given - RoleUpdateRequest JSON
        String json = "{\"role\": \"ROLE_ADMIN\"}";

        // expected
        mockMvc.perform(patch("/admin/users/{id}/role", testAccount.getId())
                        .contentType(APPLICATION_JSON)
                        .content(json))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("admin-update-role",
                        pathParameters(
                                parameterWithName("id").description("권한을 변경할 유저 ID")
                        ),
                        requestFields(
                                fieldWithPath("role").description("변경할 권한 (USER, ROLE_ADMIN, MANAGER)")
                        )
                ));
    }

    @Test
    @SinabroMockUser
    @DisplayName("관리자 게시글 목록 조회")
    public void getAdminPostsTest() throws Exception {
        mockMvc.perform(get("/admin/posts")
                        .param("page", "0")
                        .param("size", "10")
                        .accept(APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("admin-posts",
                        queryParameters(
                                parameterWithName("page").description("페이지 번호 (0부터 시작)"),
                                parameterWithName("size").description("한 페이지당 게시글 수")
                        ),
                        responseFields(
                                fieldWithPath("page").description("현재 페이지"),
                                fieldWithPath("size").description("페이지당 항목 수"),
                                fieldWithPath("totalCount").description("전체 게시글 수"),
                                fieldWithPath("items[]").description("게시글 목록"),
                                fieldWithPath("items[].id").description("게시글 ID"),
                                fieldWithPath("items[].title").description("게시글 제목"),
                                fieldWithPath("items[].content").description("게시글 내용"),
                                fieldWithPath("items[].regDate").description("등록일"),
                                fieldWithPath("items[].comments").description("댓글 목록"),
                                fieldWithPath("items[].author").description("작성자 계정 아이디"),
                                fieldWithPath("items[].viewCount").description("조회수"),
                                fieldWithPath("items[].categoryId").description("카테고리 ID").optional(),
                                fieldWithPath("items[].categoryName").description("카테고리 이름").optional()
                        )
                ));
    }

    @Test
    @SinabroMockUser
    @DisplayName("관리자 게시글 삭제")
    public void deleteAdminPostTest() throws Exception {
        mockMvc.perform(delete("/admin/posts/{id}", testPost.getId()))
                .andDo(print())
                .andExpect(status().isNoContent())
                .andDo(document("admin-delete-post",
                        pathParameters(
                                parameterWithName("id").description("삭제할 게시글 ID")
                        )
                ));
    }
}
