package org.sinabro.fintree.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class MarketQuoteHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String symbol;

    private Double price;

    @Column(name = "price_change")
    private Double change;

    private Double changePercent;

    private Long marketTime;

    private String timezone;

    private LocalDateTime fetchedAt;

    @Builder
    public MarketQuoteHistory(String symbol, Double price, Double change, Double changePercent,
                               Long marketTime, String timezone, LocalDateTime fetchedAt) {
        this.symbol = symbol;
        this.price = price;
        this.change = change;
        this.changePercent = changePercent;
        this.marketTime = marketTime;
        this.timezone = timezone;
        this.fetchedAt = fetchedAt;
    }
}