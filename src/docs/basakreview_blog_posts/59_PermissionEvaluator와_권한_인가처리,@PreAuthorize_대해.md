---
title: "PermissionEvaluator와 권한 인가처리,@PreAuthorize 대해"
date: "2024. 6. 28. 02:47"
category: "JAVA/JAVA SPRING"
url: "https://basakreview.tistory.com/59"
---
### 서론

<aside> 💡 Controller에서 인가처리하는 부분을 공부하면서 @Secured(),@PreAuthorize, @PostAuthorize 3개의 어노테이션을 이용해서 인가처리를 해주면 되다는 것을 알고 이번에 @PreAuthorize에 대해서 집중해서 이야기 해볼 생각이다.

</aside>

### **@PreAuthorize**

```
 		@PreAuthorize("hasRole('ROLE_ADMIN')&&hasPermission(#postId,'POST','DELETE')")
    @DeleteMapping("/posts/{postId}")
    public void delete(@PathVariable(name = "postId") Long postId) {
        PostResponse response = postService.get(postId);
        postService.delete(response.getId());
    }

```

위 코드는 자신이 작성한 게시글을 삭제하는 기능에서 post 에 작성자 정보와 삭제 요청 정보에 유저정보의 권한을 확인하고 인가처리를 요청하는 메서드이다.

• @PreAuthorize: 메서드가 실행되기 전에 인증을 거친다.

Secured 애노테이션과는 다르게 함수를 String 형태로 넣어줄 수 있고, and나 or 등 논리 연산자도 넣어줄 수 있다.

**애노테이션 내에서 사용가능한 함수/기능들**

- hasRole([role]) : 현재 사용자의 권한이 파라미터의 권한과 동일한 경우 true
- hasAnyRole([role1,role2 ...]) : 현재 사용자의 권한 파라미터들의 권한 중 일치하는 것이 있는 경우 true
- principal: 사용자를 증명하는 주요객체(User)를 직접 접근할 수 있다.
- authentication : SecurityContext에 있는 authentication 객체에 접근 할 수 있다.
- permitAll : 모든 접근 허용
- denyAll : 모든 접근 비허용
- isAnonymous() : 현재 사용자가 익명(비로그인)인 상태인 경우 true
- isRememberMe() : 현재 사용자가 RememberMe 사용자라면 true
- isAuthenticated() : 현재 사용자가 익명이 아니라면 (로그인 상태라면) true
- isFullyAuthenticated() : 현재 사용자가 익명이거나 RememberMe 사용자가 아니라면 true

### hasPermission

hasPermission은 permission 권한을 확인하는 역활을 하는 메서드로 PermissionEvaluator 이라는 인터페이스의 메서드이다.

아래의 코드는 PermissionEvaluator의 코드이다.

```
public interface PermissionEvaluator extends AopInfrastructureBean {
    boolean hasPermission(Authentication authentication, Object targetDomainObject, Object permission);

    boolean hasPermission(Authentication authentication, Serializable targetId, String targetType, Object permission);
}

```

위에 PermissionEvaluator을 구현하는 별도의 구현체를 만들었다.

### PermissionEvaluator 구현체

```
@Slf4j
@RequiredArgsConstructor
public class DailelogPermissionEvaluator implements PermissionEvaluator {

    private final PostRepository postRepository;
    @Override
    public boolean hasPermission(Authentication authentication, Object targetDomainObject, Object permission) {
        return false;
    }

    @Override
    public boolean hasPermission(Authentication authentication, Serializable targetId, String targetType, Object permission) {
        var principal = (UserPrincipal) authentication.getPrincipal();

        Post post = postRepository.findById((Long) targetId).orElseThrow(PostNotFound::new);

        if(!post.getUserId().equals(principal.getUserId())){
            log.error("[인가 실패] 해당 사용자가 작성한 글이 아닙니다. targetId = {}",targetId);
            return false;
        }
        return true;
    }
}

```

각 파라미터를 이용해서 인증객체에서 Principal를 가져와 나의 비즈니스 로직에 맞는 UserPrincipal로 가져와서

targetId를 통해 타겟 객체를 가져와서 내부에 작성자 아이디와 UserPrincipal의 아이디를 비교 후 그결과에 따라 인가 승인 결과를 boolean으로 돌려준다.