package org.sinabro.dokhu.controller;

import lombok.RequiredArgsConstructor;
import org.sinabro.dokhu.response.NoticeResponse;
import org.sinabro.dokhu.service.NoticeService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/dokhu/notices")
public class NoticeController {

    private final NoticeService noticeService;

    @GetMapping
    public List<NoticeResponse> getNotices() {
        return noticeService.getNotices();
    }
}
