package org.sinabro.sinabro_blog.post.controller;

import lombok.RequiredArgsConstructor;
import org.sinabro.sinabro_blog.post.domain.Category;
import org.sinabro.sinabro_blog.post.repository.CategoryRepository;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryRepository categoryRepository;

    @GetMapping("/categories")
    public List<Category> getAll() {
        return categoryRepository.findAll();
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @PostMapping("/admin/categories")
    public Category create(@RequestBody Map<String, String> body) {
        String name = body.get("name");
        Category category = Category.builder().name(name).build();
        return categoryRepository.save(category);
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @DeleteMapping("/admin/categories/{id}")
    public void delete(@PathVariable Long id) {
        categoryRepository.deleteById(id);
    }
}
