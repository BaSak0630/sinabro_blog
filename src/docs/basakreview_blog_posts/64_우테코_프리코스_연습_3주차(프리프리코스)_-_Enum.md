---
title: "우테코 프리코스 연습 3주차(프리프리코스) - Enum"
date: "2024. 9. 12. 19:50"
category: "JAVA"
url: "https://basakreview.tistory.com/64"
---
이번 주차 미션에 추가된 요구 사항

> Java Enum을 적용한다.

여기서 Enum 타입을 저는 잘 사용하지 않았습니다. 기존에 상수를 사용할 때 자체 클래스를 구현하는 경우 또는 인터페이스 상수를 활용하곤 했습니다. 알고있던 내용 말고 새롭게 알게된 내용 위주로 다시한번 새롭게 공부해서 정리 했습니다.

### Enum

기본적인 열거 타입 선언

```
public enum Week {
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY
}

```

기존에 내가 공부했던 Enum 타입은 ‘열거 상수’ 의 형태로 그저 상수로 사용해왔습니다. Week today = Week.MONDAY;

```
public enum Rank {
    FIRST(6,false, 2000000000),
    SECOND(5,true,30000000),
    THIRD(5,false,1500000),
    FOURTH(4,false,50000),
    FIFTH(3,false,5000),
    NON(0,false,0);

    private final int rank;
    private final boolean bonus;
    private final int reward;

    Rank(int rank,boolean bonus, int reward) {
        this.rank = rank;
        this.bonus = bonus;
        this.reward = reward;
    }

    public int getRank() {
        return rank;
    }

    public boolean isBonus() {
        return bonus;
    }

    public int getReward() {
        return reward;
    }
}

```

위의 코드처럼 한가지 속성 속에 추가 속성을 여러 개 가질 수 있고 생성자에 순서대로 각각의 타입으로 넣어 주면 사용이 가능합니다. 원시타입 뿐 아니라 List 또는 다양한 클래스들을 추가할 수 있습니다.

### 함수형 인터페이스 추가

위에서 언급한 다양한 클래스 뿐만 아니라 Enum 타입을 관해서 찾아보던 중 인자값으로 계산식을 가질 수 있도록 지정할 수 있다는 사실을 알게 되었습니다. (Java 8 업데이트 이후부터 가능해졌다고 합니다.)

데이터 멤버에 private final *BiFunction*<Integer,Boolean, Boolean> function; 이렇게 인터페이스를 넣어주면 아래의 코드 처럼 사용이 가능합니다.

```
public enum Rank {
    FIRST(6,false, 2000000000, (count,bonus) -> count == 6),
    SECOND(5,true,30000000,(count,bonus) -> count == 5 && bonus),
    THIRD(5,false,1500000, (count,bonus) -> count == 5 && !bonus),
    FOURTH(4,false,50000, (count,bonus) -> count == 4),
    FIFTH(3,false,5000, (count,bonus) -> count == 3),
    NON(0,false,0, (count,bonus) -> count <= 2);

    private final int count;
    private final boolean bonus;
    private final int reward;
    private final BiFunction<Integer,Boolean, Boolean> function;

    Rank(int count, boolean bonus, int reward, BiFunction<Integer, Boolean, Boolean> function) {
        this.count = count;
        this.bonus = bonus;
        this.reward = reward;
        this.function = function;
    }

    public int getCount() {
        return count;
    }

    public boolean isBonus() {
        return bonus;
    }

    public int getReward() {
        return reward;
    }

    public Boolean getResult(int count, boolean bonus) {
        return function.apply(count,bonus);
    }
}

```

### 기본 함수형 인터페이스

함수형 인터페이스 Descripter Method

| Predicate | T -> boolean | boolean test(T t) |
|---|---|---|
| Consumer | T -> void | void accept(T t) |
| Supplier | () -> T | T get() |
| Function<T, R> | T -> R | R apply(T t) |
| Runnable | () -> void | void run() |
| Callable | () -> T | V call() |

### 두 개의 인자 Bi 인터페이스

위에 3개의 인터페이스의 인자가 두 개 이상의 타입을 받는 인터페이스

함수형 인터페이스 Descripter Method

| BiPredicate | (T, U) -> boolean | boolean test(T t, U u) |
|---|---|---|
| BiConsumer | (T, U) -> void | void accept(T t, U u) |
| BiFunction | (T, U) -> R | R apply(T t, U u) |

저는 이중에서 BiFunction을 사용했습니다.

## BiFunction

```
public interface BiFuncton<T, U, R> {
	R apply(T t, U u);
}

```

```
import java.util.function.BiFunction;

public class BiFunctionEx {

    public static void main(String[] args) {

        BiFunction<String, String, String> func1 = (s1, s2) -> {
            String s3 = s1 + s2;
            return s3;
        };
        String result = func1.apply("Hello", "World");
        System.out.println(result);

        BiFunction<Integer, Integer, Double> func2 = (a1, a2) -> Double.valueOf(a1 % a2);
        Double sum = func2.apply(10, 100);
        System.out.println(sum);
    }
}

```

### 적용하기

Enum에 속성으로 함수형 인터페이스를 추가해주면 아래의 첫번째코드에서 2번째 코드로 코드수를 많이 줄일 수 있게 된다. 지금은 확인해야하는 matchingCount 가 최대 6이지만 만약 더욱 늘어 나거나 bonus등 조건이 늘어나면 상당히 손이 힘들어 질 것이다.

```
 public Rank getRank(WinningNumber winningNumber, BonusNumber bonusNumber) {
        boolean bonus = false;
        int matchingCount = winningNumber.getMatchingCount(numbers);
        if(matchingCount == 5) {
            bonus = bonusNumber.isBonus(numbers);
        }

        if (matchingCount == 6) {
            return Rank.FIRST;
        }
        if (matchingCount == 5 && bonus) {
            return Rank.SECOND;
        }
        if (matchingCount == 5 && !bonus) {
            return Rank.THIRD;
        }
        if (matchingCount == 4 ) {
            return Rank.FOURTH;
        }
        if (matchingCount == 3 ) {
            return Rank.FIFTH;
        }
        return Rank.NON;
    }

```

```
    public Rank getRank(WinningNumber winningNumber, BonusNumber bonusNumber) {
        boolean bonus = false;
        int matchingCount = winningNumber.getMatchingCount(numbers);
        if(matchingCount == 5) {
            bonus = bonusNumber.isBonus(numbers);
        }
        boolean finalBonus = bonus;

        return Arrays.stream(Rank.values())
                .filter(rank -> rank.getResult(matchingCount, finalBonus))
                .findFirst()
                .orElse(Rank.NON);
    }

```

2번째 코드 블럭에서 사용한 stream은 다음에 정리해 보고자 합니다.