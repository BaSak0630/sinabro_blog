---
title: "팩토리 패턴 (Factory Pattern)"
date: "2025. 1. 3. 20:03"
category: "디자인패턴"
url: "https://basakreview.tistory.com/74"
---
## 팩토리 메소드 패턴이란?

> 팩토리 메소드 패턴 (Factory Method Pattern) 에서는 객체를 생성할 때 필요한 인터페이스를 만듭니다. 어떤 클래스의 인스턴스를 만들지는 서브클래스에서 결정합니다. 팩토리 메소드 패턴을 사용하면 클래스 인스턴스 만드는 일을 서브클래스에게 맡기게 됩니다.

위에 내용은 **헤드 퍼스트 디자인패턴**에서 팩토리 메소드 패턴을 정의입니다. 책의 내용을 토대로 팩토리 메소드를 공부하면서 알게된 내용을 이야기 해보겠습니다.

## Simple Factory

팩토리 패턴을 본격적으로 알아보기 전에 ‘간단한 팩토리’의 대해서 이야기 해보려고 합니다.

> 객체 생성을 전담하는 create…() 함수를 하나의 클래스에 모아놓는 방법 - simple factory

Simple Factory 디자인 패턴은 아니지만 프로그래밍에서 자수 쓰이는 관용구와 관습에 가깝습니다. java 라이브러리에 **Class BorderFactory**가 존재합니다. 확인해보면 메소드들이 create….()로 앞에 create가 키워드가 붙은 메소드들이 경계선등의 라인객체를 생성합니다. 이제 진짜 팩토리 패턴 2가지에 대해서 이야기 해보겠습니다.

## 생성

‘new’ 연산자를 우리는 객체를 생성할때 정말 자주 사용합니다. 우리는 추상클래스 또는 인터페이스를 구현하는 구상 클래스 만들때의 코드는 아래와 같이 구상객체를 인스터시에이션(Instantiation)합니다.

```
Duck duck = new MallardDuck();

```

그런데 여러 구상 클래스가 존재하는 경우를 아래의 코드처럼 작성하게 됩니다.

```
Duck duck;
if(picnic){
	duck = new MallardDuck(();
} else if(hunting){
	duck = new DecoyDuck();
} else if(inBathTub) {
	duck = new RubberDuck();
}

```

하지만 이렇게 특정 조건을 이용해서 어떤 구상클래스를 생성할 지를 if문을 이용하게 되면 구상 클래스의 수가 늘어나는 경우 매번 수정을 해야합니다. 전에 다른 디지안 패턴 글에서 언급했던 OCP에 어긋나게 되고 즉, 변경에 닫혀있는 코드가 되게 됩니다. 이러한 문제를 팩토리 패턴을 이용해서 해결할 수 있습니다.

피자가게를 예를 들어 설명하겠습니다.

```
    Pizza orderPizza(String orderType) {
        Pizza pizza = null;
        
        if(orderType.equalsIgnoreCase("cheese")) {
            pizza = new CheesePizza();
        }else if(orderType.equalsIgnoreCase("pepperoni")) {
            pizza = new PepperoniPizza();
        }else if(orderType.equalsIgnoreCase("clam")) {
            pizza = new ClamPizza();
        }
        
        pizza.prepare();
        pizza.bake();
        pizza.cut();
        pizza.boxing();
        return pizza;
    }

```

위 코드에도 if문을 통해서 어떤 피자를 원하는지 조건에 따라 인스턴시에이션 해주게 됩니다. 그런데 마찬가지로 피자의 종류가 늘어나는 경우 결국 코드를 계속해서 요구사항의 변경에 따라 수정하게 됩니다. 그래서 객체 생성 부분을 별도로 분리하여 캡슐화 하여 새로운 객체를 만들어 주고 이 객체를 팩토리라고 명명하게 됩니다.

