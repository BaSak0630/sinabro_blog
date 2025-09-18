package org.sinabro.sinabro_blog.config.auth;

import lombok.Data;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.sinabro.sinabro_blog.user.domain.Account;

import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

//시큐리티가 /login 주소 요청이 오면 낚아채서 로그인을 진행 시킨다.
//로그인을 진행이 완료가 되면 시큐리티 session 을 만들어 줍니다. (Security ContextHolder)
//오브젝트 타입 -> Authentication 타입 객체
//Authentication 안에 User 정보가 있어야 함
//User 오브젝트타입 -> UserDetails 다입 객체

//Security Session -> Authentication -> UserDetails(PrincipalDetails)

@Data
public class PrincipalDetails implements UserDetails, OAuth2User {

    private Account account; //콜 포지션
    private Map<String, Object> attributes = new HashMap<>();

    // 로컬 로그인용 생성자
    public PrincipalDetails(Account account) {
        this.account = account;
        System.out.printf("PrincipalDetails 생성 (로컬 로그인): accountId={}, email={}",
                account != null ? account.getAccountId() : "null",
                account != null ? account.getEmail() : "null");
    }

    // OAuth2 로그인용 생성자
    public PrincipalDetails(Account account, Map<String, Object> attributes) {
        this.account = account;
        this.attributes = attributes;
        System.out.printf("PrincipalDetails 생성 (OAuth2 로그인): email={}",
                account != null ? account.getEmail() : "null");
    }

    //OAuth2User
    @Override
    public Map<String, Object> getAttributes() {
        return attributes;
    }


    @Override
    public String getName() {
        // account가 null이면 attributes에서 이름을 가져오거나 기본값 반환
        if (account != null && account.getUsername() != null) {
            return account.getUsername();
        }

        // OAuth2의 경우 attributes에서 이름 추출 시도
        if (attributes != null) {
            String name = (String) attributes.get("name");
            if (name != null) return name;

            String email = (String) attributes.get("email");
            if (email != null) return email;
        }

        return "unknown"; // 기본값
    }

    //UserDetails
    //해당 User 의 권한을 리턴
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        if (account == null || account.getRole() == null) {
            // 기본 권한 반환
            return Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER"));
        }

        return Collections.singletonList(
                new SimpleGrantedAuthority("ROLE_" + account.getRole().name())
        );
    }

    @Override
    public String getPassword() {
        return account != null ? account.getPassword() : "";
    }

    @Override
    public String getUsername() {
        if (account == null) {
            return "unknown";
        }

        // accountId가 있으면 사용, 없으면 username 사용
        return account.getAccountId() != null ?
                account.getAccountId() :
                (account.getUsername() != null ? account.getUsername() : "unknown");
    }

    //계정 만료
    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    //계정 잠금
    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    //비밀번호 오랜 기간사용시
    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    //활성화
    @Override
    public boolean isEnabled() {
        return true;
    }
}
