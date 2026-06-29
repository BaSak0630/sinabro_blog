# Sinabro Blog — 포트폴리오

> **개인 풀스택 블로그 프로젝트**  
> 백엔드 REST API 설계부터 React SPA · Next.js SSR 프론트엔드까지 직접 구현

- **GitHub**: [github.com/BaSak0630/sinabro_blog](https://github.com/BaSak0630/sinabro_blog)
- **개발 기간**: 2025.09 ~ 진행 중
- **역할**: 풀스택 개발 (개인 프로젝트)

---

## 목차

1. [프로젝트 개요](#1-프로젝트-개요)
2. [기술 스택](#2-기술-스택)
3. [시스템 아키텍처](#3-시스템-아키텍처)
4. [핵심 기능 구현](#4-핵심-기능-구현)
5. [트러블슈팅](#5-트러블슈팅)
6. [회고](#6-회고)

---

## 1. 프로젝트 개요

개인 기술 블로그를 직접 설계·구현한 풀스택 프로젝트입니다.  
단순한 CRUD를 넘어 **Spring Security 이중 인증**, **QueryDSL 동적 쿼리**, **REST Docs API 문서화**, **마크다운 에디터 이미지 업로드** 등 실무에서 자주 마주치는 기술 이슈를 직접 해결하는 데 초점을 맞췄습니다.

**주요 기능**

| 기능 | 설명 |
|------|------|
| 인증 | 로컬 로그인 + Google OAuth2 소셜 로그인 |
| 게시글 | 작성 / 조회 / 수정 / 삭제 + 페이징 + 조회수 |
| 댓글 | 게시글별 댓글 작성 / 삭제 |
| 카테고리 | 게시글 카테고리 분류 |
| 이미지 | 마크다운 에디터 내 이미지 업로드 |
| 권한 | ROLE_ADMIN / ROLE_USER 역할 기반 접근 제어 |
| API 문서 | Spring REST Docs 자동 생성 |

---

## 2. 기술 스택

### Backend

| 분류 | 기술 |
|------|------|
| Language | Java 17 |
| Framework | Spring Boot 3.5.5 |
| Security | Spring Security 6, OAuth2 Client (Google) |
| ORM | Spring Data JPA, QueryDSL 5.1.0 |
| DB | MySQL 8.4 (운영), H2 (테스트) |
| API 문서 | Spring REST Docs 3.0.1 + AsciiDoc |
| 모니터링 | Spring Actuator |
| 기타 | Lombok, Spring Validation, Mustache |

### Frontend — SPA (`front/`)

| 분류 | 기술 |
|------|------|
| Framework | React 18 + TypeScript |
| Build | Vite 5 |
| Styling | Tailwind CSS 3 |
| Routing | React Router v6 |
| HTTP | Axios |
| Editor | @uiw/react-md-editor (마크다운) |
| DI | tsyringe |
| Test | Cypress (E2E) |

### Frontend — SSR (`dokhu/`)

| 분류 | 기술 |
|------|------|
| Framework | Next.js 16 + TypeScript |
| Styling | Tailwind CSS 4 |
| 서버 상태 | TanStack Query (React Query v5) |
| 클라이언트 상태 | Zustand 5 |
| UI | Radix UI |

---

## 3. 시스템 아키텍처

```
┌─────────────────────────────────────────────────────┐
│                   Client Layer                      │
│                                                     │
│  ┌──────────────────┐   ┌──────────────────────┐   │
│  │  front/ (SPA)    │   │  dokhu/ (SSR)        │   │
│  │  React + Vite    │   │  Next.js 16          │   │
│  │  Tailwind CSS    │   │  TanStack Query      │   │
│  │  React Router v6 │   │  Zustand             │   │
│  └────────┬─────────┘   └──────────┬───────────┘   │
└───────────┼─────────────────────────┼───────────────┘
            │ REST API                │ REST API
            ▼                         ▼
┌─────────────────────────────────────────────────────┐
│              Spring Boot 3.5.5 (API Server)         │
│                                                     │
│  SecurityFilterChain                                │
│  ├── Form Login (PrincipalDetailsService)           │
│  └── OAuth2 Login (PrincipalOauth2UserService)      │
│                                                     │
│  PostController / CommentController                 │
│  CategoryController / ImageController               │
│                                                     │
│  PostService / CommentService                       │
│                                                     │
│  PostRepository (JPA + QueryDSL)                    │
│  AccountRepository                                  │
└──────────────────────┬──────────────────────────────┘
                       │
            ┌──────────┴──────────┐
            │  MySQL 8.4 (운영)   │
            │  H2 (테스트)        │
            └─────────────────────┘
```

### 패키지 구조 (Backend)

```
src/main/java/org/sinabro/sinabro_blog/
├── SinabroBlogApplication.java
├── post/
│   ├── controller/
│   │   ├── PostController.java       # CRUD + 역할 기반 권한
│   │   ├── CommentController.java
│   │   ├── CategoryController.java
│   │   └── ImageController.java      # 이미지 업로드
│   ├── domain/
│   │   ├── Post.java                 # PostEditor 패턴
│   │   ├── Comment.java
│   │   └── Category.java
│   ├── repository/
│   │   ├── PostRepository.java
│   │   ├── PostRepositoryCustom.java  # QueryDSL 인터페이스
│   │   └── PostRepositoryImpl.java   # QueryDSL 구현체
│   ├── request/                      # PostCreate / PostEdit / PostEditor / PostSearch
│   ├── response/                     # PostResponse / PagingResponse
│   └── service/
│       ├── PostService.java
│       └── CommentService.java
└── (commonness 공통 모듈)
    ├── config/auth/                  # PrincipalDetails / Security 설정
    ├── user/domain/                  # Account / LocalAccount / OAuthAccount
    └── exception/                    # 커스텀 예외 계층
```

---

## 4. 핵심 기능 구현

### 4-1. Spring Security 이중 인증 통합

**배경**  
Spring Security는 로컬 로그인 시 `UserDetails`, OAuth2 로그인 시 `OAuth2User`를 각각 요구합니다.  
인증 방식마다 principal 타입이 달라지면, 이후 컨트롤러에서 사용자 정보를 꺼낼 때마다 분기 처리가 필요해집니다.

**해결**  
`PrincipalDetails` 클래스 하나가 `UserDetails`와 `OAuth2User`를 **동시에 구현**하도록 설계했습니다.  
로컬/소셜 로그인 방식에 관계없이 `SecurityContextHolder`에서 항상 동일한 타입으로 꺼낼 수 있습니다.

```java
public class PrincipalDetails implements UserDetails, OAuth2User {
    private Account account;
    private Map<String, Object> attributes;

    // 로컬 로그인용
    public PrincipalDetails(Account account) { ... }

    // OAuth2 로그인용
    public PrincipalDetails(Account account, Map<String, Object> attributes) { ... }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_" + account.getRole().name()));
    }
}
```

```java
// 컨트롤러 — 로그인 방식과 무관하게 동일하게 사용
@PostMapping("/posts")
public void post(@AuthenticationPrincipal PrincipalDetails principal,
                 @RequestBody @Valid PostCreate request) {
    postService.write(principal.getAccount().getId(), request);
}
```

**결과**  
컨트롤러 레이어에서 인증 방식에 따른 분기 코드가 완전히 제거되었습니다.

---

### 4-2. JPA JOINED 상속 전략 — 계정 도메인 설계

**배경**  
로컬 계정은 비밀번호를 가지고, OAuth 계정은 provider·access_token·refresh_token을 가집니다.  
단일 테이블로 표현하면 불필요한 NULL 컬럼이 다수 발생합니다.

**해결**  
JPA `JOINED` 상속 전략으로 공통 정보(`Account`)와 로그인 방식별 정보(`LocalAccount`, `OAuthAccount`)를 테이블 단위로 분리했습니다.

```java
@Entity
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class Account {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    protected Long id;
    protected String accountId;  // 로그인 ID
    protected String email;
    protected String username;
    protected Role role;
    ...
}

@Entity
@PrimaryKeyJoinColumn(name = "id")
public class LocalAccount extends Account {
    private String password;  // 로컬 로그인 전용
}

@Entity
@PrimaryKeyJoinColumn(name = "id")
public class OAuthAccount extends Account {
    private String provider;        // "google"
    private String providerUserid;
    private String access_token;
    private String refresh_token;
}
```

**결과**  
NULL 컬럼 없는 정규화된 DB 구조 + 도메인 레벨 타입 안전성 확보

---

### 4-3. QueryDSL 동적 쿼리 + 페이징

**배경**  
게시글 목록 조회 시 작성자(author) 필터를 선택적으로 적용해야 하고, 대량의 데이터에서 페이징을 효율적으로 처리해야 했습니다.  
JPA `@Query`로는 동적 조건을 깔끔하게 표현하기 어렵습니다.

**해결**  
`PostRepositoryCustom` 인터페이스 + `PostRepositoryImpl` 구현체로 QueryDSL을 분리 적용했습니다.  
`BooleanExpression`으로 null-safe 동적 조건을 구성하고, count 쿼리와 list 쿼리를 **분리**해 불필요한 JOIN을 방지했습니다.

```java
@Override
public Page<Post> getList(PostSearch postSearch) {
    // null이면 조건 미적용
    BooleanExpression authorFilter = postSearch.getAuthor() != null
            ? post.account.accountId.eq(postSearch.getAuthor())
            : null;

    // count 쿼리 분리
    long totalCount = jpaQueryFactory
            .select(post.count())
            .from(post)
            .where(authorFilter)
            .fetchFirst();

    // 데이터 조회
    List<Post> items = jpaQueryFactory
            .selectFrom(post)
            .where(authorFilter)
            .limit(postSearch.getSize())
            .offset(postSearch.getOffset())
            .orderBy(post.regDate.desc())
            .fetch();

    return new PageImpl<>(items, postSearch.getPageable(), totalCount);
}
```

**결과**  
작성자 필터 유무에 관계없이 단일 메서드로 처리, count 쿼리와 데이터 쿼리 분리로 불필요한 조인 제거

---

### 4-4. PostEditor 패턴 — 부분 수정 안전성 보장

**배경**  
게시글 수정 시 변경되지 않은 필드에 null이 들어오면 기존 데이터가 유실될 위험이 있습니다.  
Entity에 setter를 직접 열어두면 의도치 않은 수정이 발생할 수 있습니다.

**해결**  
`PostEditor` 빌더 클래스를 별도로 분리했습니다.  
`Post.toEditor()`로 현재 값을 미리 채운 뒤, 수정 요청값으로 덮어씌워 안전한 부분 수정을 구현했습니다.

```java
// Post.java — setter 없이 편집 전용 메서드만 공개
public PostEditor.PostEditorBuilder toEditor() {
    return PostEditor.builder()
            .title(this.title)
            .content(this.content);  // 현재 값으로 초기화
}

public void edit(PostEditor postEditor) {
    this.title = postEditor.getTitle();
    this.content = postEditor.getContent();
}

// PostService.java
@Transactional
public void edit(Long id, PostEdit postEdit) {
    Post post = postRepository.findById(id).orElseThrow(PostNotFound::new);

    PostEditor postEditor = post.toEditor()     // 기존 값으로 시작
            .title(postEdit.getTitle())         // 변경값 덮어쓰기
            .content(postEdit.getContent())
            .build();

    post.edit(postEditor);
}
```

**결과**  
엔티티에 setter를 열지 않고 수정 의도를 명시적으로 표현, null 전달로 인한 데이터 유실 방지

---

### 4-5. 역할 기반 접근 제어 + 커스텀 Permission

**배경**  
게시글 삭제는 ADMIN 권한이 필요하지만, 작성자 본인인지 추가로 검증해야 하는 경우가 있습니다.  
컨트롤러에 직접 조건 분기를 넣으면 관심사가 분리되지 않습니다.

**해결**  
`@PreAuthorize`와 Spring Security의 `hasPermission`을 활용해 권한 검증을 선언적으로 처리했습니다.

```java
// 단순 역할 체크
@PreAuthorize("hasRole('ROLE_ADMIN')")
@PostMapping("/posts")
public void post(...) { ... }

// 역할 + 커스텀 퍼미션 복합 체크
@PreAuthorize("hasRole('ROLE_ADMIN') && hasPermission(#postId, 'POST', 'DELETE')")
@DeleteMapping("/posts/{postId}")
public void delete(@PathVariable Long postId) { ... }
```

**결과**  
비즈니스 권한 로직이 서비스 레이어로 침투하지 않고, 어노테이션 선언 한 줄로 처리

---

### 4-6. 이미지 업로드 — UUID 기반 파일명 관리

**배경**  
마크다운 에디터에서 이미지 삽입 시 원본 파일명이 중복될 경우 기존 파일을 덮어씌우는 문제가 발생합니다.

**해결**  
UUID + 원본 확장자로 파일명을 생성해 충돌을 원천 차단했습니다.

```java
@PostMapping("/upload/image")
public ResponseEntity<Map<String, String>> uploadImage(
        @RequestParam("image") MultipartFile file) throws IOException {

    String ext = extractExtension(file.getOriginalFilename()); // ".png", ".jpg"
    String filename = UUID.randomUUID() + ext;  // 고유 파일명 보장

    Path dir = Paths.get(uploadPath);
    Files.createDirectories(dir);
    Files.copy(file.getInputStream(), dir.resolve(filename));

    return ResponseEntity.ok(Map.of("url", "/uploads/" + filename));
}
```

**결과**  
파일명 충돌 없는 이미지 저장, 마크다운 에디터에서 즉시 미리보기 URL 반환

---

### 4-7. Spring REST Docs — 테스트 기반 API 문서화

**배경**  
Swagger는 프로덕션 코드에 어노테이션이 침투하고, 실제 API 동작과 문서가 불일치하는 문제가 있습니다.

**해결**  
Spring REST Docs를 도입해 MockMvc 테스트가 통과해야만 문서가 생성되는 구조를 적용했습니다.  
build 시 AsciiDoc 스니펫이 자동으로 `src/main/resources/static/docs`로 복사됩니다.

```groovy
// build.gradle
asciidoctor {
    inputs.dir snippetsDir
    configurations 'asciidoctorExt'
    dependsOn test  // 테스트 통과해야 문서 생성
}

bootJar {
    dependsOn asciidoctor
    copy {
        from asciidoctor.outputDir
        into "src/main/resources/static/docs"
    }
}
```

**결과**  
테스트와 문서의 동기화 보장, 프로덕션 코드 오염 없음

---

## 5. 트러블슈팅

### [TS-1] 조회수 동시성 — @Transactional dirty checking 활용

**증상**  
`post.incrementViewCount()` 호출 후 저장 코드가 없는데 조회수가 올라가는 이유를 처음에 파악하지 못함.

**원인**  
JPA는 `@Transactional` 범위 내에서 엔티티 변경을 감지(dirty checking)해 트랜잭션 종료 시 자동으로 UPDATE를 실행합니다.

```java
@Transactional
public PostResponse get(Long id) {
    Post post = postRepository.findById(id).orElseThrow(PostNotFound::new);
    post.incrementViewCount();  // dirty checking → 트랜잭션 종료 시 자동 UPDATE
    return new PostResponse(post);
}
```

**학습**  
JPA dirty checking의 동작 원리를 명확히 이해하고, `@Transactional` 범위 설계의 중요성을 체감.

---

### [TS-2] QueryDSL count 쿼리 분리 — 불필요한 JOIN 제거

**증상**  
페이징 처리 시 Spring Data의 기본 `Page<>` 사용 시 count 쿼리에도 불필요한 JOIN이 포함되어 성능 저하 발생.

**원인**  
Spring Data `Page<>` 반환 시 총 건수 집계 쿼리가 자동으로 생성되는데, 복잡한 JOIN이 포함된 경우 비효율적인 count SQL이 실행됩니다.

**해결**  
`PostRepositoryImpl`에서 count 쿼리를 직접 분리 작성해 최소한의 조건만으로 건수를 집계하도록 수정.

```java
// count 쿼리 — 조인 없이 최소 조건만 적용
long totalCount = jpaQueryFactory
        .select(post.count())
        .from(post)
        .where(authorFilter)  // 필요한 조건만
        .fetchFirst();

// 데이터 쿼리 — 실제 데이터 조회
List<Post> items = jpaQueryFactory
        .selectFrom(post)
        .where(authorFilter)
        .limit(postSearch.getSize())
        .offset(postSearch.getOffset())
        .orderBy(post.regDate.desc())
        .fetch();
```

**결과**  
목록 조회 시 count 쿼리와 data 쿼리의 JOIN 범위를 각각 최적화

---

### [TS-3] React SPA에서 Spring Security CSRF/CORS 충돌

**증상**  
React(Vite, port 5173)에서 Spring Boot(port 8080) API 호출 시 CORS 오류 + POST 요청 403 Forbidden 발생.

**원인**  
- CORS: 서로 다른 Origin 간 요청을 Spring이 차단
- 403: Spring Security의 CSRF 보호가 기본 활성화되어 있어 SPA의 REST 요청이 차단됨

**해결**  
```java
// SecurityConfig
http.csrf(AbstractHttpConfigurer::disable)  // REST API는 stateless → CSRF 불필요

// WebMvcConfig
@Override
public void addCorsMappings(CorsRegistry registry) {
    registry.addMapping("/**")
            .allowedOrigins("http://localhost:5173", "http://localhost:3001")
            .allowedMethods("GET", "POST", "PATCH", "DELETE")
            .allowCredentials(true);
}
```

**결과**  
SPA와 API 서버 간 정상 통신 복원, 세션 쿠키 포함 인증 요청 처리 가능

---

### [TS-4] 이미지 업로드 후 마크다운 미리보기 깨짐

**증상**  
이미지 업로드 후 반환된 URL(`/uploads/xxx.png`)이 마크다운 에디터 미리보기에서 표시되지 않음.

**원인**  
Spring Boot가 `/uploads/` 경로를 정적 리소스 경로로 인식하지 못하고, Spring Security가 해당 경로를 인증 요구 경로로 처리.

**해결**  
```java
// WebMvcConfig — 정적 리소스 경로 등록
@Override
public void addResourceHandlers(ResourceHandlerRegistry registry) {
    registry.addResourceHandler("/uploads/**")
            .addResourceLocations("file:./uploads/");
}

// SecurityConfig — 이미지 경로 인증 제외
.authorizeHttpRequests(auth -> auth
    .requestMatchers("/uploads/**").permitAll()
    ...
)
```

**결과**  
업로드된 이미지가 인증 없이 마크다운 미리보기에서 즉시 표시

---

### [TS-5] `loadUserByUsername` email 폴백 버그

**증상**  
이메일로 로그인 시도 시 accountId 기준으로 먼저 조회 후 실패하면 email로 재조회해야 하는데, 항상 `UsernameNotFoundException` 발생.

**원인**  
`findByEmail()` 결과를 기존 변수에 재할당하지 않아 항상 empty 상태 유지.

```java
// 버그 코드
Optional<Account> accountOptional = accountRepository.findByAccountId(username);
if (accountOptional.isEmpty()) {
    accountRepository.findByEmail(username); // 결과를 버림!
}
// accountOptional 여전히 empty → 항상 예외
```

**해결**  
```java
Optional<Account> accountOptional = accountRepository.findByAccountId(username);
if (accountOptional.isEmpty()) {
    accountOptional = accountRepository.findByEmail(username); // 재할당
}
```

**결과**  
accountId 또는 email 둘 다로 로그인 가능

---

## 6. 회고

### 잘한 점

- **관심사 분리**: `PostRepositoryCustom` 인터페이스로 QueryDSL 구현을 격리해 JPA 기본 메서드와 커스텀 쿼리를 명확히 분리했습니다.
- **단방향 의존성**: 도메인 엔티티에 setter를 열지 않고 `PostEditor` 패턴으로 수정 의도를 강제해 불변성에 가까운 설계를 유지했습니다.
- **인증 통합**: 로컬/OAuth2 인증을 `PrincipalDetails` 하나로 통합해 컨트롤러 레이어 코드를 단순하게 유지했습니다.

### 보완할 점

- **이미지 저장**: 현재 로컬 파일 시스템에 저장하고 있어 서버 재시작·스케일아웃 시 유실 위험이 있습니다. → S3/GCS로 전환 예정
- **조회수 동시성**: 단순 `++` 연산으로 구현되어 있어 동시 요청 시 정확도가 떨어집니다. → Redis 카운터로 개선 검토
- **토큰 기반 인증**: 현재 세션 기반 인증이라 수평 확장 시 세션 공유 문제가 발생할 수 있습니다. → JWT 전환 검토
- **테스트 커버리지**: 서비스 레이어 단위 테스트와 컨트롤러 슬라이스 테스트를 더 체계적으로 작성할 계획입니다.
