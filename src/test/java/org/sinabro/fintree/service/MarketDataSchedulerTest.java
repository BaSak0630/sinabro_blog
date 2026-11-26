package org.sinabro.fintree.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.sinabro.fintree.domain.MarketQuoteHistory;
import org.sinabro.fintree.repository.MarketQuoteHistoryRepository;
import org.sinabro.fintree.response.MarketRefreshResult;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.offset;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

// fetchAndStore 는 호출 사이에 1.1초씩 쉬므로 테스트 1건당 약 3.3초 소요
@ExtendWith(MockitoExtension.class)
class MarketDataSchedulerTest {

    private static final ZoneId NY = ZoneId.of("America/New_York");

    @Mock
    private RestTemplate restTemplate;

    @Mock
    private MarketQuoteHistoryRepository repository;

    private MarketDataScheduler scheduler;

    @BeforeEach
    void setUp() {
        scheduler = new MarketDataScheduler(restTemplate, "test-key", repository);
        lenient().when(repository.findFirstBySymbolOrderByFetchedAtDesc(anyString())).thenReturn(Optional.empty());
    }

    private void respond(String function, Map<String, Object> body) {
        lenient().when(restTemplate.getForObject(contains("function=" + function), eq(Map.class))).thenReturn(body);
    }

    private void respondAllSuccess() {
        respond("GLOBAL_QUOTE", Map.of("Global Quote",
                Map.of("05. price", "512.30", "07. latest trading day", "2026-11-25")));
        respond("CURRENCY_EXCHANGE_RATE", Map.of("Realtime Currency Exchange Rate",
                Map.of("5. Exchange Rate", "1385.50")));
        respond("TREASURY_YIELD", Map.of("data",
                List.of(Map.of("date", "2026-11-25", "value", "4.21"), Map.of("date", "2026-11-24", "value", "4.19"))));
        respond("FEDERAL_FUNDS_RATE", Map.of("data",
                List.of(Map.of("date", "2026-11-25", "value", "3.88"))));
    }

    private List<MarketQuoteHistory> savedHistories() {
        ArgumentCaptor<MarketQuoteHistory> captor = ArgumentCaptor.forClass(MarketQuoteHistory.class);
        verify(repository, atLeast(0)).save(captor.capture());
        return captor.getAllValues();
    }

    private MarketQuoteHistory saved(String symbol) {
        return savedHistories().stream().filter(h -> h.getSymbol().equals(symbol)).findFirst().orElseThrow();
    }

    @Test
    @DisplayName("API 키가 없으면 외부 호출 없이 실패 결과 1건을 반환한다")
    void blankApiKey_skipsFetch() {
        scheduler = new MarketDataScheduler(restTemplate, "", repository);

        List<MarketRefreshResult> results = scheduler.fetchAndStore();

        assertThat(results).singleElement().satisfies(r -> {
            assertThat(r.symbol()).isEqualTo("ALL");
            assertThat(r.success()).isFalse();
        });
        verifyNoInteractions(restTemplate, repository);
    }

    @Test
    @DisplayName("정상 응답이면 4개 지표의 값과 기준 시각이 파싱되어 저장된다")
    void allSuccess_parsesAndSaves() {
        respondAllSuccess();

        List<MarketRefreshResult> results = scheduler.fetchAndStore();

        assertThat(results).extracting(MarketRefreshResult::symbol)
                .containsExactly("SPY", "USDKRW", "UST10Y", "FEDFUNDS");
        assertThat(results).allMatch(MarketRefreshResult::success);
        assertThat(savedHistories()).hasSize(4);

        MarketQuoteHistory spy = saved("SPY");
        assertThat(spy.getPrice()).isEqualTo(512.30);
        assertThat(spy.getMarketTime()).isEqualTo(LocalDate.of(2026, 11, 25).atTime(16, 0).atZone(NY).toEpochSecond());
        assertThat(spy.getTimezone()).isEqualTo("America/New_York");

        assertThat(saved("USDKRW").getPrice()).isEqualTo(1385.50);
        assertThat(saved("USDKRW").getTimezone()).isEqualTo("UTC");

        MarketQuoteHistory ust10y = saved("UST10Y");
        assertThat(ust10y.getPrice()).isEqualTo(4.21); // data[0] = 최신
        assertThat(ust10y.getMarketTime()).isEqualTo(LocalDate.of(2026, 11, 25).atStartOfDay(NY).toEpochSecond());

        assertThat(saved("FEDFUNDS").getPrice()).isEqualTo(3.88);
    }

    @Test
    @DisplayName("이전 값이 있으면 변화량·변화율을 계산하고, 없으면 null로 저장한다")
    void change_computedAgainstPreviousValue() {
        respondAllSuccess();
        MarketQuoteHistory prevSpy = MarketQuoteHistory.builder().symbol("SPY").price(500.0).build();
        when(repository.findFirstBySymbolOrderByFetchedAtDesc("SPY")).thenReturn(Optional.of(prevSpy));

        scheduler.fetchAndStore();

        MarketQuoteHistory spy = saved("SPY");
        assertThat(spy.getChange()).isCloseTo(12.30, offset(1e-9));
        assertThat(spy.getChangePercent()).isCloseTo(2.46, offset(1e-9));

        assertThat(saved("USDKRW").getChange()).isNull();
        assertThat(saved("USDKRW").getChangePercent()).isNull();
    }

    @Test
    @DisplayName("호출 한도 초과 응답이면 해당 지표만 실패하고 API 메시지를 담으며 저장하지 않는다")
    void rateLimited_failsOnlyThatSymbol() {
        respondAllSuccess();
        respond("GLOBAL_QUOTE", Map.of("Note", "API call frequency limit reached"));

        List<MarketRefreshResult> results = scheduler.fetchAndStore();

        assertThat(results.get(0).success()).isFalse();
        assertThat(results.get(0).message()).contains("frequency limit");
        assertThat(results.subList(1, 4)).allMatch(MarketRefreshResult::success);
        assertThat(savedHistories()).extracting(MarketQuoteHistory::getSymbol)
                .containsExactly("USDKRW", "UST10Y", "FEDFUNDS");
    }

    @Test
    @DisplayName("외부 호출 중 예외가 나도 나머지 지표는 계속 수집한다")
    void exception_doesNotStopOtherSymbols() {
        respondAllSuccess();
        when(restTemplate.getForObject(contains("function=TREASURY_YIELD"), eq(Map.class)))
                .thenThrow(new RuntimeException("connection timeout"));

        List<MarketRefreshResult> results = scheduler.fetchAndStore();

        assertThat(results).extracting(MarketRefreshResult::success)
                .containsExactly(true, true, false, true);
        assertThat(results.get(2).message()).isEqualTo("connection timeout");
        assertThat(savedHistories()).hasSize(3);
    }
}