```
public class SimplePizzaFactory {
    public Pizza createPizza(String type) {
        Pizza pizza = null;
        if(type.equalsIgnoreCase("cheese")) {
            pizza = new CheesePizza();
        }else if(type.equalsIgnoreCase("pepperoni")) {
            pizza = new PepperoniPizza();
        }else if(type.equalsIgnoreCase("clam")) {
            pizza = new ClamPizza();
        }
        return pizza;
    }
}

```

위에서 언급한 Simple Factory라고 생각하면 됩니다. 책에서는 일반 멤버 함수로 만들었지만 위에 경우 클래스에 데이터 멤버가 존재하지 않기 때문에 static 멤버 함수로 구현하여도 무방하다고 생각합니다.

```
public class PizzaStore {
	SimplePizzaFactory factory;
 
	public PizzaStore(SimplePizzaFactory factory) { 
		this.factory = factory;
	}
 
	public Pizza orderPizza(String type) {
		Pizza pizza;
 
		pizza = factory.createPizza(type);
 
		pizza.prepare();
		pizza.bake();
		pizza.cut();
		pizza.box();

		return pizza;
	}
}

```

그래서 PizzaStore의 코드는 조건문을 없애고 위와같은 코드로 바꿀수 있습니다.

## Factory Method Pattern

위에 피자 예제는 pizza factory와 store가 한개씩 존재하는 상태입니다. 여기서 예제를 여러지점들이 존재하고 각 지점마다 그 지역의 특성과 입맛을 반영한 다양한 스타일의 피자(뉴욕,시카고,이탈리아 등)를 만들어야 한다고 가정해 보겠습니다. 위에서 사용한 SimplePizzaFactory를 사용하지 않고 서로다른 팩토리를 만든 다음 PizzaStore에서 원하는 팩토리를 사용하도록하는 방법을 살펴 보겠습니다.

```
NYPizzaFactory nyFactory = new NYPizzaFactory();
PizzaStore nyStore = new PizzaStore(nyFactory);
nyStore.orderPizza("Veggie");

ChicagoPizzaFactory chicagoFactory = new ChicagoPizzaFactory();
PizzaStore chicagoStore = new PizzaStore(chicagoFactory);
nyStore.orderPizza("Veggie");

```

하지만 여기서 Factory들도 구상클래스이기 때문에 결국 Store 객체가 Factory 객체를 많이 언급하는게 좋지는 못하다고 판단합니다. 그래서 새로운 아이디어는 Factory객체는 내부에 멤버함수만 존재하기 때문에 별도의 클래스로 유지하는 것 보다는 멤버 함수를 분리시켜 Store객체에 만들어 주고 Factory를 삭제하자는 것입니다. 하지만 이것도 문제점이 존재합니다. PizzaStore는 추상클래스로 존재해야합니다.

```
public abstract class PizzaStore { 
	public Pizza orderPizza(String type) {
		Pizza pizza;
 
		pizza = createPizza(type);
 
		pizza.prepare();
		pizza.bake();
		pizza.cut();
		pizza.box();

		return pizza;
	}
	abstract createPizza(String type);
}

```

PizzaStore에서 우리가 집중해야하는 부분은 createPizza()함수를 추상함수로 만들어 줌으로써 각 지점(뉴욕,시카고,이탈리아 등)에 맞는 서브클래스를 만들어 주면 여러 Factory를 만들어 줄 필요가 없어지게 됩니다.

이 createPizza()함수가 팩토리 메소드 패턴의 핵심이라고 볼수 있습니다.

