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
public class LibraryControllerDocTest {

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
    private Book testBook;
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
                .accountId("dokhuuser1")
                .password(passwordEncoder.encode("password1234"))
                .email("dokhuuser1@example.com")
                .username("독후유저")
                .role(Role.USER)
                .build();
        accountRepository.save(testAccount);

        testBook = bookRepository.save(Book.builder()
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
    @DisplayName("내 서재 목록 조회")
    public void getLibraryTest() throws Exception {
        mockMvc.perform(get("/dokhu/library")
                        .param("status", "READING")
                        .accept(MediaType.APPLICATION_JSON)
                        .with(authentication(userAuth())))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("library-list",
                        queryParameters(
                                parameterWithName("status").description("독서 상태 필터 (ADDING, READING, COMPLETED). 생략 시 전체 조회").optional()
                        ),
                        responseFields(
                                fieldWithPath("[].id").description("서재 항목 ID"),
                                fieldWithPath("[].book.id").description("책 ID"),
                                fieldWithPath("[].book.title").description("책 제목"),
                                fieldWithPath("[].book.author").description("저자"),
                                fieldWithPath("[].book.isbn").description("ISBN").optional(),
                                fieldWithPath("[].book.coverImageUrl").description("표지 이미지 URL").optional(),
                                fieldWithPath("[].book.publisher").description("출판사").optional(),
                                fieldWithPath("[].book.genre").description("장르").optional(),
                                fieldWithPath("[].book.totalPages").description("전체 페이지 수").optional(),
                                fieldWithPath("[].book.publishDate").description("출판일").optional(),
                                fieldWithPath("[].book.synopsis").description("줄거리").optional(),
                                fieldWithPath("[].status").description("독서 상태 (ADDING, READING, COMPLETED)"),
                                fieldWithPath("[].currentPage").description("현재 읽은 페이지"),
                                fieldWithPath("[].progressPercent").description("독서 진행률 (%)"),
                                fieldWithPath("[].starRating").description("별점 (0~5)"),
                                fieldWithPath("[].registeredAt").description("등록일시"),
                                fieldWithPath("[].updatedAt").description("마지막 수정일시")
                        )
                ));
    }

