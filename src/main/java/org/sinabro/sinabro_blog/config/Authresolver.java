package org.sinabro.sinabro_blog.config;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.sinabro.sinabro_blog.auth.domain.Session;
import org.sinabro.sinabro_blog.auth.repository.SessionRepository;
import org.sinabro.sinabro_blog.auth.request.Login;
import org.sinabro.sinabro_blog.config.data.UserSession;
import org.sinabro.sinabro_blog.exception.Unauthorized;
import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

@RequiredArgsConstructor
public class Authresolver implements HandlerMethodArgumentResolver {

    private final SessionRepository sessionRepository;

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.getParameterType().equals(UserSession.class);
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        String accessToken = webRequest.getHeader("Authorization");
        if (accessToken == null || accessToken.isEmpty()) {
            throw new Unauthorized();
        }

        Session session = sessionRepository.findByAccessToken(accessToken).orElseThrow(Unauthorized::new);

        return new UserSession(session.getId());
    }

}
