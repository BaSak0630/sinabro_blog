package org.sinabro.sinabro_blog.config;

import lombok.RequiredArgsConstructor;
import org.sinabro.sinabro_blog.auth.repository.SessionRepository;
import org.springframework.boot.web.servlet.view.MustacheViewResolver;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.List;

@Configuration
@RequiredArgsConstructor
public class WebMvcConfig implements WebMvcConfigurer {

    private final SessionRepository sessionRepository;

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        MustacheViewResolver resolver = new MustacheViewResolver();
        resolver.setCharset("UTF-8");
        resolver.setContentType("text/html; charset=utf-8");
        resolver.setPrefix("classpath:/templates/");
        resolver.setSuffix(".html"); //index.html를 index.mustache로 인식

        registry.viewResolver(resolver);
    }
    //addPathPatterns에 새로 추가되는 라우터 마다 추가를 해줘야하기 때문에 사용을 추천하지 않는다.
//    @Override
//    public void addInterceptors(InterceptorRegistry registry) {
//        registry.addInterceptor(new AuthInterceptor())
//                .addPathPatterns("/error", "/favicon.ico");
//    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(new Authresolver(sessionRepository));
    }
}
