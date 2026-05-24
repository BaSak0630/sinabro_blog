package org.sinabro.dokhu.controller;

import lombok.RequiredArgsConstructor;
import org.sinabro.commonness.config.auth.PrincipalDetails;
import org.sinabro.dokhu.request.FlowSessionEndRequest;
import org.sinabro.dokhu.request.FlowSessionStartRequest;
import org.sinabro.dokhu.response.FlowSessionResponse;
import org.sinabro.dokhu.service.FlowSessionService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/dokhu/sessions")
public class FlowSessionController {

    private final FlowSessionService flowSessionService;

    @PostMapping("/start")
    public FlowSessionResponse startSession(
            @AuthenticationPrincipal PrincipalDetails principal,
            @RequestBody FlowSessionStartRequest request) {
        return flowSessionService.startSession(principal.getAccount().getId(), request);
    }

    @PostMapping("/{sessionId}/end")
    public FlowSessionResponse endSession(
            @AuthenticationPrincipal PrincipalDetails principal,
            @PathVariable Long sessionId,
            @RequestBody FlowSessionEndRequest request) {
        return flowSessionService.endSession(principal.getAccount().getId(), sessionId, request);
    }

    @GetMapping("/history/{userBookId}")
    public List<FlowSessionResponse> getHistory(
            @AuthenticationPrincipal PrincipalDetails principal,
            @PathVariable Long userBookId) {
        return flowSessionService.getSessionHistory(principal.getAccount().getId(), userBookId);
    }
}
