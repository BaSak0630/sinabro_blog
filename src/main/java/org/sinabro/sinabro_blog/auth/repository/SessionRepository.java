package org.sinabro.sinabro_blog.auth.repository;

import org.sinabro.sinabro_blog.auth.domain.Session;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SessionRepository extends JpaRepository<Session, Long> {
    Optional<Session> findByAccessToken(String accessToken);
}
