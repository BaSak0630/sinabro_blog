package org.sinabro.fintree.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.sinabro.fintree.response.MarketQuote;
import org.sinabro.sinabro_blog.SinabroBlogApplication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.web.client.RestTemplate;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest(classes = SinabroBlogApplication.class)
@AutoConfigureMockMvc
class MarketControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private MarketController marketController;

    @Autowired
    private ObjectMapper objectMapper;

    @MockitoBean(name = "marketRestTemplate")
    private RestTemplate restTemplate;

    private static final String VALID_CSV =
            "Date,Open,High,Low,Close,Volume\n" +
            "2024-01-15,100.00,110.00,95.00,105.00,1000000\n" +
            "2024-01-16,105.00,115.00,100.00,108.00,1100000";

    @BeforeEach
    void resetCache() {
        ReflectionTestUtils.setField(marketController, "cache", null);
        ReflectionTestUtils.setField(marketController, "cacheExpiry", Instant.MIN);
    }

    @Test
    @DisplayName("정상 응답 시 6개 지표가 반환된다")
    void getQuotes_success_returns6Symbols() throws Exception {
        when(restTemplate.exchange(anyString(), eq(HttpMethod.GET), any(HttpEntity.class), eq(String.class)))
                .thenReturn(ResponseEntity.ok(VALID_CSV));

        MvcResult result = mockMvc.perform(get("/market/quotes"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith("application/json"))
                .andReturn();

        List<MarketQuote> quotes = objectMapper.readValue(
                result.getResponse().getContentAsString(),
                new TypeReference<>() {});

        assertThat(quotes).hasSize(6);
        assertThat(quotes).allMatch(q -> q.symbol() != null);
    }

    @Test
    @DisplayName("정상 응답 시 가격·변화량·변화율·마켓타임이 파싱된다")
    void getQuotes_success_parsesFields() throws Exception {
        when(restTemplate.exchange(anyString(), eq(HttpMethod.GET), any(HttpEntity.class), eq(String.class)))
                .thenReturn(ResponseEntity.ok(VALID_CSV));

        MvcResult result = mockMvc.perform(get("/market/quotes"))
                .andExpect(status().isOk())
                .andReturn();

        List<MarketQuote> quotes = objectMapper.readValue(
                result.getResponse().getContentAsString(),
                new TypeReference<>() {});

        MarketQuote any = quotes.stream().filter(q -> q.price() != null).findFirst().orElseThrow();
        assertThat(any.price()).isEqualTo(108.0);
        assertThat(any.change()).isEqualTo(3.0);
        assertThat(any.marketTime()).isNotNull();
        assertThat(any.timezone()).isNotNull();
    }

    @Test
    @DisplayName("캐시 히트 시 Stooq API를 재호출하지 않는다")
    void getQuotes_cacheHit_doesNotCallApiTwice() throws Exception {
        when(restTemplate.exchange(anyString(), eq(HttpMethod.GET), any(HttpEntity.class), eq(String.class)))
                .thenReturn(ResponseEntity.ok(VALID_CSV));

        mockMvc.perform(get("/market/quotes")).andExpect(status().isOk());
        mockMvc.perform(get("/market/quotes")).andExpect(status().isOk());

        // 6 symbols × 1 call (second request hits cache)
        verify(restTemplate, times(6))
                .exchange(anyString(), eq(HttpMethod.GET), any(HttpEntity.class), eq(String.class));
    }

    @Test
    @DisplayName("캐시 만료 후 재요청 시 API를 다시 호출한다")
    void getQuotes_expiredCache_refetches() throws Exception {
        when(restTemplate.exchange(anyString(), eq(HttpMethod.GET), any(HttpEntity.class), eq(String.class)))
                .thenReturn(ResponseEntity.ok(VALID_CSV));

        mockMvc.perform(get("/market/quotes")).andExpect(status().isOk());

        // 캐시를 강제 만료
        ReflectionTestUtils.setField(marketController, "cacheExpiry", Instant.MIN);

        mockMvc.perform(get("/market/quotes")).andExpect(status().isOk());

        // 6 symbols × 2 calls
        verify(restTemplate, times(12))
                .exchange(anyString(), eq(HttpMethod.GET), any(HttpEntity.class), eq(String.class));
    }

    @Test
    @DisplayName("Stooq API 오류 시 해당 지표의 price는 null이고 나머지 6개는 모두 반환된다")
    void getQuotes_apiError_returnsNullPrice() throws Exception {
        when(restTemplate.exchange(anyString(), eq(HttpMethod.GET), any(HttpEntity.class), eq(String.class)))
                .thenThrow(new RuntimeException("connection timeout"));

        MvcResult result = mockMvc.perform(get("/market/quotes"))
                .andExpect(status().isOk())
                .andReturn();

        List<MarketQuote> quotes = objectMapper.readValue(
                result.getResponse().getContentAsString(),
                new TypeReference<>() {});

        assertThat(quotes).hasSize(6);
        assertThat(quotes).allMatch(q -> q.price() == null);
    }

    @Test
    @DisplayName("CSV 데이터 행이 1개뿐일 때 변화량 0으로 반환된다")
    void getQuotes_singleRow_zeroChange() throws Exception {
        String singleRowCsv =
                "Date,Open,High,Low,Close,Volume\n" +
                "2024-01-16,105.00,115.00,100.00,200.00,1100000";

        when(restTemplate.exchange(anyString(), eq(HttpMethod.GET), any(HttpEntity.class), eq(String.class)))
                .thenReturn(ResponseEntity.ok(singleRowCsv));

        MvcResult result = mockMvc.perform(get("/market/quotes"))
                .andExpect(status().isOk())
                .andReturn();

        List<MarketQuote> quotes = objectMapper.readValue(
                result.getResponse().getContentAsString(),
                new TypeReference<>() {});

        assertThat(quotes).filteredOn(q -> q.price() != null)
                .allMatch(q -> q.change() == 0.0 && q.changePercent() == 0.0);
    }
}
