package org.sinabro.fintree.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.sinabro.commonness.config.auth.PrincipalDetails;
import org.sinabro.commonness.user.domain.LocalAccount;
import org.sinabro.commonness.user.domain.Role;
import org.sinabro.fintree.domain.NodeStatus;
import org.sinabro.fintree.request.QuizSubmitRequest;
import org.sinabro.fintree.response.*;
import org.sinabro.fintree.service.SkillTreeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.sinabro.sinabro_blog.SinabroBlogApplication;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.RequestPostProcessor;

import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.authentication;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest(classes = SinabroBlogApplication.class)
@AutoConfigureMockMvc
class SkillTreeControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockitoBean
    private SkillTreeService skillTreeService;

    private LocalAccount buildAccount() {
        LocalAccount account = LocalAccount.builder()
                .accountId("testuser1")
                .password("password1")
                .email("test@test.com")
                .username("테스트유저")
                .role(Role.USER)
                .build();
        ReflectionTestUtils.setField(account, "id", 1L);
        return account;
    }

    private RequestPostProcessor authToken(LocalAccount account) {
        PrincipalDetails principal = new PrincipalDetails(account);
        UsernamePasswordAuthenticationToken token = new UsernamePasswordAuthenticationToken(
                principal, null,
                List.of(new SimpleGrantedAuthority("ROLE_USER")));
        return authentication(token);
    }

    private org.sinabro.fintree.domain.SkillNode buildSkillNodeStub(long id) {
        org.sinabro.fintree.domain.SkillNode node = org.sinabro.fintree.domain.SkillNode.builder()
                .title("노드" + id)
                .description("설명" + id)
                .content("내용" + id)
                .difficulty(org.sinabro.fintree.domain.Difficulty.BEGINNER)
                .estimatedMinutes(10)
                .orderIndex((int) id)
                .build();
        ReflectionTestUtils.setField(node, "id", id);
        return node;
    }

    // ─────────────── GET /fintree/tree ───────────────

    @Test
    @DisplayName("비로그인 상태로 트리 조회 시 200 OK 및 JSON 배열 반환")
    void getTree_anonymous_returns200() throws Exception {
        org.sinabro.fintree.domain.SkillNode node = buildSkillNodeStub(1L);
        when(skillTreeService.getTree(null))
                .thenReturn(List.of(new SkillNodeResponse(node, NodeStatus.UNLOCKED)));

        mockMvc.perform(get("/fintree/tree"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(1))
                .andExpect(jsonPath("$[0].status").value("UNLOCKED"));
    }

    @Test
    @DisplayName("로그인 상태로 트리 조회 시 account를 service에 전달한다")
    void getTree_authenticated_passesAccount() throws Exception {
        LocalAccount account = buildAccount();
        org.sinabro.fintree.domain.SkillNode n1 = buildSkillNodeStub(1L);
        org.sinabro.fintree.domain.SkillNode n2 = buildSkillNodeStub(2L);

        when(skillTreeService.getTree(any()))
                .thenReturn(List.of(
                        new SkillNodeResponse(n1, NodeStatus.COMPLETED),
                        new SkillNodeResponse(n2, NodeStatus.UNLOCKED)));

        mockMvc.perform(get("/fintree/tree").with(authToken(account)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[0].status").value("COMPLETED"));

        verify(skillTreeService).getTree(argThat(a -> a != null));
    }

    @Test
    @DisplayName("빈 트리도 200 OK로 빈 배열 반환")
    void getTree_empty_returnsEmptyArray() throws Exception {
        when(skillTreeService.getTree(null)).thenReturn(List.of());

        mockMvc.perform(get("/fintree/tree"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(0));
    }

    // ─────────────── GET /fintree/nodes/{id} ───────────────

    @Test
    @DisplayName("비로그인 상태로 노드 상세 조회 시 200 OK")
    void getNode_anonymous_returns200() throws Exception {
        org.sinabro.fintree.domain.SkillNode node = buildSkillNodeStub(1L);
        SkillNodeDetailResponse resp = new SkillNodeDetailResponse(node, NodeStatus.UNLOCKED, List.of());

        when(skillTreeService.getNodeDetail(eq(1L), isNull())).thenReturn(resp);

        mockMvc.perform(get("/fintree/nodes/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.status").value("UNLOCKED"))
                .andExpect(jsonPath("$.content").isNotEmpty());
    }

    @Test
    @DisplayName("LOCKED 노드 상세 조회 시 content는 null")
    void getNode_locked_contentIsNull() throws Exception {
        org.sinabro.fintree.domain.SkillNode node = buildSkillNodeStub(2L);
        node.addPrerequisite(buildSkillNodeStub(1L));
        SkillNodeDetailResponse resp = new SkillNodeDetailResponse(node, NodeStatus.LOCKED, List.of());

        when(skillTreeService.getNodeDetail(eq(2L), isNull())).thenReturn(resp);

        mockMvc.perform(get("/fintree/nodes/2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("LOCKED"))
                .andExpect(jsonPath("$.content").doesNotExist());
    }

    @Test
    @DisplayName("존재하지 않는 노드 조회 시 404 반환")
    void getNode_notFound_returns404() throws Exception {
        when(skillTreeService.getNodeDetail(eq(999L), any()))
                .thenThrow(new java.util.NoSuchElementException("노드를 찾을 수 없습니다."));

        mockMvc.perform(get("/fintree/nodes/999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.message").value("노드를 찾을 수 없습니다."));
    }

    // ─────────────── POST /fintree/nodes/{id}/quiz/submit ───────────────

    @Test
    @DisplayName("로그인 상태로 퀴즈 제출 시 200 OK 및 결과 반환")
    void submitQuiz_authenticated_returns200() throws Exception {
        LocalAccount account = buildAccount();

        QuizSubmitResponse response = QuizSubmitResponse.builder()
                .passed(true)
                .results(Map.of(10L, true))
                .nodeCompleted(true)
                .correctCount(1)
                .totalCount(1)
                .build();

        when(skillTreeService.submitQuiz(eq(1L), any(QuizSubmitRequest.class), any()))
                .thenReturn(response);

        QuizSubmitRequest request = new QuizSubmitRequest();
        ReflectionTestUtils.setField(request, "answers", Map.of(10L, 101L));

        mockMvc.perform(post("/fintree/nodes/1/quiz/submit")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request))
                        .with(authToken(account)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.passed").value(true))
                .andExpect(jsonPath("$.nodeCompleted").value(true))
                .andExpect(jsonPath("$.correctCount").value(1))
                .andExpect(jsonPath("$.totalCount").value(1));
    }

    @Test
    @DisplayName("비로그인 상태로 퀴즈 제출 시 200 OK (account null 허용)")
    void submitQuiz_anonymous_returns200() throws Exception {
        QuizSubmitResponse response = QuizSubmitResponse.builder()
                .passed(false)
                .results(Map.of(10L, false))
                .nodeCompleted(false)
                .correctCount(0)
                .totalCount(1)
                .build();

        when(skillTreeService.submitQuiz(eq(1L), any(QuizSubmitRequest.class), isNull()))
                .thenReturn(response);

        QuizSubmitRequest request = new QuizSubmitRequest();
        ReflectionTestUtils.setField(request, "answers", Map.of(10L, 102L));

        mockMvc.perform(post("/fintree/nodes/1/quiz/submit")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.passed").value(false))
                .andExpect(jsonPath("$.nodeCompleted").value(false));
    }

    @Test
    @DisplayName("퀴즈 제출 시 nodeId가 service로 정확히 전달된다")
    void submitQuiz_passesNodeIdToService() throws Exception {
        LocalAccount account = buildAccount();

        QuizSubmitResponse response = QuizSubmitResponse.builder()
                .passed(true).results(Map.of()).nodeCompleted(false)
                .correctCount(0).totalCount(0).build();

        when(skillTreeService.submitQuiz(eq(42L), any(), any())).thenReturn(response);

        QuizSubmitRequest request = new QuizSubmitRequest();
        ReflectionTestUtils.setField(request, "answers", Map.of());

        mockMvc.perform(post("/fintree/nodes/42/quiz/submit")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request))
                        .with(authToken(account)))
                .andExpect(status().isOk());

        verify(skillTreeService).submitQuiz(eq(42L), any(), any());
    }
}
