package org.sinabro.dokhu.service;

import lombok.RequiredArgsConstructor;
import org.sinabro.dokhu.repository.NoticeRepository;
import org.sinabro.dokhu.response.NoticeResponse;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NoticeService {

    private final NoticeRepository noticeRepository;

    public List<NoticeResponse> getNotices() {
        return noticeRepository.findAllByOrderByCreatedAtDesc()
                .stream().map(NoticeResponse::new).toList();
    }
}
