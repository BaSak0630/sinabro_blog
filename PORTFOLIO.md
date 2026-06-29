# Sinabro Blog - 포트폴리오

> Spring Boot 기반 블로그 백엔드 프로젝트  
> 로컬 로그인 + Google OAuth2 소셜 로그인 통합 인증 시스템 구현

---

## 프로젝트 개요

| 항목 | 내용 |
|------|------|
| 기간 | 2025.09 ~ |
| 역할 | 백엔드 설계 및 개발 (개인 프로젝트) |
| 목적 | Spring Security 이중 인증 구조 학습 및 실전 적용 |

---

## 기술 스택

| 분류 | 기술 |
|------|------|
| Language | Java 17 |
| Framework | Spring Boot 3.5.5 |
| Security | Spring Security, OAuth2 Client (Google) |
| ORM | Spring Data JPA |
| DB | MySQL (운영), H2 (테스트) |
| Template | Mustache |
| Docs | Spring REST Docs |
| Etc | Lombok, Spring Validation |

---

## 아키텍처 구조

```
src/main/java/org/sinabro/sinabro_blog/
├── auth/
│   ├── request/          # Login, SignUp DTO
│   └── service/          # AuthService (회원가입 / 로그인 검증)
├── config/
│   ├── SecurityConfig    # Spring Security 필터 체인 설정
│   ├── AppConfig         # PasswordEncoder Bean
│   ├── WebMvcConfig      # MVC 설정
│   └── auth/
│       ├── PrincipalDetails         # UserDetails + OAuth2User 통합 구현체
│       ├── PrincipalDetailsService  # 로컬 로그인 UserDetailsService
│       ├── UserPrincipal            # 인증 정보 래퍼
│       └── oauth/
│           ├── PrincipalOauth2UserService  # OAuth2 사용자 처리
│           └── provider/                   # OAuth2 프로바이더 추상화
├── exception/
│   ├── SinabroException             # 커스텀 예외 최상위 추상 클래스
│   ├── AlreadyExistsAccountException
│   ├── InvalidPassword / InvalidRequest
│   ├── PostNotFound / CommentNotFound / UserNotFound
│   └── Unauthorized
└── user/
    ├── domain/
    │   ├── Account          # 추상 부모 엔티티 (JOINED 전략)
    │   ├── LocalAccount     # 로컬 로그인 계정
    │   ├── OAuthAccount     # OAuth2 소셜 계정
    │   ├── Role             # 권한 열거형
    │   └── UserProfile      # 프로필 정보
    ├── controller/
    ├── repository/
    ├── response/
    └── service/
```

---

## 핵심 구현

### 1. PrincipalDetails - 이중 인증 통합 Principal

**문제 상황**  
Spring Security의 로컬 로그인은 `UserDetails`를, OAuth2 로그인은 `OAuth2User`를 각각 요구한다.  
인증 방식에 따라 principal 객체 타입이 달라지면 이후 사용자 정보를 꺼낼 때마다 타입 분기가 필요해진다.

**해결**  
`PrincipalDetails` 하나가 `UserDetails`와 `OAuth2User`를 **동시에 구현**하도록 설계.

```java
@Data
public class PrincipalDetails implements UserDetails, OAuth2User {

    private Account account;
    private Map<String, Object> attributes;

    // 로컬 로그인용 생성자
    public PrincipalDetails(Account account) { ... }

    // OAuth2 로그인용 생성자
    public PrincipalDetails(Account account, Map<String, Object> attributes) { ... }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singletonList(
            new SimpleGrantedAuthority("ROLE_" + account.getRole().name())
        );
    }
}
```

**효과**  
어떤 방식으로 로그인하든 `SecurityContextHolder`에서 `PrincipalDetails`로 꺼내 쓸 수 있어 컨트롤러 레이어에서 타입 분기 불필요.

---

### 2. Account JPA JOINED 상속 전략

**문제 상황**  
로컬 계정은 password를 가지고, 소셜 계정은 provider / access_token / refresh_token을 가진다.  
단일 테이블로 표현하면 불필요한 null 컬럼이 대량 발생한다.

**해결**  
JPA `JOINED` 상속 전략으로 Account (공통) / LocalAccount / OAuthAccount 테이블을 분리.

```java
@Entity
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class Account {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    protected Long id;
    protected String accountId;
    protected String email;
    protected String username;
    protected Role role;
    ...
}

@Entity
@PrimaryKeyJoinColumn(name = "id")
public class LocalAccount extends Account {
    // 비밀번호만 추가
}

@Entity
@PrimaryKeyJoinColumn(name = "id")
public class OAuthAccount extends Account {
    private String provider;
    private String providerUserid;
    private String access_token;
    private String refresh_token;
}
```

**효과**  
정규화된 DB 구조 + 타입 안전한 도메인 모델 유지.

---

### 3. 커스텀 예외 계층 설계

**문제 상황**  
예외마다 HTTP 상태 코드가 다른데, 이를 핸들러에서 일일이 분기하면 코드가 지저분해진다.

**해결**  
`SinabroException` 추상 클래스에 `statusCode()` 추상 메서드를 강제 정의.

