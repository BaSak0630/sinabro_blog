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
import org.sinabro.dokhu.domain.BookNote;
import org.sinabro.dokhu.domain.ReadingStatus;
import org.sinabro.dokhu.domain.UserBook;
import org.sinabro.dokhu.repository.BookMemoRepository;
import org.sinabro.dokhu.repository.BookNoteRepository;
import org.sinabro.dokhu.repository.BookRepository;
import org.sinabro.dokhu.repository.FlowSessionRepository;
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
public class BookNoteControllerDocTest {

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
                .accountId("noteuser1")
                .password(passwordEncoder.encode("password1234"))
                .email("noteuser1@example.com")
                .username("노트유저")
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

        bookNoteRepository.save(BookNote.builder()
                .account(testAccount)
                .userBook(testUserBook)
                .title("1장 요약")
                .content("클린 코드란 읽기 쉬운 코드이다.")
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
    @DisplayName("독서 노트 조회")
    public void getNoteTest() throws Exception {
        mockMvc.perform(get("/dokhu/notes/{userBookId}", testUserBook.getId())
                        .accept(MediaType.APPLICATION_JSON)
                        .with(authentication(userAuth())))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("book-note-get",
                        pathParameters(
                                parameterWithName("userBookId").description("서재 항목 ID")
                        ),
                        responseFields(
                                fieldWithPath("id").description("노트 ID"),
                                fieldWithPath("userBookId").description("서재 항목 ID"),
                                fieldWithPath("title").description("노트 제목").optional(),
                                fieldWithPath("content").description("노트 내용 (마크다운)").optional(),
                                fieldWithPath("createdAt").description("작성일시"),
                                fieldWithPath("updatedAt").description("마지막 수정일시")
                        )
                ));
    }

    @Test
    @DisplayName("독서 노트 저장")
    public void saveNoteTest() throws Exception {
        Map<String, Object> request = Map.of(
                "userBookId", testUserBook.getId(),
                "title", "2장 요약",
                "content", "의미 있는 이름을 사용하라."
        );

        mockMvc.perform(post("/dokhu/notes")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request))
                        .accept(MediaType.APPLICATION_JSON)
                        .with(authentication(userAuth())))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("book-note-save",
                        requestFields(
                                fieldWithPath("userBookId").description("서재 항목 ID"),
                                fieldWithPath("title").description("노트 제목").optional(),
                                fieldWithPath("content").description("노트 내용 (마크다운)").optional()
                        ),
                        responseFields(
                                fieldWithPath("id").description("노트 ID"),
                                fieldWithPath("userBookId").description("서재 항목 ID"),
                                fieldWithPath("title").description("노트 제목").optional(),
                                fieldWithPath("content").description("노트 내용 (마크다운)").optional(),
                                fieldWithPath("createdAt").description("작성일시"),
                                fieldWithPath("updatedAt").description("마지막 수정일시")
                        )
                ));
    }

    @Test
    @DisplayName("독서 메모 목록 조회")
    public void getMemosTest() throws Exception {
        mockMvc.perform(get("/dokhu/memos/{userBookId}", testUserBook.getId())
                        .accept(MediaType.APPLICATION_JSON)
                        .with(authentication(userAuth())))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("book-memo-list",
                        pathParameters(
                                parameterWithName("userBookId").description("서재 항목 ID")
                        ),
                        responseFields(
                                fieldWithPath("[]").description("메모 목록 (없으면 빈 배열)")
                        )
                ));
    }

    @Test
    @DisplayName("독서 메모 추가")
    public void addMemoTest() throws Exception {
        Map<String, Object> request = Map.of(
                "userBookId", testUserBook.getId(),
                "content", "p.42 - 좋은 이름은 의도를 드러낸다.",
                "pageNumber", 42
        );

        mockMvc.perform(post("/dokhu/memos")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request))
                        .accept(MediaType.APPLICATION_JSON)
                        .with(authentication(userAuth())))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("book-memo-add",
                        requestFields(
                                fieldWithPath("userBookId").description("서재 항목 ID"),
                                fieldWithPath("content").description("메모 내용"),
                                fieldWithPath("pageNumber").description("해당 페이지 번호").optional()
                        ),
                        responseFields(
                                fieldWithPath("id").description("메모 ID"),
                                fieldWithPath("userBookId").description("서재 항목 ID"),
                                fieldWithPath("content").description("메모 내용"),
                                fieldWithPath("pageNumber").description("해당 페이지 번호").optional(),
                                fieldWithPath("createdAt").description("작성일시")
                        )
                ));
    }
}
