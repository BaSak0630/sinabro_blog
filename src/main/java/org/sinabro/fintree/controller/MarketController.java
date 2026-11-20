package org.sinabro.fintree.controller;

import org.sinabro.fintree.repository.MarketQuoteHistoryRepository;
import org.sinabro.fintree.response.MarketQuote;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/market")
public class MarketController {

    private static final List<String> SYMBOLS = List.of("SPY", "USDKRW", "UST10Y", "FEDFUNDS");

    private final MarketQuoteHistoryRepository repository;

    public MarketController(MarketQuoteHistoryRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/quotes")
    public ResponseEntity<List<MarketQuote>> getQuotes() {
        List<MarketQuote> quotes = SYMBOLS.stream()
                .map(symbol -> repository.findFirstBySymbolOrderByFetchedAtDesc(symbol)
                        .map(h -> new MarketQuote(h.getSymbol(), h.getPrice(), h.getChange(),
                                h.getChangePercent(), h.getMarketTime(), h.getTimezone()))
                        .orElse(new MarketQuote(symbol, null, null, null, null, null)))
                .toList();

        return ResponseEntity.ok(quotes);
    }
}