```java
public abstract class SinabroException extends RuntimeException {
    public final Map<String, String> validation = new HashMap<>();

    public abstract int statusCode(); // 각 예외가 HTTP 상태 코드를 직접 반환

    public void addValidation(String fieldName, String message) {
        validation.put(fieldName, message);
    }
}

// 사용 예
public class PostNotFound extends SinabroException {
    @Override
    public int statusCode() { return 404; }
}

public class Unauthorized extends SinabroException {
    @Override
    public int statusCode() { return 401; }
}
```

**효과**  
`@ExceptionHandler(SinabroException.class)` 하나로 모든 커스텀 예외를 처리하고, `e.statusCode()`로 응답 코드 결정 가능.

---

## 트러블슈팅

### [TS-1] 이메일 폴백 로그인이 항상 실패하는 문제

**증상**  
email로 로그인 시도 시 accountId로 찾지 못하면 `UsernameNotFoundException` 발생.

**원인 분석**  
`PrincipalDetailsService.loadUserByUsername()`에서 email 재시도 결과를 변수에 담지 않음.

```java
// 버그 코드
Optional<Account> accountOptional = accountRepository.findByAccountId(username);

if (accountOptional.isEmpty()) {
    // findByEmail 결과를 버림! accountOptional은 여전히 empty
    accountRepository.findByEmail(username);
}

if (accountOptional.isEmpty()) {
    throw new UsernameNotFoundException(...); // 항상 예외 발생
}
```

**수정**

```java
Optional<Account> accountOptional = accountRepository.findByAccountId(username);

if (accountOptional.isEmpty()) {
    log.info("accountId로 찾지 못함, email로 재시도: {}", username);
    accountOptional = accountRepository.findByEmail(username); // 결과 재할당
}
```

---

### [TS-2] System.out.printf에서 {} 플레이스홀더가 동작하지 않는 문제

**증상**  
로그 출력 시 실제 값 대신 `{}` 문자가 그대로 출력됨.

**원인 분석**  
`{}` 플레이스홀더는 SLF4J의 문법이지만, `System.out.printf`는 `%s` / `%d` 포맷을 사용함.

```java
// 버그 코드 (AuthService, PrincipalDetails)
System.out.printf("비밀번호 불일치 - accountId: {}", login.getAccountId());
// 출력: 비밀번호 불일치 - accountId: {}
```

**수정**  
`@Slf4j` 어노테이션 + SLF4J 로거로 통일.

```java
@Slf4j
@Service
public class AuthService {
    public void login(Login login) {
        ...
        log.warn("비밀번호 불일치 - accountId: {}", login.getAccountId());
    }
}
```

---

### [TS-3] AuthService.login()이 실제 Spring Security 세션을 생성하지 않는 문제

**증상**  
`login()` 호출이 성공해도 이후 요청에서 인증되지 않은 상태로 처리됨.

**원인 분석**  
`AuthService.login()`이 비밀번호 검증만 수행하고 `SecurityContextHolder`에 `Authentication`을 등록하지 않음.  
Spring Security의 Form Login 필터 체인(`loginProcessingUrl("/login")`)과 완전히 분리된 별도 메서드임.

```java
// 현재 코드 - 검증 후 아무것도 하지 않음
public void login(Login login) {
    Account account = accountService.findByAccountId(login.getAccountId())
            .orElseThrow(() -> new UserNotFound());

    if (!passwordEncoder.matches(login.getPassword(), account.getPassword())) {
        throw new InvalidPassword();
    }
    // SecurityContextHolder 등록 없음 → 세션 인증 안됨
}
```

**해결 방향**  
두 가지 선택지:
- Spring Security Form Login(`/login` POST)에 위임하고 `AuthService.login()`은 제거
- 또는 `UsernamePasswordAuthenticationToken` 생성 후 `SecurityContextHolder.getContext().setAuthentication(auth)` 명시 호출

---

### [TS-4] OAuth2 loginPage 설정 오류

**증상**  
미인증 사용자가 보호된 URL에 접근 시 로그인 페이지가 아닌 OAuth2 인증 화면으로 바로 리다이렉트됨.

**원인 분석**  
`SecurityConfig`에서 `oauth2Login.loginPage()`에 커스텀 로그인 페이지 URL 대신 OAuth2 인증 엔드포인트를 직접 지정.

```java
// 버그 코드
.oauth2Login(oauth2Login -> {
    oauth2Login.loginPage("/oauth2/authorization/google") // 잘못된 설정
    ...
});
```

**수정**

```java
.oauth2Login(oauth2Login -> {
    oauth2Login.loginPage("/loginForm") // form login과 동일한 커스텀 로그인 페이지
    ...
});
```

---

## 학습 포인트 요약

| 주제 | 핵심 내용 |
|------|----------|
| Spring Security 이중 인증 | `UserDetails` + `OAuth2User` 동시 구현으로 인증 방식 통합 |
| JPA 상속 전략 | JOINED 전략으로 도메인 타입 안전성과 DB 정규화 동시 달성 |
| 커스텀 예외 계층 | 추상 클래스 + `statusCode()` 강제 구현으로 예외 핸들러 단순화 |
| 로깅 | `System.out.printf` vs SLF4J 플레이스홀더 차이 |
| Security 세션 | Spring Security 필터 체인과 수동 인증 로직의 분리 이슈 |
