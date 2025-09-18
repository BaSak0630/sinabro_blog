package org.sinabro.sinabro_blog.config.auth.oauth;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.sinabro.sinabro_blog.config.auth.PrincipalDetails;
import org.sinabro.sinabro_blog.config.auth.oauth.provider.GoogleUserInfo;
import org.sinabro.sinabro_blog.config.auth.oauth.provider.NaverUserInfo;
import org.sinabro.sinabro_blog.config.auth.oauth.provider.OAuth2UserInfo;
import org.sinabro.sinabro_blog.user.domain.Account;
import org.sinabro.sinabro_blog.user.domain.OAuthAccount;
import org.sinabro.sinabro_blog.user.domain.Role;
import org.sinabro.sinabro_blog.user.service.AccountService;

import java.time.LocalDateTime;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class PrincipalOauth2UserService extends DefaultOAuth2UserService {

    private final PasswordEncoder passwordEncoder;
    private final AccountService accountService;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        log.info("OAuth2 로그인 시도: {}", userRequest.getClientRegistration().getRegistrationId());

        OAuth2UserInfo oAuth2UserInfo = getOAuth2UserInfo(userRequest, oAuth2User);

        String provider = oAuth2UserInfo.getProvider();
        String providerUserid = oAuth2UserInfo.getProviderId();
        String username = provider + "_" + providerUserid;
        String password = passwordEncoder.encode(username);
        String email = oAuth2UserInfo.getEmail();
        Role role = Role.USER;

        // 이메일 기반으로 계정 확인 (더 안전한 방식)
        Optional<Account> existingAccount = accountService.findByEmail(email);
        OAuthAccount accountEntity;

        if (existingAccount.isEmpty()) {
            log.info("새로운 OAuth2 사용자 생성: {}", email);

            accountEntity = OAuthAccount.builder()
                    .username(username)
                    .password(password)
                    .email(email)
                    .providerUserid(providerUserid)
                    .provider(provider)
                    .role(role)
                    .createAt(LocalDateTime.now())
                    .updateAt(LocalDateTime.now())
                    .linkedAt(LocalDateTime.now())
                    .build();

            accountService.oauthJoin(accountEntity);

        } else {
            log.info("기존 사용자 OAuth2 로그인: {}", email);
            accountEntity = (OAuthAccount) existingAccount.get();
        }

        return new PrincipalDetails(accountEntity, oAuth2User.getAttributes());
    }

    private static OAuth2UserInfo getOAuth2UserInfo(OAuth2UserRequest userRequest, OAuth2User oAuth2User) {
        OAuth2UserInfo oAuth2UserInfo = null;
        String registrationId = userRequest.getClientRegistration().getRegistrationId();

        if ("google".equals(registrationId)) {
            oAuth2UserInfo = new GoogleUserInfo(oAuth2User.getAttributes());
        } else if ("naver".equals(registrationId)) {
            oAuth2UserInfo = new NaverUserInfo(oAuth2User.getAttributes());
        }

        if (oAuth2UserInfo == null) {
            throw new OAuth2AuthenticationException("지원하지 않는 OAuth2 제공자입니다: " + registrationId);
        }
        return oAuth2UserInfo;
    }


}