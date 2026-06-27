package org.sinabro.commonness.admin.controller;

import lombok.RequiredArgsConstructor;
import org.sinabro.commonness.admin.request.RoleUpdateRequest;
import org.sinabro.commonness.admin.response.AdminPageResponse;
import org.sinabro.commonness.admin.response.AdminStatsResponse;
import org.sinabro.commonness.admin.response.UserAdminResponse;
import org.sinabro.commonness.admin.service.AdminService;
import org.sinabro.dokhu.request.BookRegisterRequest;
import org.sinabro.dokhu.response.BookResponse;
import org.sinabro.dokhu.service.BookService;
import org.sinabro.sinabro_blog.post.service.PostService;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;
    private final PostService postService;
    private final BookService bookService;

    @GetMapping("/stats")
    public AdminStatsResponse getStats() {
        return adminService.getStats();
    }

    @GetMapping("/users")
    public AdminPageResponse<UserAdminResponse> getUsers(
            @PageableDefault(size = 10) Pageable pageable) {
        return adminService.getUsers(pageable);
    }

    @PatchMapping("/users/{id}/role")
    public ResponseEntity<Void> updateRole(
            @PathVariable Long id,
            @RequestBody RoleUpdateRequest request) {
        adminService.updateRole(id, request.getRole());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/posts")
    public AdminPageResponse<org.sinabro.sinabro_blog.post.response.PostResponse> getPosts(
            @PageableDefault(size = 10) Pageable pageable) {
        return adminService.getPosts(pageable);
    }

    @DeleteMapping("/posts/{id}")
    public ResponseEntity<Void> deletePost(@PathVariable Long id) {
        postService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/books")
    public AdminPageResponse<BookResponse> getBooks(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size) {
        return bookService.getAdminBooks(keyword, page, size);
    }

    @PostMapping("/books")
    public BookResponse createBook(@RequestBody BookRegisterRequest request) {
        return bookService.createBook(request);
    }

    @PatchMapping("/books/{id}")
    public BookResponse updateBook(@PathVariable Long id, @RequestBody BookRegisterRequest request) {
        return bookService.updateBook(id, request);
    }

    @DeleteMapping("/books/{id}")
    public ResponseEntity<Void> deleteBook(@PathVariable Long id) {
        bookService.deleteBook(id);
        return ResponseEntity.noContent().build();
    }
}
