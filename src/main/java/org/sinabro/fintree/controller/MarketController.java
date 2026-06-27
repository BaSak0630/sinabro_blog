package org.sinabro.fintree.controller;

import org.sinabro.fintree.response.MarketQuote;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/market")
public class MarketController {

    private static final Logger log = LoggerFactory.getLogger(MarketController.class);

    private record Meta(String stooq, String tz) {}

    // 불변 맵 — 런타임 수정 방지
    private static final Map<String, Meta> SYMBOLS = Map.of(
            "^KS11",         new Meta("^kospi",  "Asia/Seoul"),
            "^GSPC",         new Meta("^spx",    "America/New_York"),
            "KRW=X",         new Meta("usdkrw",  "UTC"),
            "^VIX",          new Meta("^vix",    "America/New_York"),
            "^TNX",          new Meta("10us.b",  "America/New_York"),
            "^IRJPY10YT=RR", new Meta("10jpy.b", "Asia/Tokyo")
    );

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyyMMdd");
    private static final Duration CACHE_TTL = Duration.ofMinutes(5);

    private final RestTemplate restTemplate;
    private final String apiKey;

    private final Object cacheLock = new Object();
    private volatile List<MarketQuote> cache = null;
    private volatile Instant cacheExpiry = Instant.MIN;

    public MarketController(@Qualifier("marketRestTemplate") RestTemplate restTemplate,
                            @Value("${stooq.api-key:}") String apiKey) {
        this.restTemplate = restTemplate;
        this.apiKey = apiKey;
    }

    @GetMapping("/quotes")
    public ResponseEntity<List<MarketQuote>> getQuotes() {
        // 1차 확인: 락 없이 빠르게 캐시 히트 처리
        List<MarketQuote> snapshot = cache;
        if (snapshot != null && Instant.now().isBefore(cacheExpiry)) {
            return ResponseEntity.ok(snapshot);
        }

        // 2차 확인: 락 안에서 재확인 (cache stampede 방지)
        synchronized (cacheLock) {
            snapshot = cache;
            if (snapshot != null && Instant.now().isBefore(cacheExpiry)) {
                return ResponseEntity.ok(snapshot);
            }

            List<MarketQuote> quotes = SYMBOLS.entrySet().stream()
                    .parallel()
                    .map(e -> fetchStooq(e.getKey(), e.getValue()))
                    .collect(Collectors.toList());

            cache = quotes;
            cacheExpiry = Instant.now().plus(CACHE_TTL);
            return ResponseEntity.ok(quotes);
        }
    }

    private MarketQuote fetchStooq(String displaySymbol, Meta meta) {
        try {
            LocalDate today   = LocalDate.now(ZoneId.of(meta.tz()));
            String    d1      = today.minusDays(14).format(FMT);
            String    d2      = today.format(FMT);
            String    encoded = URLEncoder.encode(meta.stooq(), StandardCharsets.UTF_8);

            String url = "https://stooq.com/q/d/l/?s=" + encoded
                    + "&d1=" + d1 + "&d2=" + d2 + "&i=d"
                    + (apiKey.isBlank() ? "" : "&apikey=" + apiKey);

            HttpHeaders headers = new HttpHeaders();
            headers.set(HttpHeaders.USER_AGENT,
                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");

            ResponseEntity<String> resp = restTemplate.exchange(
                    url, HttpMethod.GET, new HttpEntity<>(headers), String.class);

            String body = resp.getBody();
            if (body == null || body.isBlank()) {
                throw new IllegalStateException("empty response");
            }

            String[] lines = body.trim().split("\\r?\\n");
            if (lines.length < 2) {
                throw new IllegalStateException("no data rows");
            }

            // 마지막 행 파싱 (Date,Open,High,Low,Close,Volume)
            String[] last = lines[lines.length - 1].split(",");
            if (last.length < 5) {
                throw new IllegalStateException("unexpected CSV columns: " + lines[lines.length - 1]);
            }

            LocalDate date  = LocalDate.parse(last[0]);
            double    close = Double.parseDouble(last[4]);

            double prevClose = close;
            if (lines.length >= 3) {
                String[] prev = lines[lines.length - 2].split(",");
                if (prev.length >= 5) {
                    prevClose = Double.parseDouble(prev[4]);
                }
            }

            double change    = close - prevClose;
            double changePct = prevClose != 0 ? (change / prevClose) * 100.0 : 0.0;

            long marketTime = date.atTime(16, 0)
                    .atZone(ZoneId.of(meta.tz()))
                    .toEpochSecond();

            return new MarketQuote(displaySymbol, close, change, changePct, marketTime, meta.tz());

        } catch (Exception e) {
            log.warn("Market data fetch failed [{}]: {}", displaySymbol, e.getMessage());
            return new MarketQuote(displaySymbol, null, null, null, null, null);
        }
    }
}
