package org.sinabro.dokhu.controller;

import lombok.RequiredArgsConstructor;
import org.sinabro.dokhu.response.BookResponse;
import org.sinabro.dokhu.service.BookService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/dokhu/books")
public class BookController {

    private final BookService bookService;

    @GetMapping
    public List<BookResponse> getBooks(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String genre,
            @RequestParam(defaultValue = "60") int size) {
        return bookService.getBooks(keyword, genre, size);
    }

    @GetMapping("/{bookId}")
    public BookResponse getBook(@PathVariable Long bookId) {
        return bookService.getBook(bookId);
    }

    @GetMapping("/genres")
    public List<String> getGenres() {
        return bookService.getGenres();
    }
}
