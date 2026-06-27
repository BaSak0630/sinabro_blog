package org.sinabro.dokhu.controller;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.sinabro.commonness.user.repository.AccountRepository;
import org.sinabro.dokhu.domain.Notice;
import org.sinabro.dokhu.repository.NoticeRepository;
import org.sinabro.sinabro_blog.SinabroBlogApplication;
import org.sinabro.sinabro_blog.post.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.restdocs.RestDocumentationExtension;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.restdocs.mockmvc.MockMvcRestDocumentation.document;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.get;
import static org.springframework.restdocs.payload.PayloadDocumentation.fieldWithPath;
import static org.springframework.restdocs.payload.PayloadDocumentation.responseFields;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(classes = SinabroBlogApplication.class)
@AutoConfigureMockMvc
@AutoConfigureRestDocs(uriScheme = "https", uriHost = "api.sinabro.org", uriPort = 443)
@ExtendWith(RestDocumentationExtension.class)
public class NoticeControllerDocTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private NoticeRepository noticeRepository;

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private AccountRepository accountRepository;

    @BeforeEach
    public void setUp() {
        noticeRepository.deleteAll();
        postRepository.deleteAll();
        accountRepository.deleteAll();
    }

    @AfterEach
    public void clean() {
        noticeRepository.deleteAll();
        postRepository.deleteAll();
        accountRepository.deleteAll();
    }

    @Test
    @DisplayName("공지사항 목록 조회")
    public void getNoticesTest() throws Exception {
        noticeRepository.save(Notice.builder()
                .title("서비스 점검 안내")
                .content("2026-05-30 02:00~04:00 점검 예정입니다.")
                .build());
        noticeRepository.save(Notice.builder()
                .title("신규 기능 안내")
                .content("독후 기능이 추가되었습니다.")
                .build());

        mockMvc.perform(get("/dokhu/notices")
                        .accept(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("notice-list",
                        responseFields(
                                fieldWithPath("[].id").description("공지 ID"),
                                fieldWithPath("[].title").description("공지 제목"),
                                fieldWithPath("[].content").description("공지 내용"),
                                fieldWithPath("[].createdAt").description("작성일시")
                        )
                ));
    }
}
