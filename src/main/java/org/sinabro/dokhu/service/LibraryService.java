package org.sinabro.dokhu.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.sinabro.commonness.exception.UserNotFound;
import org.sinabro.commonness.user.domain.Account;
import org.sinabro.commonness.user.repository.AccountRepository;
import org.sinabro.dokhu.domain.Book;
import org.sinabro.dokhu.domain.ReadingStatus;
import org.sinabro.dokhu.domain.UserBook;
import org.sinabro.dokhu.repository.BookRepository;
import org.sinabro.dokhu.repository.UserBookRepository;
import org.sinabro.dokhu.request.BookProgressUpdateRequest;
import org.sinabro.dokhu.request.BookRatingUpdateRequest;
import org.sinabro.dokhu.request.BookRegisterRequest;
import org.sinabro.dokhu.response.UserBookResponse;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class LibraryService {

    private final AccountRepository accountRepository;
    private final BookRepository bookRepository;
    private final UserBookRepository userBookRepository;

    public List<UserBookResponse> getLibrary(Long accountId, String statusFilter) {
        Account account = accountRepository.findById(accountId).orElseThrow(UserNotFound::new);
        List<UserBook> userBooks;
        if (statusFilter != null && !statusFilter.isBlank()) {
            ReadingStatus status = ReadingStatus.valueOf(statusFilter.toUpperCase());
            userBooks = userBookRepository.findAllByAccountAndStatusOrderByUpdatedAtDesc(account, status);
        } else {
            userBooks = userBookRepository.findAllByAccountOrderByUpdatedAtDesc(account);
        }
        return userBooks.stream().map(UserBookResponse::new).toList();
    }

    @Transactional
    public UserBookResponse registerBook(Long accountId, BookRegisterRequest request) {
        Account account = accountRepository.findById(accountId).orElseThrow(UserNotFound::new);

        Book book = bookRepository.save(Book.builder()
                .title(request.getTitle())
                .author(request.getAuthor())
                .isbn(request.getIsbn())
                .coverImageUrl(request.getCoverImageUrl())
                .publisher(request.getPublisher())
                .genre(request.getGenre())
                .totalPages(request.getTotalPages())
                .publishDate(request.getPublishDate())
                .synopsis(request.getSynopsis())
                .build());

        UserBook userBook = userBookRepository.save(UserBook.builder()
                .account(account)
                .book(book)
                .status(ReadingStatus.ADDING)
                .build());

        return new UserBookResponse(userBook);
    }

    public UserBookResponse getUserBook(Long accountId, Long userBookId) {
        UserBook userBook = userBookRepository.findById(userBookId)
                .filter(ub -> ub.getAccount().getId().equals(accountId))
                .orElseThrow(() -> new RuntimeException("책을 찾을 수 없습니다."));
        return new UserBookResponse(userBook);
    }

    @Transactional
    public UserBookResponse updateProgress(Long accountId, Long userBookId, BookProgressUpdateRequest request) {
        UserBook userBook = userBookRepository.findById(userBookId)
                .filter(ub -> ub.getAccount().getId().equals(accountId))
                .orElseThrow(() -> new RuntimeException("책을 찾을 수 없습니다."));
        userBook.updateProgress(request.getCurrentPage());
        return new UserBookResponse(userBook);
    }

    @Transactional
    public UserBookResponse updateRating(Long accountId, Long userBookId, BookRatingUpdateRequest request) {
        UserBook userBook = userBookRepository.findById(userBookId)
                .filter(ub -> ub.getAccount().getId().equals(accountId))
                .orElseThrow(() -> new RuntimeException("책을 찾을 수 없습니다."));
        userBook.updateRating(request.getStarRating());
        return new UserBookResponse(userBook);
    }

    @Transactional
    public void deleteUserBook(Long accountId, Long userBookId) {
        UserBook userBook = userBookRepository.findById(userBookId)
                .filter(ub -> ub.getAccount().getId().equals(accountId))
                .orElseThrow(() -> new RuntimeException("책을 찾을 수 없습니다."));
        userBookRepository.delete(userBook);
    }
}
