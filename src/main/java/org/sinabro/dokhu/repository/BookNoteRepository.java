package org.sinabro.dokhu.repository;

import org.sinabro.dokhu.domain.BookNote;
import org.sinabro.dokhu.domain.UserBook;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface BookNoteRepository extends JpaRepository<BookNote, Long> {
    Optional<BookNote> findByUserBook(UserBook userBook);
    List<BookNote> findAllByUserBookOrderByCreatedAtDesc(UserBook userBook);
}
