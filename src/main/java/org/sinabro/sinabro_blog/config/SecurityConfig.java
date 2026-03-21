package org.sinabro.sinabro_blog.config;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.security.web.context.SecurityContextRepository;
import org.sinabro.sinabro_blog.config.auth.oauth.PrincipalOauth2UserService;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Autowired
    private PrincipalOauth2UserService principalOauth2UserService;

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }

    @Bean
    public SecurityContextRepository securityContextRepository() {
        return new HttpSessionSecurityContextRepository();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf(AbstractHttpConfigurer::disable)
                .securityContext(context -> context
                        .securityContextRepository(securityContextRepository())
                        .requireExplicitSave(false)
                )
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
                )
                .exceptionHandling(exception -> exception
                        .authenticationEntryPoint((request, response, authException) -> {
                            // API 요청은 401 반환, 웹 페이지 요청은 로그인 페이지로 리다이렉트
                            String accept = request.getHeader("Accept");
                            if (accept != null && accept.contains("application/json")) {
                                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                                response.setContentType("application/json;charset=UTF-8");
                                response.getWriter().write("{\"message\":\"인증이 필요합니다.\"}");
                            } else {
                                response.sendRedirect("/loginForm");
                            }
                        })
                )
                .authorizeHttpRequests(
                        authorizeRequests -> authorizeRequests
                                .requestMatchers("/user/**").authenticated()
                                .requestMatchers("/users/me").authenticated()
                                .requestMatchers("/manager/**").hasAnyRole("ADMIN", "MANAGER")
                                .requestMatchers("/admin/**").hasAnyRole("ADMIN")
                                .anyRequest().permitAll()
                ).formLogin(formLogin -> {
                    formLogin.loginPage("/loginForm")
                            .usernameParameter("accountId")
                            .loginProcessingUrl("/login")
                            .defaultSuccessUrl("/");
                }).oauth2Login(oauth2Login -> {
                    oauth2Login.loginPage("/oauth2/authorization/google")
                            .defaultSuccessUrl("/")
                            .failureUrl("/oauth2/authorization/google")
                            .userInfoEndpoint(userInfoEndpoint ->
                                    userInfoEndpoint.userService(principalOauth2UserService)
                            );
                }).logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/loginForm")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                );

        return http.build();
    }
}

