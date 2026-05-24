---
title: "데코레이터 패턴 (Decorator Pattern)"
date: "2024. 11. 19. 13:53"
category: "디자인패턴"
url: "https://basakreview.tistory.com/73"
---
### 데코레이터 패턴(Decorator Pattern)이란?

> 데코레이터는 장식하다, 꾸미다라는 뜻의 decorate에 er(or)을 붙인 말인데 **장식하는 도구** 정도로 설명할 수 있습니다.

> **데코레이터 패턴**(Decorator pattern)으로 객체에 추가 요소를 동적으로 더할 수 있습니다. 데코레이터를 사용하면 서브클래스를 만들 떄보다 훨씬 유연하게 기능을 확장할 수 있습니다.

### 예제 개념 - 커피 전문점

책에서는 예제를 커피전문점에서 커피를 주문을 예로 데코레이터 패턴을 설명하고 있습니다. 기본 아메리카노를 주문할 때 여러가지 옵션을 추가 함으로써 가격과 요소를 추가하는 등의 변화를 주는 프로그램을 제시하고 있습니다. 고객은 커피를 주문할 때 우유나 두유,모카등 추가하는 경우 추가된 요소에 따른 가격등 여러가지 정보가 기본 커피에 적용되는 시스템을 구현 해야할 때 여러 고려 사항들이 존재합니다.

하드코딩으로 데이터 멤버에 요소들을 구성하고 getter/setter 메서드를 이용해 구현하는 방법은 중간에 추가사항이 방생하는 경우 문제가 발생할 여지가 너무나 많습니다. 그리고 추상클래스를 만들어 상속을 받아 만드는 방법 또한 시스템 확장시 상위 클래스 수정시 하의 클래스의 문제가 발생할 가능성이 증가 합니다. 이 두방식 모두 다형성을 표현하는데 부족합니다.

### OCP - Open Closed Principle

갑자기 왜 갑자기 SOLID원칙 이야기를 하는지 궁금할 수 있습니다. 그이유는 위에서 언급한 방법들이 OCP를 지키지 않은 구현 방법을 제시 했기 때문입니다. 데코레이터 패턴은 OCP 원칙을 지키는 대표적인 방법입니다. 그래서 OCP에 대해서 언급하고 넘어 가도록 하겠습니다.

OCP를 한 문장으로 정의 하면 **“클래스는 확장에는 열려 있어야하지만 변경에는 닫혀 있어야한다.”** 입니다. 처음 듣고 순간 모순된 말이라고 생각 했었습니다. 우리의 목표는 코드를 건드리지 않고 새로운 행동을 추가하는 것입니다. 저의 블로그의 앞에 글 중 옵저버 패턴에 대한 내용에서 subject 객체에 코드를 수정하지 않고도 얼마든지 옵저버를 추가할 수 있었습니다. 객체지향 디자인 기법을 보면 행동을 확장할 수 있는 방법도 존재합니다.

하지만 모든 부분에 OCP를 준수해야하는 것은 아닙니다. 책에서는 새로운 단계의 추상화가 필요한 경우 종종 있는데, 추상화를 하다 보면 코드가 복잡해 진다고 합니다. 그래서 우리는 디자인한 것 중에서 가장 바뀔 가능성이 높은 부분을 중점적으로 살펴보고 OCP를 적용하는 방법이 가장 좋다고 합니다.

### 데코레이터 패턴 살펴보기

그럼 이제 데코레이터 패턴에 대해서 이야기 해볼 생각입니다. **장식** 이라는 의미를 가지고 있는데 개념적으로 접근해 볼것입니다.

1. 기본 에스프레소 객체를 가져온다.
2. 우유 객체로 장식한다. (라떼가 된다)
3. 휘핑 객체로 장식한다.
4. cost() 메서드를 호출한다. 이때 첨가물의 가격을 계산하는 일은 해당 객체에게 위임한다.

여기서 **장식**의 개념이 데코레이터 객체의 ‘래핑’이라고 생각하면 편할 것입니다. 데커레이터 객체로 기본 객체를 감싸서 기능을 강화시키는 것이다. 그럼 어떻게 깜싸는 행위를 할 수 있는지 보면 데코레이터 객체는 기본 객체 즉 슈퍼 클레스를 상속받아서 구현해 주는 것입니다. 기본객체의 레퍼런스를 테코레이터 객체에 생성자의 파라미터로 넘겨서 데코레이터 객체의 인스턴스로 유지하는 방식으로 감싸는 것입니다. 그리고 슈퍼클레스를 상속 받았기 때문에 데코레이터 객체를 다시 래핑할 수 있습니다.

