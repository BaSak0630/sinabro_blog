package org.sinabro.sinabro_blog;

import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication(scanBasePackages = "org.sinabro")
@EntityScan(basePackages = "org.sinabro")
@EnableJpaRepositories(basePackages = "org.sinabro")
@MapperScan(basePackages = "org.sinabro", annotationClass = Mapper.class)
@EnableScheduling
public class SinabroBlogApplication {

    public static void main(String[] args) {
        SpringApplication.run(SinabroBlogApplication.class, args);
    }

}
