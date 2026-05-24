---
title: "application.yml 커스텀 설정값 사용"
date: "2024. 6. 12. 05:22"
category: "JAVA/JAVA SPRING"
url: "https://basakreview.tistory.com/56"
---
나는 Spring 에서 설정파일 형식을 YAML의 확장자인 .yml을 사용한다.

### YAML이란

<aside> 💡 YAML은 사람이 읽을 수 있는 데이터 직렬화 언어로서, 구성 파일 작성에 자주 사용됩니다. YAML을 yet another markup language로 생각하는 사람도 있고, YAML ain’t markup language(재귀 약어)로 생각하는 사람도 있습니다. 후자는 YAML이 문서가 아닌 데이터용임을 강조하는 말입니다.

</aside>

우리는 Spring, DB등 다양한 설정 정보를 application.yml 파일에서 관리한다. 설정을 직접 구성하고 사용할 수 있도록 커스텀이 가능하다. 어떤 식으로 사용할 수 있는 알아보자.

### 기본 - 간단한 커스텀 설정을 만들어 보자

```
daile:
  hello: "world"

```

daile라는 값이 있고 그안에 hello 라는 식별자에 값이 “world”가 들어가 있는 상태이다. 이것을 SpringApplication이 뜰때 설정 작업파일에 인젝션을 시켜주어야 한다.

AppConfig

```
@Data
@ConfigurationProperties(prefix = "daile")
public class AppConfig {
    public String hello;
}

```

daile를 prefix 하는 값을 가지고 동일 식별자와 변수명에 “world” 값이 주입되게 됩니다. 그런데 Spring 이 뜰때 @ConfigurationProperties이 제대로 작동하여 값이 주입될 수 있도록 알려줘합니다.

SpringApplication

```
@EnableConfigurationProperties(AppConfig.class)
@SpringBootApplication
public class DailelogApplication {

    public static void main(String[] args) {
        SpringApplication.run(DailelogApplication.class, args);
    }

}

```

SpringApplication에 위 코드 처럼 @EnableConfigurationProperties(AppConfig.class) 같이 주입시켜주게 명시해주거나 AppConfig 파일에 @Configuration 어노테이션을 달아주어야 한다.

또한 단순 String 뿐 아니라 다양한 형태의 자료형도 사용이 가능하다.

### 활용 - List

```
daile:
  hello: 
    - "a"
    - "b"
    - "c"
    - "d"

```

AppConfig

```
@Data
@ConfigurationProperties(prefix = "daile")
public class AppConfig {
    public List<String> hello;
}

```

### 활용 - Map

```
daile:
  hello:
    name: "daile"
    home: "busan"
    hobby: "programming"

```

AppConfig

```
@Data
@ConfigurationProperties(prefix = "daile")
public class AppConfig {
    public Map<String,String> hello;
}

```

### 활용 - 별도의 클래스

```
daile:
  hello:
    name: "daile"
    home: "busan"
    hobby: "programming"
    age: 25

```

AppConfig

```
@Data
@ConfigurationProperties(prefix = "daile")
public class AppConfig {

    public Hello hello;

    @Data
    public static class Hello {
        public String name;
        public String home;
        public String hobby;
        public Long age;
    }
}

```

이렇게 다양한 활용이 가능하다. 제대로 사용하기 위해서 build.gradle 에 아래 내용을 추가하면

```
annotationProcessor "org.springframework.boot:spring-boot-configuration-processor"

```

bulid.classes.java.main.META-INF 파일에 아래의 json 형태와 spring-configuration-metadata라는 이름으로 새부내용이 작성 된다. 그리고 인텔리제이가 관련 정보를 가지고 있게 된다.

```
{
  "groups": [
    {
      "name": "daile",
      "type": "com.dailelog.config.AppConfig",
      "sourceType": "com.dailelog.config.AppConfig"
    },
    {
      "name": "daile.hello",
      "type": "com.dailelog.config.AppConfig$Hello",
      "sourceType": "com.dailelog.config.AppConfig"
    }
  ],
  "properties": [
    {
      "name": "daile.hello.age",
      "type": "java.lang.Long",
      "sourceType": "com.dailelog.config.AppConfig$Hello"
    },
    {
      "name": "daile.hello.hobby",
      "type": "java.lang.String",
      "sourceType": "com.dailelog.config.AppConfig$Hello"
    },
    {
      "name": "daile.hello.home",
      "type": "java.lang.String",
      "sourceType": "com.dailelog.config.AppConfig$Hello"
    },
    {
      "name": "daile.hello.name",
      "type": "java.lang.String",
      "sourceType": "com.dailelog.config.AppConfig$Hello"
    }
  ],
  "hints": []
}

```

application.yml 커스텀 설정값 사용