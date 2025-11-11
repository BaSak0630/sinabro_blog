package org.sinabro.sinabro_blog.annotation;

import org.springframework.security.test.context.support.WithSecurityContext;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;


@Retention(RetentionPolicy.RUNTIME)
@WithSecurityContext(factory = SinabroMockSecurityContext.class)
public @interface SinabroMockUser {

    String account() default "daile";

    String password() default "1234";

    String email() default "daile@gmail.com";

    String name() default "김동혁";

    //String role() default "ROLE_ADMIN";
}