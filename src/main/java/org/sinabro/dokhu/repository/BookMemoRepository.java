package org.sinabro.dokhu.repository;

import org.sinabro.dokhu.domain.BookMemo;
import org.sinabro.dokhu.domain.UserBook;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BookMemoRepository extends JpaRepository<BookMemo, Long> {
    List<BookMemo> findAllByUserBookOrderByCreatedAtDesc(UserBook userBook);
}
