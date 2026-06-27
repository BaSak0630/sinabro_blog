package org.sinabro.dokhu.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.sinabro.commonness.config.auth.PrincipalDetails;
import org.sinabro.commonness.user.domain.LocalAccount;
import org.sinabro.commonness.user.domain.Role;
import org.sinabro.commonness.user.repository.AccountRepository;
import org.sinabro.dokhu.domain.Book;
import org.sinabro.dokhu.domain.FlowSession;
import org.sinabro.dokhu.domain.ReadingStatus;
import org.sinabro.dokhu.domain.UserBook;
import org.sinabro.dokhu.repository.BookRepository;
import org.sinabro.dokhu.repository.FlowSessionRepository;
import org.sinabro.dokhu.repository.BookNoteRepository;
import org.sinabro.dokhu.repository.BookMemoRepository;
import org.sinabro.dokhu.repository.UserBookRepository;
import org.sinabro.sinabro_blog.SinabroBlogApplication;
import org.sinabro.sinabro_blog.post.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.restdocs.RestDocumentationExtension;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Map;

import static org.springframework.restdocs.mockmvc.MockMvcRestDocumentation.document;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.*;
import static org.springframework.restdocs.payload.PayloadDocumentation.*;
import static org.springframework.restdocs.request.RequestDocumentation.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.authentication;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(classes = SinabroBlogApplication.class)
@AutoConfigureMockMvc
@AutoConfigureRestDocs(uriScheme = "https", uriHost = "api.sinabro.org", uriPort = 443)
@ExtendWith(RestDocumentationExtension.class)
public class FlowSessionControllerDocTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private UserBookRepository userBookRepository;

    @Autowired
    private FlowSessionRepository flowSessionRepository;

    @Autowired
    private BookNoteRepository bookNoteRepository;

    @Autowired
    private BookMemoRepository bookMemoRepository;

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private LocalAccount testAccount;
    private UserBook testUserBook;
    private FlowSession testSession;

    @BeforeEach
    public void setUp() {
        flowSessionRepository.deleteAll();
        bookMemoRepository.deleteAll();
        bookNoteRepository.deleteAll();
        userBookRepository.deleteAll();
        bookRepository.deleteAll();
        postRepository.deleteAll();
        accountRepository.deleteAll();

        testAccount = LocalAccount.builder()
                .accountId("flowuser1")
                .password(passwordEncoder.encode("password1234"))
                .email("flowuser1@example.com")
                .username("플로우유저")
                .role(Role.USER)
                .build();
        accountRepository.save(testAccount);

        Book testBook = bookRepository.save(Book.builder()
                .title("클린 코드")
                .author("로버트 C. 마틴")
                .isbn("9788966260959")
                .publisher("인사이트")
                .genre("개발")
                .totalPages(584)
                .publishDate("2013-12-24")
                .synopsis("좋은 코드를 작성하는 방법을 다루는 책입니다.")
                .build());

        testUserBook = userBookRepository.save(UserBook.builder()
                .account(testAccount)
                .book(testBook)
                .status(ReadingStatus.READING)
                .build());

        testSession = flowSessionRepository.save(FlowSession.builder()
                .userBook(testUserBook)
                .account(testAccount)
                .build());
    }

    @AfterEach
    public void clean() {
        flowSessionRepository.deleteAll();
        bookMemoRepository.deleteAll();
        bookNoteRepository.deleteAll();
        userBookRepository.deleteAll();
        bookRepository.deleteAll();
        postRepository.deleteAll();
        accountRepository.deleteAll();
    }

    private UsernamePasswordAuthenticationToken userAuth() {
        PrincipalDetails principalDetails = new PrincipalDetails(testAccount);
        return new UsernamePasswordAuthenticationToken(
                principalDetails, null,
                List.of(new SimpleGrantedAuthority("ROLE_USER"))
        );
    }

    @Test
    @DisplayName("독서 세션 시작")
    public void startSessionTest() throws Exception {
        Map<String, Object> request = Map.of(
                "userBookId", testUserBook.getId(),
                "videoUrl", "https://youtube.com/watch?v=example"
        );

        mockMvc.perform(post("/dokhu/sessions/start")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request))
                        .accept(MediaType.APPLICATION_JSON)
                        .with(authentication(userAuth())))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("flow-session-start",
                        requestFields(
                                fieldWithPath("userBookId").description("서재 항목 ID"),
                                fieldWithPath("videoUrl").description("함께 볼 유튜브 영상 URL").optional()
                        ),
                        responseFields(
                                fieldWithPath("id").description("세션 ID"),
                                fieldWithPath("userBookId").description("서재 항목 ID"),
                                fieldWithPath("startTime").description("세션 시작 시각"),
                                fieldWithPath("endTime").description("세션 종료 시각 (진행 중이면 null)").optional(),
                                fieldWithPath("totalSeconds").description("총 독서 시간(초) (진행 중이면 null)").optional(),
                                fieldWithPath("videoUrl").description("유튜브 영상 URL").optional(),
                                fieldWithPath("bookmarkPage").description("북마크 페이지 (종료 시 기록)").optional(),
                                fieldWithPath("memo").description("세션 메모 (종료 시 기록)").optional()
                        )
                ));
    }

    @Test
    @DisplayName("독서 세션 종료")
    public void endSessionTest() throws Exception {
        Map<String, Object> request = Map.of(
                "memo", "오늘 50페이지 읽었다.",
                "bookmarkPage", 50
        );

        mockMvc.perform(post("/dokhu/sessions/{sessionId}/end", testSession.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request))
                        .accept(MediaType.APPLICATION_JSON)
                        .with(authentication(userAuth())))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("flow-session-end",
                        pathParameters(
                                parameterWithName("sessionId").description("종료할 세션 ID")
                        ),
                        requestFields(
                                fieldWithPath("memo").description("세션 메모").optional(),
                                fieldWithPath("bookmarkPage").description("북마크 페이지").optional()
                        ),
                        responseFields(
                                fieldWithPath("id").description("세션 ID"),
                                fieldWithPath("userBookId").description("서재 항목 ID"),
                                fieldWithPath("startTime").description("세션 시작 시각"),
                                fieldWithPath("endTime").description("세션 종료 시각"),
                                fieldWithPath("totalSeconds").description("총 독서 시간(초)"),
                                fieldWithPath("videoUrl").description("유튜브 영상 URL").optional(),
                                fieldWithPath("bookmarkPage").description("북마크 페이지").optional(),
                                fieldWithPath("memo").description("세션 메모").optional()
                        )
                ));
    }

    @Test
    @DisplayName("독서 세션 기록 조회")
    public void getHistoryTest() throws Exception {
        mockMvc.perform(get("/dokhu/sessions/history/{userBookId}", testUserBook.getId())
                        .accept(MediaType.APPLICATION_JSON)
                        .with(authentication(userAuth())))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("flow-session-history",
                        pathParameters(
                                parameterWithName("userBookId").description("서재 항목 ID")
                        ),
                        responseFields(
                                fieldWithPath("[].id").description("세션 ID"),
                                fieldWithPath("[].userBookId").description("서재 항목 ID"),
                                fieldWithPath("[].startTime").description("세션 시작 시각"),
                                fieldWithPath("[].endTime").description("세션 종료 시각 (진행 중이면 null)").optional(),
                                fieldWithPath("[].totalSeconds").description("총 독서 시간(초) (진행 중이면 null)").optional(),
                                fieldWithPath("[].videoUrl").description("유튜브 영상 URL").optional(),
                                fieldWithPath("[].bookmarkPage").description("북마크 페이지").optional(),
                                fieldWithPath("[].memo").description("세션 메모").optional()
                        )
                ));
    }
}
