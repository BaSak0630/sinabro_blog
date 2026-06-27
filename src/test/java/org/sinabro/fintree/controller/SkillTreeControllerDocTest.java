package org.sinabro.fintree.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.sinabro.fintree.domain.Difficulty;
import org.sinabro.fintree.domain.NodeStatus;
import org.sinabro.fintree.domain.SkillNode;
import org.sinabro.fintree.request.QuizSubmitRequest;
import org.sinabro.fintree.response.QuizSubmitResponse;
import org.sinabro.fintree.response.SkillNodeDetailResponse;
import org.sinabro.fintree.response.SkillNodeResponse;
import org.sinabro.fintree.service.SkillTreeService;
import org.sinabro.sinabro_blog.SinabroBlogApplication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.restdocs.RestDocumentationExtension;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;
import static org.springframework.restdocs.mockmvc.MockMvcRestDocumentation.document;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.get;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.post;
import static org.springframework.restdocs.payload.PayloadDocumentation.*;
import static org.springframework.restdocs.request.RequestDocumentation.parameterWithName;
import static org.springframework.restdocs.request.RequestDocumentation.pathParameters;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(classes = SinabroBlogApplication.class)
@AutoConfigureMockMvc
@AutoConfigureRestDocs(uriScheme = "https", uriHost = "api.sinabro.org", uriPort = 443)
@ExtendWith(RestDocumentationExtension.class)
public class SkillTreeControllerDocTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockitoBean
    private SkillTreeService skillTreeService;

    private SkillNode buildNode(long id) {
        SkillNode node = SkillNode.builder()
                .title("주식 기초")
                .description("주식 시장의 기초 개념을 배웁니다.")
                .content("## 주식이란?\n주식은 회사의 소유권을 나타내는 증권입니다.")
                .difficulty(Difficulty.BEGINNER)
                .estimatedMinutes(20)
                .orderIndex(1)
                .build();
        ReflectionTestUtils.setField(node, "id", id);
        return node;
    }

    @Test
    @DisplayName("전체 스킬트리 조회")
    public void getTreeTest() throws Exception {
        SkillNode node = buildNode(1L);
        when(skillTreeService.getTree(any()))
                .thenReturn(List.of(new SkillNodeResponse(node, NodeStatus.UNLOCKED)));

        mockMvc.perform(get("/fintree/tree")
                        .accept(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("fintree-tree",
                        responseFields(
                                fieldWithPath("[].id").description("노드 ID"),
                                fieldWithPath("[].title").description("노드 제목"),
                                fieldWithPath("[].description").description("노드 설명"),
                                fieldWithPath("[].difficulty").description("난이도 (BEGINNER, INTERMEDIATE, ADVANCED)"),
                                fieldWithPath("[].estimatedMinutes").description("예상 학습 시간 (분)"),
                                fieldWithPath("[].orderIndex").description("같은 레벨 내 정렬 순서"),
                                fieldWithPath("[].status").description("학습 상태 (LOCKED, UNLOCKED, COMPLETED)"),
                                fieldWithPath("[].prerequisiteIds").description("선행 노드 ID 목록")
                        )
                ));
    }

    @Test
    @DisplayName("노드 상세 조회")
    public void getNodeDetailTest() throws Exception {
        SkillNode node = buildNode(1L);
        SkillNodeDetailResponse resp = new SkillNodeDetailResponse(node, NodeStatus.UNLOCKED, List.of());
        when(skillTreeService.getNodeDetail(eq(1L), any())).thenReturn(resp);

        mockMvc.perform(get("/fintree/nodes/{nodeId}", 1L)
                        .accept(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("fintree-node-detail",
                        pathParameters(
                                parameterWithName("nodeId").description("조회할 노드 ID")
                        ),
                        responseFields(
                                fieldWithPath("id").description("노드 ID"),
                                fieldWithPath("title").description("노드 제목"),
                                fieldWithPath("content").description("마크다운 학습 콘텐츠 (LOCKED 상태면 null)").optional(),
                                fieldWithPath("difficulty").description("난이도"),
                                fieldWithPath("estimatedMinutes").description("예상 학습 시간 (분)"),
                                fieldWithPath("status").description("학습 상태"),
                                fieldWithPath("prerequisiteIds").description("선행 노드 ID 목록"),
                                fieldWithPath("quizzes").description("퀴즈 목록 (LOCKED 상태면 빈 배열)")
                        )
                ));
    }

    @Test
    @DisplayName("퀴즈 제출")
    public void submitQuizTest() throws Exception {
        QuizSubmitResponse response = QuizSubmitResponse.builder()
                .passed(true)
                .results(Map.of(1L, true))
                .nodeCompleted(true)
                .correctCount(1)
                .totalCount(1)
                .build();
        when(skillTreeService.submitQuiz(eq(1L), any(QuizSubmitRequest.class), any()))
                .thenReturn(response);

        String requestBody = "{\"answers\":{\"1\":101}}";

        mockMvc.perform(post("/fintree/nodes/{nodeId}/quiz/submit", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody)
                        .accept(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("fintree-quiz-submit",
                        pathParameters(
                                parameterWithName("nodeId").description("퀴즈를 제출할 노드 ID")
                        ),
                        requestFields(
                                subsectionWithPath("answers").description("퀴즈 답안 (quizId → optionId 형식의 맵)")
                        ),
                        responseFields(
                                fieldWithPath("passed").description("전체 정답 여부"),
                                subsectionWithPath("results").description("퀴즈별 정답 여부 맵 (quizId → boolean)"),
                                fieldWithPath("nodeCompleted").description("이번 제출로 노드 완료 처리 여부"),
                                fieldWithPath("correctCount").description("정답 수"),
                                fieldWithPath("totalCount").description("전체 문제 수")
                        )
                ));
    }
}
