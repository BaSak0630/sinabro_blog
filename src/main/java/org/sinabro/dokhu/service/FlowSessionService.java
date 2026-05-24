package org.sinabro.dokhu.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.sinabro.commonness.exception.UserNotFound;
import org.sinabro.commonness.user.domain.Account;
import org.sinabro.commonness.user.repository.AccountRepository;
import org.sinabro.dokhu.domain.FlowSession;
import org.sinabro.dokhu.domain.UserBook;
import org.sinabro.dokhu.repository.FlowSessionRepository;
import org.sinabro.dokhu.repository.UserBookRepository;
import org.sinabro.dokhu.request.FlowSessionEndRequest;
import org.sinabro.dokhu.request.FlowSessionStartRequest;
import org.sinabro.dokhu.response.FlowSessionResponse;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FlowSessionService {

    private final AccountRepository accountRepository;
    private final UserBookRepository userBookRepository;
    private final FlowSessionRepository flowSessionRepository;

    @Transactional
    public FlowSessionResponse startSession(Long accountId, FlowSessionStartRequest request) {
        Account account = accountRepository.findById(accountId).orElseThrow(UserNotFound::new);
        UserBook userBook = userBookRepository.findById(request.getUserBookId())
                .filter(ub -> ub.getAccount().getId().equals(accountId))
                .orElseThrow(() -> new RuntimeException("책을 찾을 수 없습니다."));

        FlowSession session = flowSessionRepository.save(FlowSession.builder()
                .account(account)
                .userBook(userBook)
                .videoUrl(request.getVideoUrl())
                .build());

        return new FlowSessionResponse(session);
    }

    @Transactional
    public FlowSessionResponse endSession(Long accountId, Long sessionId, FlowSessionEndRequest request) {
        FlowSession session = flowSessionRepository.findById(sessionId)
                .filter(s -> s.getAccount().getId().equals(accountId))
                .orElseThrow(() -> new RuntimeException("세션을 찾을 수 없습니다."));

        session.end(request.getMemo(), request.getBookmarkPage());
        return new FlowSessionResponse(session);
    }

    public List<FlowSessionResponse> getSessionHistory(Long accountId, Long userBookId) {
        UserBook userBook = userBookRepository.findById(userBookId)
                .filter(ub -> ub.getAccount().getId().equals(accountId))
                .orElseThrow(() -> new RuntimeException("책을 찾을 수 없습니다."));
        return flowSessionRepository.findAllByUserBookOrderByStartTimeDesc(userBook)
                .stream().map(FlowSessionResponse::new).toList();
    }
}
