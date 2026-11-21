package org.sinabro.fintree.service;

import org.sinabro.fintree.domain.MarketQuoteHistory;
import org.sinabro.fintree.repository.MarketQuoteHistoryRepository;
import org.sinabro.fintree.response.MarketRefreshResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;

// Alpha Vantage 무료 API는 하루 25회 제한 — 하루 4번(4개 심볼 x 4회 = 16콜) 갱신으로 유지
@Component
public class MarketDataScheduler {

    private static final Logger log = LoggerFactory.getLogger(MarketDataScheduler.class);

    private static final String SPY = "SPY";
    private static final String USDKRW = "USDKRW";
    private static final String UST10Y = "UST10Y";
    private static final String FEDFUNDS = "FEDFUNDS";
    private static final ZoneId NY = ZoneId.of("America/New_York");

    private final RestTemplate restTemplate;
    private final String apiKey;
    private final MarketQuoteHistoryRepository repository;

    public MarketDataScheduler(@Qualifier("marketRestTemplate") RestTemplate restTemplate,
                                @Value("${alphavantage.api-key:}") String apiKey,
                                MarketQuoteHistoryRepository repository) {
        this.restTemplate = restTemplate;
        this.apiKey = apiKey;
        this.repository = repository;
    }

    @Scheduled(cron = "0 0 0,6,12,18 * * *")
    public List<MarketRefreshResult> fetchAndStore() {
        if (apiKey.isBlank()) {
            log.warn("alphavantage.api-key가 설정되지 않아 시장 데이터 갱신을 건너뜁니다.");
            return List.of(new MarketRefreshResult("ALL", false, "alphavantage.api-key가 설정되지 않음"));
        }

        MarketRefreshResult spy = fetchSpy();
        sleepBetweenCalls();
        MarketRefreshResult usdKrw = fetchUsdKrw();
        sleepBetweenCalls();
        MarketRefreshResult ust10y = fetchUst10y();
        sleepBetweenCalls();
        MarketRefreshResult fedFunds = fetchFedFundsRate();

        return List.of(spy, usdKrw, ust10y, fedFunds);
    }

    // Alpha Vantage 무료 키는 초당 1회 제한 — 연속 호출 사이에 텀을 둬야 뒤 요청이 안 막힘
    private void sleepBetweenCalls() {
        try {
            Thread.sleep(1100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    @SuppressWarnings("unchecked")
    private MarketRefreshResult fetchSpy() {
        try {
            String url = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=SPY&apikey=" + apiKey;
            Map<String, Object> body = restTemplate.getForObject(url, Map.class);
            Map<String, Object> quote = (Map<String, Object>) body.get("Global Quote");
            if (quote == null || quote.isEmpty()) {
                throw new IllegalStateException(extractApiError(body));
            }

            double price = Double.parseDouble((String) quote.get("05. price"));
            LocalDate tradingDay = LocalDate.parse((String) quote.get("07. latest trading day"));
            long marketTime = tradingDay.atTime(16, 0).atZone(NY).toEpochSecond();

            save(SPY, price, marketTime, NY.getId());
            return new MarketRefreshResult(SPY, true, "price=" + price);
        } catch (Exception e) {
            log.warn("SPY 시세 조회 실패: {}", e.getMessage());
            return new MarketRefreshResult(SPY, false, e.getMessage());
        }
    }

    @SuppressWarnings("unchecked")
    private MarketRefreshResult fetchUsdKrw() {
        try {
            String url = "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE"
                    + "&from_currency=USD&to_currency=KRW&apikey=" + apiKey;
            Map<String, Object> body = restTemplate.getForObject(url, Map.class);
            Map<String, Object> rate = (Map<String, Object>) body.get("Realtime Currency Exchange Rate");
            if (rate == null || rate.isEmpty()) {
                throw new IllegalStateException(extractApiError(body));
            }

            double price = Double.parseDouble((String) rate.get("5. Exchange Rate"));

            save(USDKRW, price, Instant.now().getEpochSecond(), "UTC");
            return new MarketRefreshResult(USDKRW, true, "price=" + price);
        } catch (Exception e) {
            log.warn("USD/KRW 환율 조회 실패: {}", e.getMessage());
            return new MarketRefreshResult(USDKRW, false, e.getMessage());
        }
    }

    @SuppressWarnings("unchecked")
    private MarketRefreshResult fetchUst10y() {
        try {
            String url = "https://www.alphavantage.co/query?function=TREASURY_YIELD"
                    + "&interval=daily&maturity=10year&apikey=" + apiKey;
            Map<String, Object> body = restTemplate.getForObject(url, Map.class);
            List<Map<String, Object>> data = (List<Map<String, Object>>) body.get("data");
            if (data == null || data.isEmpty()) {
                throw new IllegalStateException(extractApiError(body));
            }
            Map<String, Object> latest = data.get(0);

            double price = Double.parseDouble((String) latest.get("value"));
            LocalDate date = LocalDate.parse((String) latest.get("date"));
            long marketTime = date.atStartOfDay(NY).toEpochSecond();

            save(UST10Y, price, marketTime, NY.getId());
            return new MarketRefreshResult(UST10Y, true, "price=" + price);
        } catch (Exception e) {
            log.warn("미국 10년물 조회 실패: {}", e.getMessage());
            return new MarketRefreshResult(UST10Y, false, e.getMessage());
        }
    }

    @SuppressWarnings("unchecked")
    private MarketRefreshResult fetchFedFundsRate() {
        try {
            String url = "https://www.alphavantage.co/query?function=FEDERAL_FUNDS_RATE"
                    + "&interval=daily&apikey=" + apiKey;
            Map<String, Object> body = restTemplate.getForObject(url, Map.class);
            List<Map<String, Object>> data = (List<Map<String, Object>>) body.get("data");
            if (data == null || data.isEmpty()) {
                throw new IllegalStateException(extractApiError(body));
            }
            Map<String, Object> latest = data.get(0);

            double price = Double.parseDouble((String) latest.get("value"));
            LocalDate date = LocalDate.parse((String) latest.get("date"));
            long marketTime = date.atStartOfDay(NY).toEpochSecond();

            save(FEDFUNDS, price, marketTime, NY.getId());
            return new MarketRefreshResult(FEDFUNDS, true, "price=" + price);
        } catch (Exception e) {
            log.warn("기준금리 조회 실패: {}", e.getMessage());
            return new MarketRefreshResult(FEDFUNDS, false, e.getMessage());
        }
    }

    private String extractApiError(Map<String, Object> body) {
        if (body == null) return "빈 응답";
        Object reason = body.get("Note");
        if (reason == null) reason = body.get("Information");
        if (reason == null) reason = body.get("Error Message");
        return reason != null ? reason.toString() : "알 수 없는 응답 형식: " + body;
    }

    private void save(String symbol, double price, long marketTime, String timezone) {
        Double prevPrice = repository.findFirstBySymbolOrderByFetchedAtDesc(symbol)
                .map(MarketQuoteHistory::getPrice)
                .orElse(null);

        Double change = prevPrice != null ? price - prevPrice : null;
        Double changePercent = (change != null && prevPrice != 0) ? (change / prevPrice) * 100.0 : null;

        repository.save(MarketQuoteHistory.builder()
                .symbol(symbol)
                .price(price)
                .change(change)
                .changePercent(changePercent)
                .marketTime(marketTime)
                .timezone(timezone)
                .fetchedAt(LocalDateTime.now())
                .build());
    }
}