package org.sinabro.fintree.controller;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.sinabro.fintree.domain.MarketQuoteHistory;
import org.sinabro.fintree.repository.MarketQuoteHistoryRepository;
import org.sinabro.sinabro_blog.SinabroBlogApplication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.restdocs.RestDocumentationExtension;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;

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
    private MarketQuoteHistoryRepository repository;

    @AfterEach
    void clean() {
        repository.deleteAll();
    }

    @Test
    @DisplayName("시장 시세 조회")
    public void getQuotesTest() throws Exception {
        repository.save(MarketQuoteHistory.builder()
                .symbol("SPY")
                .price(512.34)
                .change(3.21)
                .changePercent(0.63)
                .marketTime(1_779_840_000L)
                .timezone("America/New_York")
                .fetchedAt(LocalDateTime.now())
                .build());

        mockMvc.perform(get("/market/quotes")
                        .accept(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("market-quotes",
                        responseFields(
                                fieldWithPath("[].symbol").description("지표 코드 (SPY, USDKRW, UST10Y, FEDFUNDS)"),
                                fieldWithPath("[].price").description("최근 수집 값 (수집된 데이터가 없으면 null)").optional(),
                                fieldWithPath("[].change").description("전일 대비 변동액 (데이터 없으면 null)").optional(),
                                fieldWithPath("[].changePercent").description("전일 대비 변동률 % (데이터 없으면 null)").optional(),
                                fieldWithPath("[].marketTime").description("기준 시각 (epoch seconds, 데이터 없으면 null)").optional(),
                                fieldWithPath("[].timezone").description("시장 타임존 (예: America/New_York, 데이터 없으면 null)").optional()
                        )
                ));
    }
}
