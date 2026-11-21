package org.sinabro.fintree.response;

public record MarketRefreshResult(
        String symbol,
        boolean success,
        String message
) {}