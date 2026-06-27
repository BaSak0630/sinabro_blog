package org.sinabro.dokhu.repository;

import org.sinabro.dokhu.domain.Book;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface BookRepository extends JpaRepository<Book, Long> {

    @Query("SELECT b FROM Book b WHERE " +
           "(:keyword IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%',:keyword,'%')) OR LOWER(b.author) LIKE LOWER(CONCAT('%',:keyword,'%'))) " +
           "AND (:genre IS NULL OR LOWER(b.genre) = LOWER(:genre)) " +
           "ORDER BY b.id DESC")
    List<Book> searchBooks(@Param("keyword") String keyword, @Param("genre") String genre, Pageable pageable);

    @Query("SELECT b FROM Book b WHERE " +
           "(:keyword IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%',:keyword,'%')) OR LOWER(b.author) LIKE LOWER(CONCAT('%',:keyword,'%'))) " +
           "ORDER BY b.id DESC")
    Page<Book> searchBooksPage(@Param("keyword") String keyword, Pageable pageable);

    @Query("SELECT DISTINCT b.genre FROM Book b WHERE b.genre IS NOT NULL ORDER BY b.genre")
    List<String> findAllGenres();
}
