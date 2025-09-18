package org.sinabro.sinabro_blog.config.auth;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.sinabro.sinabro_blog.user.domain.Account;
import org.sinabro.sinabro_blog.user.repository.AccountRepository;

import java.util.Optional;


//시큐리티 설정에서 loginProcessingUrl("/login");
// /login 요청이 오면 자동으로 UserDetaileService 타입으로 IoC 되어 있는 loadUserByUsername 함수가 실행

@Slf4j
@Service
public class PrincipalDetailsService implements UserDetailsService {
    @Autowired
    private AccountRepository accountRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        log.info("로컬 로그인 시도: {}", username);

        try {
            // accountId로 계정 찾기
            Optional<Account> accountOptional = accountRepository.findByAccountId(username);

            if (accountOptional.isEmpty()) {
                log.info("accountId로 찾지 못함, email로 재시도: {}", username);
                // accountId로 찾지 못한 경우 email로 시도
                accountRepository.findByEmail(username);
            }

            if (accountOptional.isEmpty()) {
                log.warn("사용자를 찾을 수 없습니다: {}", username);
                throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
            }

            Account account = accountOptional.get();
            log.info("로컬 사용자 찾음: accountId={}, email={}, username={}",
                    account.getAccountId(), account.getEmail(), account.getUsername());

            // PrincipalDetails 생성 전 null 체크
            if (account == null) {
                log.error("Account 객체가 null입니다.");
                throw new UsernameNotFoundException("계정 정보가 올바르지 않습니다: " + username);
            }

            PrincipalDetails principalDetails = new PrincipalDetails(account);
            log.info("PrincipalDetails 생성 완료: {}", principalDetails);

            return principalDetails;

        } catch (Exception e) {
            log.error("loadUserByUsername 처리 중 오류 발생: {}", e.getMessage(), e);
            throw new UsernameNotFoundException("사용자 정보 로드 중 오류 발생: " + username, e);
        }
    }
}
