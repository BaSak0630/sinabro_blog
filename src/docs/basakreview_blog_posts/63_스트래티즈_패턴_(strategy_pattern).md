---
title: "스트래티즈 패턴 (strategy pattern)"
date: "2024. 9. 10. 20:37"
category: "디자인패턴"
url: "https://basakreview.tistory.com/63"
---
참고 서적에서 간단한 오리 시뮬레이터 프로그램을 활용하여 strategy패턴에 대해 설명하고 있습니다.

코드를 보고 동일하게 설명을 하면 책의 내용을 읽는것과 다름이 없어서 필요한 부분과 나 자신이 이해한 내용을 정리할 생각입니다.

### 정의

strategy의 영단어의 의미는 ‘전략’입니다. 이 책에서 strategy 패턴의 정의는 아래와 같습니다.

> 전략 패턴 (Strategy Pattern)은 알고리즘군을 정의하고 캡슐화해 각각의 알고리즘군을 주정해서 쓸 수 있게 해줍니다. 전략 패턴을 사용하면 클라이언트로 부터 알고리즘을 분리해서 독립적을 변경 할 수 있습니다.

### 오리 시뮬레이터 게임 , SimUduck

책에서 예제로 오리게임을 제작한다고 예를 들고 있습니다. 다양한 오리들을 보여주는 프로그램에서 다양한 방식의 개발방식을 보여주고 문제점과 해결방식을 strategy 패턴을 이용해 제시하고 있다. 최초에는 Duck이라는 슈퍼클래스를 상속받는 2개의 자식 클래스 오리를 구현하는 방식을 보여주고 있습니다.

![](https://blog.kakaocdn.net/dna/RyDiI/btsJxTv7p0s/AAAAAAAAAAAAAAAAAAAAAMfP_8x3_Ef6tStRDbtTz0phgYtRYr0aos7TOJozqZvd/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=7kYjrGYxbMWwNc5zzN6%2BHdCoL3M%3D)

이러한 경우 새로운 오리가 늘어날 경우와 새로운 기능추가되는 경우 상속은 코드를 재사용한다는 점에서 상속을 잘 활용했다고 생각하지만 개발은 편할지 모르지만 유지보수에서 불편한 점이 생기게 됩니다. 상위 객체의 특성을 많이 사용하지 않는 클래스가 존재하게 된다면 문제는 더욱 커지게 되고 불필요한 코드가 발생합니다.

### 인터페이스 설계하기

책의 예제에서 상속은 올바른 해결책이 아님을 이야기하고 또 다른 방법을 제시하고 있습니다. 바로 상위객체가 가지고 있던 기능을 인터페이스로 설계하여 이 기능을 사용하는 하위 클래스가 인터페이스를 구현하는 식으로 개발방식 입니다.

![](https://blog.kakaocdn.net/dna/bDhnFz/btsJys5URgF/AAAAAAAAAAAAAAAAAAAAALmZVOyAmIWB-Ip9l7DyFl66ydVFurdL-N0s2-84ZFAh/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=YgY4w%2BAVQbq3MRtTimmp2CSQIqQ%3D)

그림이 많이 이상하지만 이해해주시면 감사하겠습니다. 이야기를 이어서 하자면 위그림이 참고서에서 제시해주는 또다른 방법입니다. 이렇게 인터페이스를 사용해 오버라이드를 줄인 방식이 좋다고 생각하시나요? 정답은 좋지 못한 방법입니다. 책에서도 이방법을 좋지 못한 방법이라고 이야기하고 있습니다. 위 방식은 코드 중복이 생길 뿐만 이 아니라 유지보수 방면에서 최악의 코드가 되어버렸습니다. 예를들어 fly() 함수를 구현할 때 동일 코드를 여러 클래스를 구현줘야하고 중복이 발생합니다. 심지어는 유지보수를 위해 fly() 함수의 변경사항이 발생하면 하나하나 fly()함수를 구현하는 클래스들을 확인하고 수정해줘야 하는 불상사가 발생하게됩니다. 그래서 이러한 문제를 해결하는 방법론이 이 책에서는 strategy 패턴입니다.

### 행동을 디자인하다

책에서는 상위클래서 Duck에서 fly()와 quack()를 분리해서 변화하는 부분과 변화하지 않는 부분으로 나누어 문제를 해결하려 합니다. 동일한 fly() 함수라도 하위객체에 따라 변화합니다. 그러면 저는 이 부분이 객체지향의 특징인 폴리몰피즘이라고 생각합니다. 그래서 분리된 함수를 행동이라고 생각하고 이런한 부분을 디자인하는 방향으로 이야기를 전개하고 있습니다. 여기서 인터페이스 FlyBehavior를 만들고 구현체 FlyWithWings, FlyNoWay를 만들어 내부에서 각가의 fly()함수를 구현해주는 형태를 만들어줍니다. 상위클래스는 이 인터페이스 인스턴스 변수를 추가함으로써 폴리몰피즘을 나타낼 수 있게 만들어줍니다. 그래서 새로운 하위 클래스 생성자에서 구현체를 결정해주면서 행위를 지정해 줄 수 있게 되고 유지보수 시에는 구현체만 수정하면 기존의 코드의 수정을 피할 수 있습니다. 이로서 OCP원칙까지 지킬 수 있게 되었습니다.

![](https://blog.kakaocdn.net/dna/XCZxh/btsJyLc08rJ/AAAAAAAAAAAAAAAAAAAAABcf1ZUruEKI8v5leOcQRIUNbkOI-4zITGnZulBQ6xaI/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=s2%2BYbIqiZ73%2FkdPWIlwVeZIazfo%3D)

### 나름대로 재정의

책과 교수님의 수업 그리고 구선생(구글)의 도움들을 이용해 strategy 패턴을 나 나름대로 재정의 하자면

> Strategy = interface + aggregation + dynamic biding
> Strategy ≠ 전략 → Strategy = 행동양식
> 김태균 교수님 “함수들을 행동양식으로 캡슐화하여 데이터 멤버화 시켜서 객체의 부속품으로 구현하는 방법"

이라고 재정의 해보았습니다.

---

## 📷 이미지 목록

- 이미지 1: https://blog.kakaocdn.net/dna/RyDiI/btsJxTv7p0s/AAAAAAAAAAAAAAAAAAAAAMfP_8x3_Ef6tStRDbtTz0phgYtRYr0aos7TOJozqZvd/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=7kYjrGYxbMWwNc5zzN6%2BHdCoL3M%3D
- 이미지 2: https://blog.kakaocdn.net/dna/bDhnFz/btsJys5URgF/AAAAAAAAAAAAAAAAAAAAALmZVOyAmIWB-Ip9l7DyFl66ydVFurdL-N0s2-84ZFAh/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=YgY4w%2BAVQbq3MRtTimmp2CSQIqQ%3D
- 이미지 3: https://blog.kakaocdn.net/dna/XCZxh/btsJyLc08rJ/AAAAAAAAAAAAAAAAAAAAABcf1ZUruEKI8v5leOcQRIUNbkOI-4zITGnZulBQ6xaI/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=s2%2BYbIqiZ73%2FkdPWIlwVeZIazfo%3D