    @Test
    @DisplayName("책 등록")
    public void registerBookTest() throws Exception {
        Map<String, Object> request = Map.of(
                "title", "리팩터링 2판",
                "author", "마틴 파울러",
                "isbn", "9791162242742",
                "publisher", "한빛미디어",
                "genre", "개발",
                "totalPages", 544,
                "publishDate", "2020-04-01",
                "synopsis", "코드 구조를 개선하는 리팩터링 기법을 설명합니다."
        );

        mockMvc.perform(post("/dokhu/library")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request))
                        .accept(MediaType.APPLICATION_JSON)
                        .with(authentication(userAuth())))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("library-register",
                        requestFields(
                                fieldWithPath("title").description("책 제목 (필수)"),
                                fieldWithPath("author").description("저자 (필수)"),
                                fieldWithPath("isbn").description("ISBN").optional(),
                                fieldWithPath("publisher").description("출판사").optional(),
                                fieldWithPath("genre").description("장르").optional(),
                                fieldWithPath("totalPages").description("전체 페이지 수").optional(),
                                fieldWithPath("publishDate").description("출판일").optional(),
                                fieldWithPath("synopsis").description("줄거리").optional()
                        ),
                        responseFields(
                                fieldWithPath("id").description("서재 항목 ID"),
                                fieldWithPath("book.id").description("책 ID"),
                                fieldWithPath("book.title").description("책 제목"),
                                fieldWithPath("book.author").description("저자"),
                                fieldWithPath("book.isbn").description("ISBN").optional(),
                                fieldWithPath("book.coverImageUrl").description("표지 이미지 URL").optional(),
                                fieldWithPath("book.publisher").description("출판사").optional(),
                                fieldWithPath("book.genre").description("장르").optional(),
                                fieldWithPath("book.totalPages").description("전체 페이지 수").optional(),
                                fieldWithPath("book.publishDate").description("출판일").optional(),
                                fieldWithPath("book.synopsis").description("줄거리").optional(),
                                fieldWithPath("status").description("독서 상태 (초기값: ADDING)"),
                                fieldWithPath("currentPage").description("현재 읽은 페이지"),
                                fieldWithPath("progressPercent").description("독서 진행률 (%)"),
                                fieldWithPath("starRating").description("별점"),
                                fieldWithPath("registeredAt").description("등록일시"),
                                fieldWithPath("updatedAt").description("마지막 수정일시")
                        )
                ));
    }

    @Test
    @DisplayName("책 상세 조회")
    public void getUserBookTest() throws Exception {
        mockMvc.perform(get("/dokhu/library/{userBookId}", testUserBook.getId())
                        .accept(MediaType.APPLICATION_JSON)
                        .with(authentication(userAuth())))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("library-detail",
                        pathParameters(
                                parameterWithName("userBookId").description("서재 항목 ID")
                        ),
                        responseFields(
                                fieldWithPath("id").description("서재 항목 ID"),
                                fieldWithPath("book.id").description("책 ID"),
                                fieldWithPath("book.title").description("책 제목"),
                                fieldWithPath("book.author").description("저자"),
                                fieldWithPath("book.isbn").description("ISBN").optional(),
                                fieldWithPath("book.coverImageUrl").description("표지 이미지 URL").optional(),
                                fieldWithPath("book.publisher").description("출판사").optional(),
                                fieldWithPath("book.genre").description("장르").optional(),
                                fieldWithPath("book.totalPages").description("전체 페이지 수").optional(),
                                fieldWithPath("book.publishDate").description("출판일").optional(),
                                fieldWithPath("book.synopsis").description("줄거리").optional(),
                                fieldWithPath("status").description("독서 상태"),
                                fieldWithPath("currentPage").description("현재 읽은 페이지"),
                                fieldWithPath("progressPercent").description("독서 진행률 (%)"),
                                fieldWithPath("starRating").description("별점"),
                                fieldWithPath("registeredAt").description("등록일시"),
                                fieldWithPath("updatedAt").description("마지막 수정일시")
                        )
                ));
    }

    @Test
    @DisplayName("독서 진행도 수정")
    public void updateProgressTest() throws Exception {
        Map<String, Object> request = Map.of("currentPage", 120);

        mockMvc.perform(patch("/dokhu/library/{userBookId}/progress", testUserBook.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request))
                        .accept(MediaType.APPLICATION_JSON)
                        .with(authentication(userAuth())))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("library-progress-update",
                        pathParameters(
                                parameterWithName("userBookId").description("서재 항목 ID")
                        ),
                        requestFields(
                                fieldWithPath("currentPage").description("현재 읽은 페이지 수")
                        ),
                        responseFields(
                                fieldWithPath("id").description("서재 항목 ID"),
                                fieldWithPath("book.id").description("책 ID"),
                                fieldWithPath("book.title").description("책 제목"),
                                fieldWithPath("book.author").description("저자"),
                                fieldWithPath("book.isbn").description("ISBN").optional(),
                                fieldWithPath("book.coverImageUrl").description("표지 이미지 URL").optional(),
                                fieldWithPath("book.publisher").description("출판사").optional(),
                                fieldWithPath("book.genre").description("장르").optional(),
                                fieldWithPath("book.totalPages").description("전체 페이지 수").optional(),
                                fieldWithPath("book.publishDate").description("출판일").optional(),
                                fieldWithPath("book.synopsis").description("줄거리").optional(),
                                fieldWithPath("status").description("독서 상태 (120/584 페이지 → READING 유지)"),
                                fieldWithPath("currentPage").description("수정된 현재 페이지"),
                                fieldWithPath("progressPercent").description("독서 진행률 (%)"),
                                fieldWithPath("starRating").description("별점"),
                                fieldWithPath("registeredAt").description("등록일시"),
                                fieldWithPath("updatedAt").description("마지막 수정일시")
                        )
                ));
    }

    @Test
    @DisplayName("별점 수정")
    public void updateRatingTest() throws Exception {
        Map<String, Object> request = Map.of("starRating", 5);

        mockMvc.perform(patch("/dokhu/library/{userBookId}/rating", testUserBook.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request))
                        .accept(MediaType.APPLICATION_JSON)
                        .with(authentication(userAuth())))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("library-rating-update",
                        pathParameters(
                                parameterWithName("userBookId").description("서재 항목 ID")
                        ),
                        requestFields(
                                fieldWithPath("starRating").description("별점 (0~5)")
                        ),
                        responseFields(
                                fieldWithPath("id").description("서재 항목 ID"),
                                fieldWithPath("book.id").description("책 ID"),
                                fieldWithPath("book.title").description("책 제목"),
                                fieldWithPath("book.author").description("저자"),
                                fieldWithPath("book.isbn").description("ISBN").optional(),
                                fieldWithPath("book.coverImageUrl").description("표지 이미지 URL").optional(),
                                fieldWithPath("book.publisher").description("출판사").optional(),
                                fieldWithPath("book.genre").description("장르").optional(),
                                fieldWithPath("book.totalPages").description("전체 페이지 수").optional(),
                                fieldWithPath("book.publishDate").description("출판일").optional(),
                                fieldWithPath("book.synopsis").description("줄거리").optional(),
                                fieldWithPath("status").description("독서 상태"),
                                fieldWithPath("currentPage").description("현재 읽은 페이지"),
                                fieldWithPath("progressPercent").description("독서 진행률 (%)"),
                                fieldWithPath("starRating").description("수정된 별점"),
                                fieldWithPath("registeredAt").description("등록일시"),
                                fieldWithPath("updatedAt").description("마지막 수정일시")
                        )
                ));
    }

    @Test
    @DisplayName("책 삭제")
    public void deleteUserBookTest() throws Exception {
        mockMvc.perform(delete("/dokhu/library/{userBookId}", testUserBook.getId())
                        .with(authentication(userAuth())))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("library-delete",
                        pathParameters(
                                parameterWithName("userBookId").description("삭제할 서재 항목 ID")
                        )
                ));
    }
}
