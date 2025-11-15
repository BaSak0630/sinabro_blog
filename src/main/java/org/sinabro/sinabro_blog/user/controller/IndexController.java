package org.sinabro.sinabro_blog.user.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.sinabro.sinabro_blog.auth.request.Login;
import org.sinabro.sinabro_blog.auth.request.SignUp;
import org.sinabro.sinabro_blog.auth.service.AuthService;
import org.sinabro.sinabro_blog.config.auth.PrincipalDetails;

@Controller
@CrossOrigin(origins = "http://localhost:8080")
public class IndexController {

    @Autowired
    private AuthService authService;
    @Autowired
    private OAuth2AuthorizedClientService authorizedClientService;

    @GetMapping("/test/login")
    public @ResponseBody String testLogin(Authentication authentication, @AuthenticationPrincipal PrincipalDetails userDetails) { //2가지 방법 가능
        System.out.println("/test/login ===========");
        PrincipalDetails principalDetails = (PrincipalDetails) authentication.getPrincipal();
        System.out.println("authentication = " + principalDetails.getAccount());
        System.out.println("userDetails = " + userDetails.getAccount());
        return "세션 정보 확인 하기";
    }
    @GetMapping("/test/oauth/login")
    public @ResponseBody String testOAuthLogin(Authentication authentication, @AuthenticationPrincipal OAuth2User oAuth) { //2가지 방법 가능
        System.out.println("/test/oauth/login ===========");
        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
        System.out.println("authentication = " + oAuth2User.getAttributes());
        System.out.println("oAuth2User = " + oAuth.getAttributes());
        return "OAuth 세션 정보 확인 하기";
    }

    @GetMapping({"","/"})
    public String index() {
        return "index";
    }

    @GetMapping({"/user"})
    public @ResponseBody String user(@AuthenticationPrincipal PrincipalDetails principalDetails) {// /test참고
        System.out.println("principal details = " + principalDetails.getAccount());
        return "user";
    }

    @GetMapping({"/admin"})
    public @ResponseBody String admin() {
        return "admin";
    }

    @GetMapping({"/manager"})
    public @ResponseBody String manager() {
        return "manager";
    }

    //SecurityConfig 파일 생성 후 기존 제공하는 login 작동 X
    @GetMapping({"/loginForm"})
    public String login() {
        return "loginForm";
    }

    @GetMapping({"/joinForm"})
    public String joinForm() {
        return "joinForm";
    }

    @PostMapping({"/join"})
    public @ResponseBody String join(SignUp signup) {
        System.out.println(signup);
        authService.signup(signup);
        return "loginForm";
    }

    @PostMapping("/login")
    public @ResponseBody String login(Login login) {
        System.out.println(login);
        authService.login(login);
        return "/";
    }

    @PostMapping("/logout")
    public ResponseEntity<String> logout(HttpServletRequest request, Authentication authentication) {
        // 세션에서 토큰 정보 가져오기
        OAuth2AuthorizedClient authorizedClient = authorizedClientService
                .loadAuthorizedClient("google", authentication.getName());

        if (authorizedClient != null) {
            String accessToken = authorizedClient.getAccessToken().getTokenValue();
            revokeGoogleToken(accessToken);

            // 로컬 세션에서도 제거
            authorizedClientService.removeAuthorizedClient("google", authentication.getName());
        }

        // 세션 무효화
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        return ResponseEntity.ok("로그아웃 완료");
    }

    private void revokeGoogleToken(String accessToken) {
        String revokeUrl = "https://oauth2.googleapis.com/revoke?token=" + accessToken;

        RestTemplate restTemplate = new RestTemplate();
        try {
            ResponseEntity<String> response = restTemplate.postForEntity(revokeUrl, null, String.class);
            if (response.getStatusCode().is2xxSuccessful()) {
                System.out.println("토큰이 성공적으로 철회되었습니다.");
            }
        } catch (Exception e) {
            System.err.println("토큰 철회 실패: " + e.getMessage());
        }
    }

    //@PreAuthorize: 메서드가 실행되기 전에 인증을 거친다.
    //@PostAuthorize: 메서드가 실행되고 나서 응답을 보내기 전에 인증을 거친다.
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
    @GetMapping("/info")
    public @ResponseBody String info() {
        return "개인 정보";
    }
}
