package org.sinabro.sinabro_blog;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication(scanBasePackages = "org.sinabro")
@EntityScan(basePackages = "org.sinabro")
@EnableJpaRepositories(basePackages = "org.sinabro")
public class SinabroBlogApplication {

    public static void main(String[] args) {
        SpringApplication.run(SinabroBlogApplication.class, args);
    }

}
