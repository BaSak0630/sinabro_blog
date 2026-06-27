package org.sinabro.fintree.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.sinabro.sinabro_blog.SinabroBlogApplication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.restdocs.RestDocumentationExtension;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.client.RestTemplate;

import java.time.Instant;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;
import static org.springframework.restdocs.mockmvc.MockMvcRestDocumentation.document;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.get;
import static org.springframework.restdocs.payload.PayloadDocumentation.fieldWithPath;
import static org.springframework.restdocs.payload.PayloadDocumentation.responseFields;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(classes = SinabroBlogApplication.class)
@AutoConfigureMockMvc
@AutoConfigureRestDocs(uriScheme = "https", uriHost = "api.sinabro.org", uriPort = 443)
@ExtendWith(RestDocumentationExtension.class)
public class MarketControllerDocTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private MarketController marketController;

    @MockitoBean(name = "marketRestTemplate")
    private RestTemplate restTemplate;

    private static final String VALID_CSV =
            "Date,Open,High,Low,Close,Volume\n" +
            "2026-05-24,2800.00,2850.00,2780.00,2820.00,1000000\n" +
            "2026-05-25,2820.00,2860.00,2800.00,2840.00,1100000";

    @BeforeEach
    void resetCache() {
        ReflectionTestUtils.setField(marketController, "cache", null);
        ReflectionTestUtils.setField(marketController, "cacheExpiry", Instant.MIN);
    }

    @Test
    @DisplayName("시장 시세 조회")
    public void getQuotesTest() throws Exception {
        when(restTemplate.exchange(anyString(), eq(HttpMethod.GET), any(HttpEntity.class), eq(String.class)))
                .thenReturn(ResponseEntity.ok(VALID_CSV));

        mockMvc.perform(get("/market/quotes")
                        .accept(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("market-quotes",
                        responseFields(
                                fieldWithPath("[].symbol").description("종목 코드 (예: ^KS11, ^GSPC, KRW=X)"),
                                fieldWithPath("[].price").description("현재가 (외부 API 오류 시 null)").optional(),
                                fieldWithPath("[].change").description("전일 대비 변동액 (오류 시 null)").optional(),
                                fieldWithPath("[].changePercent").description("전일 대비 변동률 % (오류 시 null)").optional(),
                                fieldWithPath("[].marketTime").description("기준 시각 (epoch seconds, 오류 시 null)").optional(),
                                fieldWithPath("[].timezone").description("시장 타임존 (예: Asia/Seoul, 오류 시 null)").optional()
                        )
                ));
    }
}
