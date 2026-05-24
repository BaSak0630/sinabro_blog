package org.sinabro.dokhu.repository;

import org.sinabro.dokhu.domain.Book;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookRepository extends JpaRepository<Book, Long> {
}
