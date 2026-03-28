package org.sinabro.fintree.service;

import lombok.RequiredArgsConstructor;
import org.sinabro.fintree.domain.*;
import org.sinabro.fintree.repository.*;
import org.sinabro.fintree.request.QuizSubmitRequest;
import org.sinabro.fintree.response.QuizSubmitResponse;
import org.sinabro.fintree.response.SkillNodeDetailResponse;
import org.sinabro.fintree.response.SkillNodeResponse;
import org.sinabro.commonness.user.domain.Account;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SkillTreeService {

    private final SkillNodeRepository skillNodeRepository;
    private final UserNodeProgressRepository progressRepository;
    private final QuizRepository quizRepository;
    private final QuizAttemptRepository quizAttemptRepository;

    /** 전체 트리 조회 — 비로그인 시 account null */
    public List<SkillNodeResponse> getTree(Account account) {
        List<SkillNode> nodes = skillNodeRepository.findAllOrdered();
        Set<Long> completedIds = getCompletedIds(account);

        return nodes.stream()
                .map(n -> new SkillNodeResponse(n, computeStatus(n, completedIds)))
                .toList();
    }

    /** 노드 상세 + 퀴즈 조회 */
    public SkillNodeDetailResponse getNodeDetail(Long nodeId, Account account) {
        SkillNode node = skillNodeRepository.findById(nodeId)
                .orElseThrow(() -> new NoSuchElementException("노드를 찾을 수 없습니다."));
        Set<Long> completedIds = getCompletedIds(account);
        NodeStatus status = computeStatus(node, completedIds);

        List<Quiz> quizzes = quizRepository.findAllBySkillNodeId(nodeId);
        return new SkillNodeDetailResponse(node, status, quizzes);
    }

    /** 퀴즈 제출 — 전부 정답이면 노드 완료 처리 + 다음 노드 잠금 해제 */
    @Transactional
    public QuizSubmitResponse submitQuiz(Long nodeId, QuizSubmitRequest request, Account account) {
        List<Quiz> quizzes = quizRepository.findAllBySkillNodeId(nodeId);
        Map<Long, Long> answers = request.getAnswers(); // quizId -> optionId

        Map<Long, Boolean> results = new LinkedHashMap<>();
        int correct = 0;

        for (Quiz quiz : quizzes) {
            Long selectedOptionId = answers.get(quiz.getId());
            QuizOption selectedOption = quiz.getOptions().stream()
                    .filter(o -> o.getId().equals(selectedOptionId))
                    .findFirst()
                    .orElse(null);

            boolean isCorrect = selectedOption != null && selectedOption.isCorrect();
            results.put(quiz.getId(), isCorrect);
            if (isCorrect) correct++;

            if (selectedOption != null && account != null) {
                quizAttemptRepository.save(QuizAttempt.builder()
                        .account(account)
                        .quiz(quiz)
                        .selectedOption(selectedOption)
                        .correct(isCorrect)
                        .build());
            }
        }

        boolean passed = correct == quizzes.size();
        boolean nodeCompleted = false;

        if (passed && account != null) {
            SkillNode node = skillNodeRepository.findById(nodeId)
                    .orElseThrow(() -> new NoSuchElementException("노드를 찾을 수 없습니다."));
            if (!progressRepository.existsByAccountAndSkillNode(account, node)) {
                progressRepository.save(UserNodeProgress.builder()
                        .account(account)
                        .skillNode(node)
                        .build());
                nodeCompleted = true;
            }
        }

        return QuizSubmitResponse.builder()
                .passed(passed)
                .results(results)
                .nodeCompleted(nodeCompleted)
                .correctCount(correct)
                .totalCount(quizzes.size())
                .build();
    }

    // -------- private --------

    private Set<Long> getCompletedIds(Account account) {
        if (account == null) return Set.of();
        return progressRepository.findAllByAccount(account).stream()
                .map(p -> p.getSkillNode().getId())
                .collect(Collectors.toSet());
    }

    private NodeStatus computeStatus(SkillNode node, Set<Long> completedIds) {
        if (completedIds.contains(node.getId())) return NodeStatus.COMPLETED;
        boolean allPrereqsDone = node.getPrerequisites().stream()
                .allMatch(p -> completedIds.contains(p.getId()));
        return allPrereqsDone ? NodeStatus.UNLOCKED : NodeStatus.LOCKED;
    }
}
