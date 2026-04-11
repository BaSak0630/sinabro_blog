package org.sinabro.fintree.controller;

import lombok.RequiredArgsConstructor;
import org.sinabro.commonness.config.auth.PrincipalDetails;
import org.sinabro.fintree.request.QuizSubmitRequest;
import org.sinabro.fintree.response.QuizSubmitResponse;
import org.sinabro.fintree.response.SkillNodeDetailResponse;
import org.sinabro.fintree.response.SkillNodeResponse;
import org.sinabro.fintree.service.SkillTreeService;
import org.sinabro.commonness.user.domain.Account;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/fintree")
public class SkillTreeController {
    private final SkillTreeService skillTreeService;

    /** 전체 스킬트리 조회 (비로그인 가능) */
    @GetMapping("/tree")
    public List<SkillNodeResponse> getTree(
            @AuthenticationPrincipal PrincipalDetails principalDetails) {
        Account account = principalDetails != null ? principalDetails.getAccount() : null;
        return skillTreeService.getTree(account);
    }

    /** 노드 상세 + 학습 컨텐츠 + 퀴즈 */
    @GetMapping("/nodes/{nodeId}")
    public SkillNodeDetailResponse getNode(
            @PathVariable Long nodeId,
            @AuthenticationPrincipal PrincipalDetails principalDetails) {
        Account account = principalDetails != null ? principalDetails.getAccount() : null;
        return skillTreeService.getNodeDetail(nodeId, account);
    }

    /** 퀴즈 제출 */
    @PostMapping("/nodes/{nodeId}/quiz/submit")
    public QuizSubmitResponse submitQuiz(
            @PathVariable Long nodeId,
            @RequestBody QuizSubmitRequest request,
            @AuthenticationPrincipal PrincipalDetails principalDetails) {
        Account account = principalDetails != null ? principalDetails.getAccount() : null;
        return skillTreeService.submitQuiz(nodeId, request, account);
    }
}
