package org.sinabro.fintree.controller;

import org.sinabro.fintree.response.MarketQuote;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/market")
public class MarketController {

    // display symbol → (stooq symbol, 거래소 timezone)
    private record Meta(String stooq, String tz) {}

    private static final LinkedHashMap<String, Meta> SYMBOLS = new LinkedHashMap<>();
    static {
        SYMBOLS.put("^KS11",         new Meta("^kospi",  "Asia/Seoul"));
        SYMBOLS.put("^GSPC",         new Meta("^spx",    "America/New_York"));
        SYMBOLS.put("KRW=X",         new Meta("usdkrw",  "UTC"));
        SYMBOLS.put("^VIX",          new Meta("^vix",    "America/New_York"));
        SYMBOLS.put("^TNX",          new Meta("10us.b",  "America/New_York"));
        SYMBOLS.put("^IRJPY10YT=RR", new Meta("10jpy.b", "Asia/Tokyo"));
    }

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyyMMdd");

    private final RestTemplate restTemplate;

    public MarketController(RestTemplateBuilder builder) {
        this.restTemplate = builder
                .connectTimeout(Duration.ofSeconds(5))
                .readTimeout(Duration.ofSeconds(10))
                .build();
    }

    @GetMapping("/quotes")
    public ResponseEntity<List<MarketQuote>> getQuotes() {
        List<MarketQuote> quotes = SYMBOLS.entrySet().stream()
                .parallel()
                .map(e -> fetchStooq(e.getKey(), e.getValue()))
                .collect(Collectors.toList());
        return ResponseEntity.ok(quotes);
    }

    // Stooq CSV 히스토리 엔드포인트 (stooq.com/q/d/l) 응답:
    // Date,Open,High,Low,Close,Volume (헤더 1행 + 데이터 N행)
    // 가장 마지막 2행으로 현재가·전일 종가를 구해 등락을 계산한다.
    private MarketQuote fetchStooq(String displaySymbol, Meta meta) {
        try {
            LocalDate today   = LocalDate.now(ZoneId.of(meta.tz()));
            String    d1      = today.minusDays(14).format(FMT);
            String    d2      = today.format(FMT);
            String    encoded = URLEncoder.encode(meta.stooq(), StandardCharsets.UTF_8);

            String url = "https://stooq.com/q/d/l/?s=" + encoded
                    + "&d1=" + d1 + "&d2=" + d2 + "&i=d";

            HttpHeaders headers = new HttpHeaders();
            headers.set(HttpHeaders.USER_AGENT,
                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");

            ResponseEntity<String> resp = restTemplate.exchange(
                    url, HttpMethod.GET, new HttpEntity<>(headers), String.class);

            String body = resp.getBody();
            if (body == null || body.isBlank()) throw new RuntimeException("empty response");

            // 줄 분리 (Windows/Unix CRLF 모두 처리)
            String[] lines = body.trim().split("\\r?\\n");
            // lines[0] = "Date,Open,High,Low,Close,Volume"
            if (lines.length < 2) throw new RuntimeException("no data rows");

            // 가장 최근 행
            String[] last  = lines[lines.length - 1].split(",");
            LocalDate date = LocalDate.parse(last[0]);
            double close   = Double.parseDouble(last[4]);

            // 전일 종가 (두 번째 마지막 행)
            double prevClose = close;
            if (lines.length >= 3) {
                String[] prev = lines[lines.length - 2].split(",");
                prevClose = Double.parseDouble(prev[4]);
            }

            double change    = close - prevClose;
            double changePct = prevClose != 0 ? (change / prevClose) * 100.0 : 0.0;

            // 거래소 종료 시각 (각 시장 기준 16:00) → Unix seconds
            long marketTime = date.atTime(16, 0)
                    .atZone(ZoneId.of(meta.tz()))
                    .toEpochSecond();

            return new MarketQuote(displaySymbol, close, change, changePct, marketTime, meta.tz());

        } catch (Exception e) {
            return new MarketQuote(displaySymbol, null, null, null, null, null);
        }
    }
}
