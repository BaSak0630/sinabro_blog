---
title: "JAVA Spring API - 조회 API 지연 로딩과 성능 최적화"
date: "2024. 3. 31. 18:12"
category: "JAVA/JAVA SPRING"
url: "https://basakreview.tistory.com/50"
---
김영한님의 실전! 스프링 부트와 JPA 활용 2 - API 개발과 성능 최적화 편을 공부하는 과정중 나의 생각을 정리하는 목적을 가지고 있다.

xToOne(ManyToOne,OneToOne)관계에서 성능 최적화

```
    @GetMapping("/api/v1/members")
    public List<Member> membersV1(){
        return memberService.findMembers();
    }
```

위 코드에 경우 엔티티가 직접 노출되게 된다. 하지만 협업에서는 엔티티를 직접 노출하면 안되다. 그리고 array를 넘겨주기 때문 확장성이 떨어진다.

별도의 DTO나 Request,Response객체를 만들어 엔티티를 숨기고 내가 원한 스펙 엔티티의 정보를 담아 보낼 수 있게 만들어 주어야 한다.  아래는 내가 진행하는 프로젝트의 일부 코드이다.

```
    @GetMapping("/facilitys")
    public Result facilitys(){
        List<FacilityDto> collect = facilityService.findAll().stream()
                .map(f -> new FacilityDto(f.getFcltCd()))
                .collect(Collectors.toList());
        //for사용해도 무방

        return new Result(collect);
    }

    @Data
    @AllArgsConstructor
    static class Result<T> {
        private T data;
    }

    @Data
    @AllArgsConstructor
    static class FacilityDto{
        String fcltCd;
    }
```

그리고 본 예제 프로그램에서는 Member가 Orders를 가지고 있으면선 Orders의 Order또한 Member을 가지고 있어 서로 양방향 연관관계를 가지고 있어 양방항 연관관계의 문제가 생겨 JSON의 문제가 생기게 된다. 그러서 둘 중 하나는  @JsonIgnore 해주어야 무한으로 JSON을 생성하지 않게 된다.

```
    @JsonIgnore//양방형 관계에서 둥중하는 JsonIgnore 해주어야한다.
    @OneToMany(mappedBy = "member")  //mappedBy는 보여지는 거울이라고 명시
    private List<Order> orders = new ArrayList<>();
```

지연 로디 (LAZY)를 피하기 위해서 즉시로딩(EARGER)으로 설정하면 안된다.즉시 로딩 떄문에 연관관계가 필요 없는 경우에도 데이터를 항상 조회해서 성능문제가 발생할 수 있다. 즉 성능 튜닝이 어려워 지기 때문이다.

항상 지연로딩을 기본으로 하고, 성능 최적화가 필요한 경우 패치 조인(fetch join)을 사용해야 한다. <- 본내용은 이후에 추가 글 에서 확인