![](https://blog.kakaocdn.net/dna/bLk0Yd/btsLDYPtc75/AAAAAAAAAAAAAAAAAAAAAP_KEQFIEljcu-FSPyJhCJ0RhUyb26tlAUXacOUnSFo3/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=Bx04TrFUeInIwvnShDgQSteFCpY%3D)

위에 그림을 보면 조금 더 이해가 쉽게 될것입니다. 서브클래스에서 createPizza를 구현하게 되고 저부분의 코드는 위에 SimplePizzaFactory의 createPizza 함수처럼 들어온 파라미터 따라 조건문을 통해 pizza객체를 정해주게 됩니다. 그리고 orderPizza내부에서 createPizza 함수가 호출될 때 Dynamic binding으로 각 서브클래스의 overriding된 함수가 호출되게 됩니다.

### Factory Method Pattern 한문장 설명

> 객체 생성을 전담하는 함수를 부모클래스에 추상함수로 정의하고 그 함수를 하위클래스에서 override 하여 다양한 객체 생성을 실행하도록 하는 패턴

팩토리 메소드 패턴에서 2가지의 목적이 존재합니다.

1. 객체생성을 전담하는 함수를 만들자
2. 구상클래스가 상위클래스를 직접적인 언급하지 않고 간접적으로 언급 상호의존정의 낮추는 것

핵심은 **“사용하는 서브클래스에 따라 생산되는 객체 인스턴스가 결정 됩니다.”**

## 의존성 역전 원칙(Dependency Inversion Principle)

```
public class DependentPizzaStore {
 
	public Pizza createPizza(String style, String type) {
		Pizza pizza = null;
		if (style.equals("NY")) {
			if (type.equals("cheese")) {
				pizza = new NYStyleCheesePizza();
			} else if (type.equals("veggie")) {
				pizza = new NYStyleVeggiePizza();
			} else if (type.equals("clam")) {
				pizza = new NYStyleClamPizza();
			} else if (type.equals("pepperoni")) {
				pizza = new NYStylePepperoniPizza();
			}
		} else if (style.equals("Chicago")) {
			if (type.equals("cheese")) {
				pizza = new ChicagoStyleCheesePizza();
			} else if (type.equals("veggie")) {
				pizza = new ChicagoStyleVeggiePizza();
			} else if (type.equals("clam")) {
				pizza = new ChicagoStyleClamPizza();
			} else if (type.equals("pepperoni")) {
				pizza = new ChicagoStylePepperoniPizza();
			}
		} else {
			System.out.println("Error: invalid type of pizza");
			return null;
		}
		pizza.prepare();
		pizza.bake();
		pizza.cut();
		pizza.box();
		return pizza;
	}
}

```

위 코드는 우리가 팩토리 메소드 패턴을 사용하지 않았을 때 코드입니다.

## Abstract Factory Pattern

> 객체의 부속품에 해당하는 원재료(**Ingredient)**의 다양성을 반영하기 위해 원재료를 제공하는 팩토리 객체를 인터페이스로 정의하고 팩토리 인터페이스를 구현하는 다양한 팩토리 클래스를 정의 하는 방법

이 패턴은 다양성에 초점을 맞추어진 패턴입니다.

![](https://blog.kakaocdn.net/dna/zPgyj/btsLCGP1iwf/AAAAAAAAAAAAAAAAAAAAAEZXK40JSSkgV4zwFQZwIH3s3Ja7zQmW-URYeC2ouD-U/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=FFK7He%2BfxFXeAtYh6zV7CjCoRA8%3D)

## 한문장 정리

> 객체 생성을 전담하는 코드를 특정 함수에 집중시키는 패턴

---

## 📷 이미지 목록

- 이미지 1: https://blog.kakaocdn.net/dna/bLk0Yd/btsLDYPtc75/AAAAAAAAAAAAAAAAAAAAAP_KEQFIEljcu-FSPyJhCJ0RhUyb26tlAUXacOUnSFo3/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=Bx04TrFUeInIwvnShDgQSteFCpY%3D
- 이미지 2: https://blog.kakaocdn.net/dna/zPgyj/btsLCGP1iwf/AAAAAAAAAAAAAAAAAAAAAEZXK40JSSkgV4zwFQZwIH3s3Ja7zQmW-URYeC2ouD-U/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=FFK7He%2BfxFXeAtYh6zV7CjCoRA8%3D