package org.sinabro.dokhu.controller;

import lombok.RequiredArgsConstructor;
import org.sinabro.commonness.config.auth.PrincipalDetails;
import org.sinabro.dokhu.request.BookMemoRequest;
import org.sinabro.dokhu.request.BookNoteRequest;
import org.sinabro.dokhu.response.BookMemoResponse;
import org.sinabro.dokhu.response.BookNoteResponse;
import org.sinabro.dokhu.service.BookNoteService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/dokhu")
public class BookNoteController {

    private final BookNoteService bookNoteService;

    @GetMapping("/notes/{userBookId}")
    public BookNoteResponse getNote(
            @AuthenticationPrincipal PrincipalDetails principal,
            @PathVariable Long userBookId) {
        return bookNoteService.getNote(principal.getAccount().getId(), userBookId);
    }

    @PostMapping("/notes")
    public BookNoteResponse saveNote(
            @AuthenticationPrincipal PrincipalDetails principal,
            @RequestBody BookNoteRequest request) {
        return bookNoteService.saveNote(principal.getAccount().getId(), request);
    }

    @GetMapping("/memos/{userBookId}")
    public List<BookMemoResponse> getMemos(
            @AuthenticationPrincipal PrincipalDetails principal,
            @PathVariable Long userBookId) {
        return bookNoteService.getMemos(principal.getAccount().getId(), userBookId);
    }

    @PostMapping("/memos")
    public BookMemoResponse addMemo(
            @AuthenticationPrincipal PrincipalDetails principal,
            @RequestBody BookMemoRequest request) {
        return bookNoteService.addMemo(principal.getAccount().getId(), request);
    }
}
