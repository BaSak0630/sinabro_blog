package org.sinabro.fintree.response;

public record MarketQuote(
        String symbol,
        Double price,
        Double change,
        Double changePercent,
        Long marketTime,
        String timezone
) {}
