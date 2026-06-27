package org.sinabro.fintree.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.sinabro.commonness.user.domain.LocalAccount;
import org.sinabro.fintree.domain.*;
import org.sinabro.fintree.repository.*;
import org.sinabro.fintree.request.QuizSubmitRequest;
import org.sinabro.fintree.response.QuizSubmitResponse;
import org.sinabro.fintree.response.SkillNodeDetailResponse;
import org.sinabro.fintree.response.SkillNodeResponse;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.*;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class SkillTreeServiceTest {

    @Mock private SkillNodeRepository skillNodeRepository;
    @Mock private UserNodeProgressRepository progressRepository;
    @Mock private QuizRepository quizRepository;
    @Mock private QuizAttemptRepository quizAttemptRepository;

    @InjectMocks
    private SkillTreeService skillTreeService;

    private SkillNode rootNode;
    private SkillNode childNode;
    private LocalAccount account;

    @BeforeEach
    void setUp() {
        rootNode = SkillNode.builder()
                .title("투자 기초")
                .description("투자의 기본 개념")
                .content("## 투자란?\n투자는...")
                .difficulty(Difficulty.BEGINNER)
                .estimatedMinutes(10)
                .orderIndex(1)
                .build();
        ReflectionTestUtils.setField(rootNode, "id", 1L);

        childNode = SkillNode.builder()
                .title("주식 투자")
                .description("주식 시장의 이해")
                .content("## 주식이란?\n주식은...")
                .difficulty(Difficulty.INTERMEDIATE)
                .estimatedMinutes(20)
                .orderIndex(2)
                .build();
        ReflectionTestUtils.setField(childNode, "id", 2L);
        childNode.addPrerequisite(rootNode);

        account = LocalAccount.builder()
                .accountId("testuser1")
                .password("password1")
                .email("test@test.com")
                .username("테스트유저")
                .build();
        ReflectionTestUtils.setField(account, "id", 1L);
    }

    // ─────────────── getTree ───────────────

    @Test
    @DisplayName("비로그인 시 선행 없는 노드는 UNLOCKED 반환")
    void getTree_anonymous_noPrereq_unlocked() {
        when(skillNodeRepository.findAllOrdered()).thenReturn(List.of(rootNode));

        List<SkillNodeResponse> result = skillTreeService.getTree(null);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getStatus()).isEqualTo(NodeStatus.UNLOCKED);
        verifyNoInteractions(progressRepository);
    }

    @Test
    @DisplayName("비로그인 시 선행 있는 노드는 LOCKED 반환")
    void getTree_anonymous_withPrereq_locked() {
        when(skillNodeRepository.findAllOrdered()).thenReturn(List.of(rootNode, childNode));

        List<SkillNodeResponse> result = skillTreeService.getTree(null);

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getStatus()).isEqualTo(NodeStatus.UNLOCKED);
        assertThat(result.get(1).getStatus()).isEqualTo(NodeStatus.LOCKED);
    }

    @Test
    @DisplayName("로그인 시 완료 노드는 COMPLETED, 선행 완료된 노드는 UNLOCKED")
    void getTree_loggedIn_completedAndUnlocked() {
        UserNodeProgress progress = UserNodeProgress.builder()
                .account(account)
                .skillNode(rootNode)
                .build();

        when(skillNodeRepository.findAllOrdered()).thenReturn(List.of(rootNode, childNode));
        when(progressRepository.findAllByAccount(account)).thenReturn(List.of(progress));

        List<SkillNodeResponse> result = skillTreeService.getTree(account);

        assertThat(result.get(0).getStatus()).isEqualTo(NodeStatus.COMPLETED);
        assertThat(result.get(1).getStatus()).isEqualTo(NodeStatus.UNLOCKED);
    }

    @Test
    @DisplayName("로그인 시 선행 미완료 노드는 LOCKED 유지")
    void getTree_loggedIn_prereqNotDone_stillLocked() {
        when(skillNodeRepository.findAllOrdered()).thenReturn(List.of(rootNode, childNode));
        when(progressRepository.findAllByAccount(account)).thenReturn(List.of());

        List<SkillNodeResponse> result = skillTreeService.getTree(account);

        assertThat(result.get(1).getStatus()).isEqualTo(NodeStatus.LOCKED);
    }

    @Test
    @DisplayName("prerequisiteIds 가 응답에 포함된다")
    void getTree_prerequisiteIds_included() {
        when(skillNodeRepository.findAllOrdered()).thenReturn(List.of(rootNode, childNode));

        List<SkillNodeResponse> result = skillTreeService.getTree(null);

        assertThat(result.get(0).getPrerequisiteIds()).isEmpty();
        assertThat(result.get(1).getPrerequisiteIds()).containsExactly(1L);
    }

    // ─────────────── getNodeDetail ───────────────

    @Test
    @DisplayName("UNLOCKED 노드 상세 조회 시 content와 퀴즈를 반환한다")
    void getNodeDetail_unlocked_returnsContentAndQuizzes() {
        Quiz quiz = Quiz.builder().skillNode(rootNode).question("투자란?").build();
        ReflectionTestUtils.setField(quiz, "id", 10L);

        when(skillNodeRepository.findById(1L)).thenReturn(Optional.of(rootNode));
        when(quizRepository.findAllBySkillNodeId(1L)).thenReturn(List.of(quiz));

        SkillNodeDetailResponse resp = skillTreeService.getNodeDetail(1L, null);

        assertThat(resp.getStatus()).isEqualTo(NodeStatus.UNLOCKED);
        assertThat(resp.getContent()).isNotNull();
        assertThat(resp.getQuizzes()).hasSize(1);
    }

    @Test
    @DisplayName("LOCKED 노드 상세 조회 시 content는 null, 퀴즈는 빈 목록")
    void getNodeDetail_locked_masksContent() {
        when(skillNodeRepository.findById(2L)).thenReturn(Optional.of(childNode));
        when(quizRepository.findAllBySkillNodeId(2L)).thenReturn(List.of());

        SkillNodeDetailResponse resp = skillTreeService.getNodeDetail(2L, null);

        assertThat(resp.getStatus()).isEqualTo(NodeStatus.LOCKED);
        assertThat(resp.getContent()).isNull();
        assertThat(resp.getQuizzes()).isEmpty();
    }

    @Test
    @DisplayName("존재하지 않는 노드 조회 시 NoSuchElementException 발생")
    void getNodeDetail_notFound_throws() {
        when(skillNodeRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> skillTreeService.getNodeDetail(999L, null))
                .isInstanceOf(NoSuchElementException.class);
    }

    // ─────────────── submitQuiz ───────────────

    private Quiz buildQuizWithOptions(long quizId, long correctOptionId, long wrongOptionId) {
        Quiz quiz = Quiz.builder().skillNode(rootNode).question("질문").build();
        ReflectionTestUtils.setField(quiz, "id", quizId);

        QuizOption correct = QuizOption.builder().text("정답").correct(true).build();
        ReflectionTestUtils.setField(correct, "id", correctOptionId);

        QuizOption wrong = QuizOption.builder().text("오답").correct(false).build();
        ReflectionTestUtils.setField(wrong, "id", wrongOptionId);

        quiz.addOption(correct);
        quiz.addOption(wrong);
        return quiz;
    }

    @Test
    @DisplayName("모든 정답 선택 시 passed=true, 로그인 상태면 nodeCompleted=true")
    void submitQuiz_allCorrect_passedAndCompleted() {
        Quiz quiz = buildQuizWithOptions(10L, 101L, 102L);

        when(quizRepository.findAllBySkillNodeId(1L)).thenReturn(List.of(quiz));
        when(skillNodeRepository.findById(1L)).thenReturn(Optional.of(rootNode));
        when(progressRepository.existsByAccountAndSkillNode(account, rootNode)).thenReturn(false);

        QuizSubmitRequest request = new QuizSubmitRequest();
        ReflectionTestUtils.setField(request, "answers", Map.of(10L, 101L));

        QuizSubmitResponse resp = skillTreeService.submitQuiz(1L, request, account);

        assertThat(resp.isPassed()).isTrue();
        assertThat(resp.isNodeCompleted()).isTrue();
        assertThat(resp.getCorrectCount()).isEqualTo(1);
        assertThat(resp.getTotalCount()).isEqualTo(1);
        assertThat(resp.getResults()).containsEntry(10L, true);

        verify(progressRepository).save(any(UserNodeProgress.class));
        verify(quizAttemptRepository).save(any(QuizAttempt.class));
    }

    @Test
    @DisplayName("오답 선택 시 passed=false, nodeCompleted=false")
    void submitQuiz_wrongAnswer_fails() {
        Quiz quiz = buildQuizWithOptions(10L, 101L, 102L);

        when(quizRepository.findAllBySkillNodeId(1L)).thenReturn(List.of(quiz));

        QuizSubmitRequest request = new QuizSubmitRequest();
        ReflectionTestUtils.setField(request, "answers", Map.of(10L, 102L)); // 오답

        QuizSubmitResponse resp = skillTreeService.submitQuiz(1L, request, account);

        assertThat(resp.isPassed()).isFalse();
        assertThat(resp.isNodeCompleted()).isFalse();
        assertThat(resp.getCorrectCount()).isEqualTo(0);
        assertThat(resp.getResults()).containsEntry(10L, false);
        verify(progressRepository, never()).save(any());
    }

    @Test
    @DisplayName("비로그인 상태에서 정답 제출 시 attempt/progress 저장 안 함")
    void submitQuiz_anonymous_noSave() {
        Quiz quiz = buildQuizWithOptions(10L, 101L, 102L);

        when(quizRepository.findAllBySkillNodeId(1L)).thenReturn(List.of(quiz));

        QuizSubmitRequest request = new QuizSubmitRequest();
        ReflectionTestUtils.setField(request, "answers", Map.of(10L, 101L)); // 정답

        QuizSubmitResponse resp = skillTreeService.submitQuiz(1L, request, null);

        assertThat(resp.isPassed()).isTrue();
        assertThat(resp.isNodeCompleted()).isFalse();
        verifyNoInteractions(quizAttemptRepository);
        verifyNoInteractions(progressRepository);
    }

    @Test
    @DisplayName("이미 완료된 노드 재제출 시 nodeCompleted=false (중복 방지)")
    void submitQuiz_alreadyCompleted_nodeCompletedFalse() {
        Quiz quiz = buildQuizWithOptions(10L, 101L, 102L);

        when(quizRepository.findAllBySkillNodeId(1L)).thenReturn(List.of(quiz));
        when(skillNodeRepository.findById(1L)).thenReturn(Optional.of(rootNode));
        when(progressRepository.existsByAccountAndSkillNode(account, rootNode)).thenReturn(true);

        QuizSubmitRequest request = new QuizSubmitRequest();
        ReflectionTestUtils.setField(request, "answers", Map.of(10L, 101L));

        QuizSubmitResponse resp = skillTreeService.submitQuiz(1L, request, account);

        assertThat(resp.isPassed()).isTrue();
        assertThat(resp.isNodeCompleted()).isFalse();
        verify(progressRepository, never()).save(any());
    }

    @Test
    @DisplayName("답변에 없는 quizId는 오답 처리된다")
    void submitQuiz_missingAnswer_treatedAsWrong() {
        Quiz quiz = buildQuizWithOptions(10L, 101L, 102L);

        when(quizRepository.findAllBySkillNodeId(1L)).thenReturn(List.of(quiz));

        QuizSubmitRequest request = new QuizSubmitRequest();
        ReflectionTestUtils.setField(request, "answers", Map.of()); // 답변 없음

        QuizSubmitResponse resp = skillTreeService.submitQuiz(1L, request, account);

        assertThat(resp.isPassed()).isFalse();
        assertThat(resp.getResults()).containsEntry(10L, false);
    }

    @Test
    @DisplayName("복수 퀴즈 중 일부만 정답이면 passed=false")
    void submitQuiz_partialCorrect_fails() {
        Quiz quiz1 = buildQuizWithOptions(10L, 101L, 102L);
        Quiz quiz2 = buildQuizWithOptions(20L, 201L, 202L);

        when(quizRepository.findAllBySkillNodeId(1L)).thenReturn(List.of(quiz1, quiz2));

        QuizSubmitRequest request = new QuizSubmitRequest();
        ReflectionTestUtils.setField(request, "answers", Map.of(10L, 101L, 20L, 202L)); // 1정답 1오답

        QuizSubmitResponse resp = skillTreeService.submitQuiz(1L, request, account);

        assertThat(resp.isPassed()).isFalse();
        assertThat(resp.getCorrectCount()).isEqualTo(1);
        assertThat(resp.getTotalCount()).isEqualTo(2);
    }
}
