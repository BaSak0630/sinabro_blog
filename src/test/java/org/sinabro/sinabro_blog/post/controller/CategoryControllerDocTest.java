package org.sinabro.sinabro_blog.post.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.sinabro.sinabro_blog.annotation.SinabroMockUser;
import org.sinabro.sinabro_blog.post.domain.Category;
import org.sinabro.sinabro_blog.post.repository.CategoryRepository;
import org.sinabro.commonness.user.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.restdocs.RestDocumentationExtension;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Map;

import static org.springframework.http.MediaType.APPLICATION_JSON;
import static org.springframework.restdocs.mockmvc.MockMvcRestDocumentation.document;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.*;
import static org.springframework.restdocs.payload.PayloadDocumentation.*;
import static org.springframework.restdocs.request.RequestDocumentation.parameterWithName;
import static org.springframework.restdocs.request.RequestDocumentation.pathParameters;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@AutoConfigureRestDocs(uriScheme = "https", uriHost = "api.sinabro.org", uriPort = 443)
@ExtendWith(RestDocumentationExtension.class)
public class CategoryControllerDocTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private ObjectMapper objectMapper;

    @AfterEach
    public void clean() {
        categoryRepository.deleteAll();
        accountRepository.deleteAll();
    }

    @Test
    @DisplayName("카테고리 전체 조회")
    public void getCategoriesTest() throws Exception {
        // given
        categoryRepository.save(Category.builder().name("Spring").build());
        categoryRepository.save(Category.builder().name("Java").build());

        // expected
        mockMvc.perform(get("/categories")
                        .accept(APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("category-list",
                        responseFields(
                                fieldWithPath("[].id").description("카테고리 ID"),
                                fieldWithPath("[].name").description("카테고리 이름")
                        )
                ));
    }

    @Test
    @SinabroMockUser
    @DisplayName("카테고리 생성 (관리자)")
    public void createCategoryTest() throws Exception {
        // given
        Map<String, String> body = Map.of("name", "Spring");
        String json = objectMapper.writeValueAsString(body);

        // expected
        mockMvc.perform(post("/admin/categories")
                        .contentType(APPLICATION_JSON)
                        .accept(APPLICATION_JSON)
                        .content(json))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("category-create",
                        requestFields(
                                fieldWithPath("name").description("생성할 카테고리 이름")
                        ),
                        responseFields(
                                fieldWithPath("id").description("생성된 카테고리 ID"),
                                fieldWithPath("name").description("카테고리 이름")
                        )
                ));
    }

    @Test
    @SinabroMockUser
    @DisplayName("카테고리 삭제 (관리자)")
    public void deleteCategoryTest() throws Exception {
        // given
        Category category = categoryRepository.save(Category.builder().name("삭제대상카테고리").build());

        // expected
        mockMvc.perform(delete("/admin/categories/{id}", category.getId()))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("category-delete",
                        pathParameters(
                                parameterWithName("id").description("삭제할 카테고리 ID")
                        )
                ));
    }
}
