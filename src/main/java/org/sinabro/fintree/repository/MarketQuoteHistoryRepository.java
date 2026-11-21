package org.sinabro.fintree.repository;

import org.sinabro.fintree.domain.MarketQuoteHistory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface MarketQuoteHistoryRepository extends JpaRepository<MarketQuoteHistory, Long> {

    Optional<MarketQuoteHistory> findFirstBySymbolOrderByFetchedAtDesc(String symbol);
}