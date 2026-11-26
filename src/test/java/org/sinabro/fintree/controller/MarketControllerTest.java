package org.sinabro.fintree.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.sinabro.fintree.domain.MarketQuoteHistory;
import org.sinabro.fintree.repository.MarketQuoteHistoryRepository;
import org.sinabro.fintree.response.MarketQuote;
import org.sinabro.sinabro_blog.SinabroBlogApplication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.time.LocalDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest(classes = SinabroBlogApplication.class)
@AutoConfigureMockMvc
class MarketControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private MarketQuoteHistoryRepository repository;

    @AfterEach
    void clean() {
        repository.deleteAll();
    }

    private MarketQuoteHistory history(String symbol, double price, LocalDateTime fetchedAt) {
        return MarketQuoteHistory.builder()
                .symbol(symbol)
                .price(price)
                .change(1.5)
                .changePercent(0.3)
                .marketTime(1_700_000_000L)
                .timezone("America/New_York")
                .fetchedAt(fetchedAt)
                .build();
    }

    private List<MarketQuote> getQuotes() throws Exception {
        MvcResult result = mockMvc.perform(get("/market/quotes"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith("application/json"))
                .andReturn();
        return objectMapper.readValue(result.getResponse().getContentAsString(), new TypeReference<>() {});
    }

    @Test
    @DisplayName("저장된 데이터가 없으면 4개 지표 모두 price가 null로 반환된다")
    void getQuotes_noData_returnsNullPrices() throws Exception {
        List<MarketQuote> quotes = getQuotes();

        assertThat(quotes).extracting(MarketQuote::symbol)
                .containsExactly("SPY", "USDKRW", "UST10Y", "FEDFUNDS");
        assertThat(quotes).allMatch(q -> q.price() == null);
    }

    @Test
    @DisplayName("지표별로 가장 최근에 수집된 값이 반환된다")
    void getQuotes_returnsLatestPerSymbol() throws Exception {
        LocalDateTime now = LocalDateTime.now();
        repository.saveAll(List.of(
                history("SPY", 500.0, now.minusHours(6)),
                history("SPY", 510.0, now),
                history("USDKRW", 1380.0, now)
        ));

        List<MarketQuote> quotes = getQuotes();

        MarketQuote spy = quotes.get(0);
        assertThat(spy.price()).isEqualTo(510.0);
        assertThat(spy.change()).isEqualTo(1.5);
        assertThat(spy.changePercent()).isEqualTo(0.3);
        assertThat(spy.marketTime()).isEqualTo(1_700_000_000L);
        assertThat(spy.timezone()).isEqualTo("America/New_York");
        assertThat(quotes.get(1).price()).isEqualTo(1380.0);
        assertThat(quotes.get(2).price()).isNull();
    }
}
