package org.sinabro.sinabro_blog.config;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.sinabro.sinabro_blog.auth.domain.Session;
import org.sinabro.sinabro_blog.auth.repository.SessionRepository;
import org.sinabro.sinabro_blog.config.data.UserSession;
import org.sinabro.sinabro_blog.exception.Unauthorized;
import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

@Slf4j
@RequiredArgsConstructor
public class Authresolver implements HandlerMethodArgumentResolver {

    private final SessionRepository sessionRepository;

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.getParameterType().equals(UserSession.class);
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        HttpServletRequest request = (HttpServletRequest) webRequest.getNativeRequest();

        // SESSION 쿠키에서 토큰 읽기
        String accessToken = getSessionCookie(request);

        if (accessToken == null || accessToken.isEmpty()) {
            log.debug("No SESSION cookie found");
            throw new Unauthorized();
        }

        // DB에서 세션 조회
        Session session = sessionRepository.findByAccessToken(accessToken)
                .orElseThrow(() -> {
                    log.debug("Invalid session token: {}", accessToken);
                    return new Unauthorized();
                });

        log.debug("Session validated for user: {}", session.getAccount().getAccountId());

        return new UserSession(session.getAccount().getId());
    }

    private String getSessionCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }

        for (Cookie cookie : cookies) {
            if ("SESSION".equals(cookie.getName())) {
                return cookie.getValue();
            }
        }
        return null;
    }
}
