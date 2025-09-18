package org.sinabro.sinabro_blog.user.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
public class OAuthDebugController {

    private final ClientRegistrationRepository clientRegistrationRepository;

    /**
     * OAuth 클라이언트 등록 정보 확인
     */
    @GetMapping("/api/debug/oauth/clients")
    public Map<String, Object> getOAuthClients() {
        Map<String, Object> response = new HashMap<>();

        try {
            // Google 클라이언트 등록 정보 확인
            ClientRegistration googleRegistration = clientRegistrationRepository.findByRegistrationId("google");

            if (googleRegistration != null) {
                response.put("google", Map.of(
                        "clientId", googleRegistration.getClientId(),
                        "clientSecret", googleRegistration.getClientSecret() != null ? "설정됨" : "없음",
                        "redirectUri", googleRegistration.getRedirectUri(),
                        "authorizationUri", googleRegistration.getProviderDetails().getAuthorizationUri(),
                        "tokenUri", googleRegistration.getProviderDetails().getTokenUri(),
                        "userInfoUri", googleRegistration.getProviderDetails().getUserInfoEndpoint().getUri(),
                        "scopes", googleRegistration.getScopes()
                ));
                log.info("Google OAuth 클라이언트 등록 정보 확인됨");
            } else {
                response.put("error", "Google OAuth 클라이언트가 등록되지 않았습니다.");
                log.warn("Google OAuth 클라이언트가 등록되지 않았습니다.");
            }

        } catch (Exception e) {
            log.error("OAuth 클라이언트 정보 조회 실패", e);
            response.put("error", e.getMessage());
        }

        return response;
    }

    /**
     * OAuth 로그인 URL 생성 테스트
     */
    @GetMapping("/api/debug/oauth/urls")
    public Map<String, Object> getOAuthUrls() {
        Map<String, Object> response = new HashMap<>();

        // 수동으로 OAuth URL 생성
        String baseUrl = "http://localhost:8080";
        String googleAuthUrl = baseUrl + "/oauth2/authorization/google";
        String naverAuthUrl = baseUrl + "/oauth2/authorization/naver";

        response.put("googleAuthUrl", googleAuthUrl);
        response.put("naverAuthUrl", naverAuthUrl);
        response.put("redirectUri", baseUrl + "/login/oauth2/code/google");

        log.info("OAuth URLs: Google={}, Naver={}", googleAuthUrl, naverAuthUrl);

        return response;
    }
}