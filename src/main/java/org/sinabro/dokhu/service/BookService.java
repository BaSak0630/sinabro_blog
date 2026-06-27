package org.sinabro.dokhu.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.sinabro.commonness.admin.response.AdminPageResponse;
import org.sinabro.dokhu.domain.Book;
import org.sinabro.dokhu.repository.BookRepository;
import org.sinabro.dokhu.request.BookRegisterRequest;
import org.sinabro.dokhu.response.BookResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BookService {

    private final BookRepository bookRepository;

    public List<BookResponse> getBooks(String keyword, String genre, int size) {
        String kw = (keyword == null || keyword.isBlank()) ? null : keyword.trim();
        String gn = (genre == null || genre.isBlank()) ? null : genre.trim();
        return bookRepository.searchBooks(kw, gn, PageRequest.of(0, size))
                .stream().map(BookResponse::new).toList();
    }

    public BookResponse getBook(Long bookId) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new RuntimeException("책을 찾을 수 없습니다."));
        return new BookResponse(book);
    }

    public List<String> getGenres() {
        return bookRepository.findAllGenres();
    }

    public AdminPageResponse<BookResponse> getAdminBooks(String keyword, int page, int size) {
        String kw = (keyword == null || keyword.isBlank()) ? null : keyword.trim();
        Page<Book> result = bookRepository.searchBooksPage(kw, PageRequest.of(page - 1, size));
        List<BookResponse> items = result.getContent().stream().map(BookResponse::new).toList();
        return new AdminPageResponse<>(page, size, result.getTotalElements(), items);
    }

    @Transactional
    public BookResponse createBook(BookRegisterRequest request) {
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
        return new BookResponse(book);
    }

    @Transactional
    public BookResponse updateBook(Long bookId, BookRegisterRequest request) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new RuntimeException("책을 찾을 수 없습니다."));
        book.update(request.getTitle(), request.getAuthor(), request.getIsbn(),
                request.getCoverImageUrl(), request.getPublisher(), request.getGenre(),
                request.getTotalPages(), request.getPublishDate(), request.getSynopsis());
        return new BookResponse(book);
    }

    @Transactional
    public void deleteBook(Long bookId) {
        bookRepository.deleteById(bookId);
    }
}
