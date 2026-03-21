package org.sinabro.sinabro_blog.config.auth;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.sinabro.sinabro_blog.config.auth.PrincipalDetails;
import org.sinabro.sinabro_blog.user.domain.Account;
import org.sinabro.sinabro_blog.user.repository.LocalAccountRepository;

import java.util.Optional;


//시큐리티 설정에서 loginProcessingUrl("/login");
// /login 요청이 오면 자동으로 UserDetaileService 타입으로 IoC 되어 있는 loadUserByUsername 함수가 실행

@Slf4j
@Service
public class PrincipalDetailsService implements UserDetailsService {
    @Autowired
    private LocalAccountRepository localAccountRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        log.info("로컬 로그인 시도: {}", username);

        try {
            Optional<Account> accountOptional = localAccountRepository.findByAccountId(username)
                    .map(a -> (Account) a);

            if (accountOptional.isEmpty()) {
                log.info("accountId로 찾지 못함, email로 재시도: {}", username);
                accountOptional = localAccountRepository.findByEmail(username)
                        .map(a -> (Account) a);
            }

            if (accountOptional.isEmpty()) {
                log.warn("사용자를 찾을 수 없습니다: {}", username);
                throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
            }

            Account account = accountOptional.get();
            log.info("로컬 사용자 찾음: accountId={}, email={}, username={}",
                    account.getAccountId(), account.getEmail(), account.getUsername());

            return new PrincipalDetails(account);

        } catch (Exception e) {
            log.error("loadUserByUsername 처리 중 오류 발생: {}", e.getMessage(), e);
            throw new UsernameNotFoundException("사용자 정보 로드 중 오류 발생: " + username, e);
        }
    }
}
