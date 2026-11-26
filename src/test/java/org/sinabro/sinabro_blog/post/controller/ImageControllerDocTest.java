package org.sinabro.sinabro_blog.post.controller;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.restdocs.RestDocumentationExtension;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.restdocs.mockmvc.MockMvcRestDocumentation.document;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.multipart;
import static org.springframework.restdocs.payload.PayloadDocumentation.fieldWithPath;
import static org.springframework.restdocs.payload.PayloadDocumentation.responseFields;
import static org.springframework.restdocs.request.RequestDocumentation.partWithName;
import static org.springframework.restdocs.request.RequestDocumentation.requestParts;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@AutoConfigureRestDocs(uriScheme = "https", uriHost = "api.sinabro.org", uriPort = 443)
@ExtendWith(RestDocumentationExtension.class)
public class ImageControllerDocTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @WithMockUser(roles = "ADMIN")
    @DisplayName("이미지 업로드")
    public void uploadImageTest() throws Exception {
        MockMultipartFile image = new MockMultipartFile(
                "image",
                "test-image.png",
                "image/png",
                "fake-image-bytes".getBytes()
        );

        mockMvc.perform(multipart("/upload/image").file(image))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("image-upload",
                        requestParts(
                                partWithName("image").description("업로드할 이미지 파일 (png, jpg 등)")
                        ),
                        responseFields(
                                fieldWithPath("url").description("업로드된 이미지의 서버 접근 경로 (예: /uploads/uuid.png)")
                        )
                ));
    }

    @Test
    @WithMockUser(roles = "USER")
    @DisplayName("관리자가 아니면 이미지 업로드 시 403과 권한 없음 메시지")
    public void uploadImageForbiddenTest() throws Exception {
        MockMultipartFile image = new MockMultipartFile("image", "test-image.png", "image/png", "x".getBytes());

        mockMvc.perform(multipart("/upload/image").file(image))
                .andExpect(status().isForbidden())
                .andExpect(jsonPath("$.message").value("권한이 없습니다."));
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    @DisplayName("이미지가 아닌 확장자는 업로드 거부")
    public void uploadNonImageRejectedTest() throws Exception {
        MockMultipartFile html = new MockMultipartFile("image", "evil.html", "text/html", "<script></script>".getBytes());

        mockMvc.perform(multipart("/upload/image").file(html))
                .andExpect(status().isBadRequest());
    }
}