![](https://blog.kakaocdn.net/dna/6ueD7/btsKNwUCG1y/AAAAAAAAAAAAAAAAAAAAAPi-TXJ56UgzNUrN73MOvRH76B1gG3lBtMpMlG-fyedK/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=806%2BVQV64GjKBWi99m5E6Hsks%2BQ%3D)

이 UML은 책을 참고하여 인텔리제이로 만들었습니다. 위 UML을 통해서 더 이야기 해보겠습니다. 여기서 기본 객체가 바로 Component입니다. 이 컴포넌트 객체를 상속 받은 Decorator 객체를 사용해서 Component의 기능을 강화할 수 있습니다. 기능을 강화하기 위해서 Decortator 객체의 생성자에 Component객체를 파라미터로 넘기면 인스턴스로 유지하여 인스터스를 활용해서 여러 메소드를 강화할 수 있습니다. 여기서 모두가 Component객체를 상속받은 자식 객체이기 때문에 여러번 Decorator객체로 강화 시키는 것이 가능합니다.

Decorator.java

```
public class Decorator extends Component {
    private final Component component;

    public Decorator(Component component) {
        this.component = component;
    }

    public void methodA() {
        component.methodA();
    }

    public void methodB() {
        component.methodB();
    }
}

```

ConcreteDecoratorA.java

```
public class ConcreteDecoratorA extends Decorator {
    public ConcreteDecoratorA(Component component) {
        super(component);
    }

    @Override
    public void methodA() {
        super.methodA();
        //추가
    }

    @Override
    public void methodB() {
        super.methodB();
    }

    public void newBehavior() {

    }
}

```

### 실사용 예제 - [java.io](http://java.io)

우리는 데코레이터 패턴을 자주 사용하고 있습니다. 백준 알고리즘을 풀어 본 사람들은 java의 i/o stream 을 사용하여 터미널 또는 파일을 통해서 입력을 받아 들이게 되는데 아래의 코드를 보면 더욱 잘 이해 될것입니다.

```
public class Main {
    public static void main(String[] args) {
        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));
    }
}

```

더욱 이해가 쉽게 풀어서 보면 아래의 코드와 같은 역할을 하는데 코드를 보며 설명이 이어 가겠습니다.

```
InputStream in = System.in;
InputStreamReader inputStreamReader = new InputStreamReader(in);
BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

```

InputStreamReader, BufferedReader는 Reader 라는 추상 클래스 상속 받은 Decorator 객체 입니다.

InputStreamReader.java

```
public class InputStreamReader extends Reader {

    private final StreamDecoder sd;

    /**
     * Creates an InputStreamReader that uses the default charset.
     *
     * @param  in   An InputStream
     */
    public InputStreamReader(InputStream in) {
        super(in);
        try {
            sd = StreamDecoder.forInputStreamReader(in, this, (String)null); // ## check lock object
        } catch (UnsupportedEncodingException e) {
            // The default encoding should always be available
            throw new Error(e);
        }
    }

```

sd 가 여기서 기본 객체의 InputStream을 Reader을 상속 받은 StreamDecoder 객체로 변환하여 유지하고 있습니다. 기존 InputStream은 byte 단위로 데이터를 처리하는 InputStreamReader로 랩핑을 함으로써 char 단위로 읽어 들이고 BufferedReader로 랩핑해서 입력받은 데이터를 line단위로 읽어 들이는 등 기능을 강화해서 사용하고 있습니다.

BufferedReader.java

```
public class BufferedReader extends Reader {

    private Reader in; //인스턴스 유지

    private char cb[];
    
    ...
    public BufferedReader(Reader in, int sz) {
        super(in);
        if (sz <= 0)
            throw new IllegalArgumentException("Buffer size <= 0");
        this.in = in;
        cb = new char[sz];
        nextChar = nChars = 0;
    }

```

### 단점

지금까지는 이점과 사용하는 이유에 대해서 이야기 했습니다. 하지만 데코레이터 패턴의 단점 또한 존재합니다.

1. 많은 클래스가 생성됩니다.

결국 계속 새로운 객체를 생성해서 그 객체를 다시 파라미터로 넘겨 새로운 객체를 만들기 때문에 메모리를 낭비하게 됩니다. 데코레이터를 많이 사용하면 시스템이 복잡해질 수 있으며, 코드를 추적하기 어려워질 수 있습니다.

2. 객체 생성 순서가 중요합니다.

강화하면 새로운 객체가 만들어지게 되는데 여러번 랩핑하는 경우 순서를 달리 하는경우 특정 테코레이터로 강화해야 하는 경우가 발생할 수 있습니다. 위에 BufferedReader 의 경우도 마찬가지 입니다. 구성 요소 간의 의존성이 증가하여 버그가 발생할 가능성이 높아질 수 있습니다.

3. 객체의 깊은 복사가 어렵습니다.

결국 객체는 강화된 객체를 인스턴스로 가지고 있지만 강화 이전의 객체 정보 접근에 제한이 존재합니다.

### 한문장 정리

**특정 객체의 기능에 추가 기능을 랩핑을 함으로써 그 객체의 기능을 강화시키는 방법**

### 마무리

오늘은 우테코, 싸피 등 여러 상황들로 인해 디자인 패턴 관련글 업로드를 미루고 있었습니다. 이후 계속해서 공부한 내용을 글로 정리해서 올리겠습니다. 감사합니다.

---

## 📷 이미지 목록

- 이미지 1: https://blog.kakaocdn.net/dna/6ueD7/btsKNwUCG1y/AAAAAAAAAAAAAAAAAAAAAPi-TXJ56UgzNUrN73MOvRH76B1gG3lBtMpMlG-fyedK/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=806%2BVQV64GjKBWi99m5E6Hsks%2BQ%3D