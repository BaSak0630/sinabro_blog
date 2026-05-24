package org.sinabro.dokhu.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.sinabro.commonness.exception.UserNotFound;
import org.sinabro.commonness.user.domain.Account;
import org.sinabro.commonness.user.repository.AccountRepository;
import org.sinabro.dokhu.domain.BookMemo;
import org.sinabro.dokhu.domain.BookNote;
import org.sinabro.dokhu.domain.UserBook;
import org.sinabro.dokhu.repository.BookMemoRepository;
import org.sinabro.dokhu.repository.BookNoteRepository;
import org.sinabro.dokhu.repository.UserBookRepository;
import org.sinabro.dokhu.request.BookMemoRequest;
import org.sinabro.dokhu.request.BookNoteRequest;
import org.sinabro.dokhu.response.BookMemoResponse;
import org.sinabro.dokhu.response.BookNoteResponse;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BookNoteService {

    private final AccountRepository accountRepository;
    private final UserBookRepository userBookRepository;
    private final BookNoteRepository bookNoteRepository;
    private final BookMemoRepository bookMemoRepository;

    public BookNoteResponse getNote(Long accountId, Long userBookId) {
        UserBook userBook = getUserBook(accountId, userBookId);
        return bookNoteRepository.findByUserBook(userBook)
                .map(BookNoteResponse::new)
                .orElse(null);
    }

    @Transactional
    public BookNoteResponse saveNote(Long accountId, BookNoteRequest request) {
        Account account = accountRepository.findById(accountId).orElseThrow(UserNotFound::new);
        UserBook userBook = getUserBook(accountId, request.getUserBookId());

        BookNote note = bookNoteRepository.findByUserBook(userBook)
                .orElseGet(() -> BookNote.builder()
                        .account(account)
                        .userBook(userBook)
                        .title(request.getTitle())
                        .content(request.getContent())
                        .build());

        note.update(request.getTitle(), request.getContent());
        return new BookNoteResponse(bookNoteRepository.save(note));
    }

    public List<BookMemoResponse> getMemos(Long accountId, Long userBookId) {
        UserBook userBook = getUserBook(accountId, userBookId);
        return bookMemoRepository.findAllByUserBookOrderByCreatedAtDesc(userBook)
                .stream().map(BookMemoResponse::new).toList();
    }

    @Transactional
    public BookMemoResponse addMemo(Long accountId, BookMemoRequest request) {
        Account account = accountRepository.findById(accountId).orElseThrow(UserNotFound::new);
        UserBook userBook = getUserBook(accountId, request.getUserBookId());

        BookMemo memo = bookMemoRepository.save(BookMemo.builder()
                .account(account)
                .userBook(userBook)
                .content(request.getContent())
                .pageNumber(request.getPageNumber())
                .build());

        return new BookMemoResponse(memo);
    }

    private UserBook getUserBook(Long accountId, Long userBookId) {
        return userBookRepository.findById(userBookId)
                .filter(ub -> ub.getAccount().getId().equals(accountId))
                .orElseThrow(() -> new RuntimeException("책을 찾을 수 없습니다."));
    }
}
