package org.sinabro.dokhu.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.sinabro.commonness.config.auth.PrincipalDetails;
import org.sinabro.dokhu.request.BookProgressUpdateRequest;
import org.sinabro.dokhu.request.BookRatingUpdateRequest;
import org.sinabro.dokhu.request.BookRegisterRequest;
import org.sinabro.dokhu.response.UserBookResponse;
import org.sinabro.dokhu.service.LibraryService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/dokhu/library")
public class LibraryController {

    private final LibraryService libraryService;

    @GetMapping
    public List<UserBookResponse> getLibrary(
            @AuthenticationPrincipal PrincipalDetails principal,
            @RequestParam(required = false) String status) {
        return libraryService.getLibrary(principal.getAccount().getId(), status);
    }

    @PostMapping
    public UserBookResponse registerBook(
            @AuthenticationPrincipal PrincipalDetails principal,
            @RequestBody @Valid BookRegisterRequest request) {
        return libraryService.registerBook(principal.getAccount().getId(), request);
    }

    @GetMapping("/{userBookId}")
    public UserBookResponse getUserBook(
            @AuthenticationPrincipal PrincipalDetails principal,
            @PathVariable Long userBookId) {
        return libraryService.getUserBook(principal.getAccount().getId(), userBookId);
    }

    @PatchMapping("/{userBookId}/progress")
    public UserBookResponse updateProgress(
            @AuthenticationPrincipal PrincipalDetails principal,
            @PathVariable Long userBookId,
            @RequestBody BookProgressUpdateRequest request) {
        return libraryService.updateProgress(principal.getAccount().getId(), userBookId, request);
    }

    @PatchMapping("/{userBookId}/rating")
    public UserBookResponse updateRating(
            @AuthenticationPrincipal PrincipalDetails principal,
            @PathVariable Long userBookId,
            @RequestBody BookRatingUpdateRequest request) {
        return libraryService.updateRating(principal.getAccount().getId(), userBookId, request);
    }

    @DeleteMapping("/{userBookId}")
    public void deleteUserBook(
            @AuthenticationPrincipal PrincipalDetails principal,
            @PathVariable Long userBookId) {
        libraryService.deleteUserBook(principal.getAccount().getId(), userBookId);
    }

    @PostMapping("/from/{bookId}")
    public UserBookResponse addExistingBook(
            @AuthenticationPrincipal PrincipalDetails principal,
            @PathVariable Long bookId) {
        return libraryService.addExistingBook(principal.getAccount().getId(), bookId);
    }
}
