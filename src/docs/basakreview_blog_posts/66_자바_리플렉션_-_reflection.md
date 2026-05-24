---
title: "자바 리플렉션 - reflection"
date: "2024. 9. 24. 21:04"
category: "JAVA"
url: "https://basakreview.tistory.com/66"
---
### 1. 리플렉션이란?

단어 자체는 반사, 반영이라는 의미를 가지고 있습니다. java에서는 아래의 의미를 가지고 있습니다.

> **Runtime 시에 이미 로드된 클래스 내에서 다른 클래스를 동적으로 로드하여 생성자, 필드, 메소드 등 access 할 수 있는 기능입니다.**

C 같은 compile 언어들은 필드명, 메소드명 등의 정보를 주소값으로 만 알 수 있습니다. 그런데 java는 프로그램을 실행하면서 필드명, 메소드 명 등을 직접 알아 낼 수 있는 기능이 reflection입니다.

### 2. 사전 지식

- **정적 바인딩 vs 동적 바인딩**

- **바인딩이란 프로그램에 사용된 구성 요소의 실제 값 또는 프로퍼티를 결정짓는 행위**를 의미합니다.
- 정적 바인딩

- **실행 이전에 값이 확정되고 컴파일 타임에 호출될 함수가 결정**되는 것으로, 함수는 기본적으로 정적 바인딩입니다.컴파일러는 선언되어있는 자료형을 보고 바인딩을 하기 때문에 실제로 가리키는 객체가 무엇이든 **포인터의 자료형을 기반으로 호출의대상을 결정**한다.
- 동적 바인딩

- 실행 이후 값이 확정 되고, 런타임에 호출될 함수가 결정나게 됩니다. virtual 키워드를 통해 동적 바인딩하는 함수를 가상 함수라고 합니다. 가상 함수가 선언 되면 포인터 변수가 실제로 가리키는 객체에 따라 호출의 대상이 결정됩니다.다형성의 원리가 적용될 수 있는 멤버 함수(메서드)로써 동적 바인딩으로 처리되는 메서드를 의미합니다. 동적 바인딩 수행 시 가상 메서드 테이블을 참조하여 매핑합니다.
- **가상 메서드 (Virtual Method)**
- 정적 바인딩이 아닌 동적 바인딩으로 처리되기 때문에 컴파일 시점에 정해지지 않은, 실제로 존재하지 않는, 임시로 존재하는 메서드라는 의미로 가상 메서드라고 지칭합니다.
- Class Class
- 이 클래스의 역할은 어떤 클래스를 컴파일 하고 난 후 메모리 상에 로드를 하게 됩니다. c와 달리 클래스 자체에대한 정보를 자료구조화 시켜서 access 할 수 있게 만들어주는 클래스 입니다.
- Recode Classes그 정보가 바로 Recode Classes입니다. 위에서 이야기한 Class Class의 자료구조 화의 모습이 Parse tree 형태의 구조로 되어 클래스 데이터를가지고 있습니다. 이것을 Recode Classes 또는 Class recode라고 합니다.
- .class 파일이 bytecode로 이루어져 있습니다. 파일 내부에 컴파일 완료된 클래스의 정보가 담겨있습니다.

![](https://blog.kakaocdn.net/dna/cTZqvQ/btsJK8ztJJE/AAAAAAAAAAAAAAAAAAAAAGeMsnTuomDikB9484Mb26bOVEo8xHtW8jpamczy19d0/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=IP6kfrnYZ4sdIgn0PSK6VXV913s%3D)

### 3. 실제 코드 예제

```
package je3.reflect;
import java.lang.reflect.*;

public class ShowClass {
    public static void main(String[] args) throws ClassNotFoundException {
        Class c = Class.forName(args[0]);
        print_class(c);
    }
    public static void print_class(Class c)
    {
        if (c.isInterface()) {
            System.out.print(Modifier.toString(c.getModifiers()) + " " + 
			     typename(c));
        }
        else if (c.getSuperclass() != null) {
            System.out.print(Modifier.toString(c.getModifiers()) + " class " +
			     typename(c) +
			     " extends " + typename(c.getSuperclass()));
	}
        else {
            System.out.print(Modifier.toString(c.getModifiers()) + " class " +
			     typename(c));
	}
        Class[] interfaces = c.getInterfaces();
        if ((interfaces != null)&& (interfaces.length > 0)) {
            if (c.isInterface()) System.out.print(" extends ");
            else System.out.print(" implements ");
            for(int i = 0; i < interfaces.length; i++) {
                if (i > 0) System.out.print(", ");
                System.out.print(typename(interfaces[i]));
            }
        }
	
        System.out.println(" {");
        System.out.println("  // Constructors");
        Constructor[] constructors = c.getDeclaredConstructors();
        for(int i = 0; i < constructors.length; i++)
            print_method_or_constructor(constructors[i]);
	
        System.out.println("  // Fields");
        Field[] fields = c.getDeclaredFields();
        for(int i = 0; i < fields.length; i++)
            print_field(fields[i]);
	
        System.out.println("  // Methods");
        Method[] methods = c.getDeclaredMethods();
        for(int i = 0; i < methods.length; i++)
            print_method_or_constructor(methods[i]);
	
        System.out.println("}");
    }

    public static String typename(Class t) {
        String brackets = "";
        while(t.isArray()) {
            brackets += "[]";
            t = t.getComponentType();
        }
	    String name = t.getName();
	    int pos = name.lastIndexOf('.');
	    if (pos != -1) name = name.substring(pos+1);
	    return name + brackets;
    }
    

    public static String modifiers(int m) {
        if (m == 0) return "";
        else return Modifier.toString(m) + " ";
    }
    

    public static void print_field(Field f) {
        System.out.println("  " + modifiers(f.getModifiers()) +
			   typename(f.getType()) + " " + f.getName() + ";");
    }

    public static void print_method_or_constructor(Member member) {
        Class returntype=null, parameters[], exceptions[];
        if (member instanceof Method) {
            Method m = (Method) member;
            returntype = m.getReturnType();
            parameters = m.getParameterTypes();
            exceptions = m.getExceptionTypes();
	        System.out.print("  " + modifiers(member.getModifiers()) +
			     typename(returntype) + " " + member.getName() +
			     "(");
        } else {
            Constructor c = (Constructor) member;
            parameters = c.getParameterTypes();
            exceptions = c.getExceptionTypes();
	        System.out.print("  " + modifiers(member.getModifiers()) +
			     typename(c.getDeclaringClass()) + "(");
        }
	
        for(int i = 0; i < parameters.length; i++) {
            if (i > 0) System.out.print(", ");
            System.out.print(typename(parameters[i]));
        }
        System.out.print(")");
        if (exceptions.length > 0) System.out.print(" throws ");
        for(int i = 0; i < exceptions.length; i++) {
            if (i > 0) System.out.print(", ");
            System.out.print(typename(exceptions[i]));
        }
        System.out.println(";");
    }
}

```

![](https://blog.kakaocdn.net/dna/FzTn6/btsJJIWBbue/AAAAAAAAAAAAAAAAAAAAANxeCD6WLYs05rZcONQ5fORYfJRDMp8FYKQerw7OB1d4/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=G7BUJ4Uncfz2JhWs7%2FJSbMbODLI%3D)

모든 객체에는 getClass()가 존재하고 객체 레퍼런스를 얻어와서 그것을 통해 리플렉션으로 클래스의 다양한 정보를 알아볼 수 있습니다.

단순히 정보를 알아내는 것 뿐 아니라 getMethods() 함수를 통해서 method가 컴파일된 결과값을 가지고 올수 있습니다. 그리고 아래의 코드처럼 활용할 수 있습니다.

```
Class c = Class.forname("main");
Method[] methods = c.getMethods();

methods[0].invoke(obj,agrs);

```

![](https://blog.kakaocdn.net/dna/4a6kw/btsJLajNYra/AAAAAAAAAAAAAAAAAAAAABnxebM_fyYXp_EQwuJg0Cm9t0aLACwcExZg74_Aa8Bf/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=1m8NYwHOAwth6EPC9lRXwonm7DI%3D)

```
car.move(30,50);

```

```
methods[0].invoke(car,args); // args = 30,50

```

### 4. 리플렉션의 활용 사례

- commend 패턴에서 활용
- java.beans
- java.rmi
- 스프링 프레임워크에서 빈(Bean)의 생성과 의존성 주입, 어노테이션 기반의 설정 처리 등 (직접적으로 리플렉션 API를 사용하지 않아도 내부적으로 활용)

위 글은 동아리 테크톡에서 Reflection을 주제로 연사를 준비하던 중 예전 공부하였던 내용을 정리하기 위해 작성한 글입니다. JAVA EXAMPLES IN A NUTSHELL 책과 전공수업, java api document 참고하여 공부하였습니다.

---

## 📷 이미지 목록

- 이미지 1: https://blog.kakaocdn.net/dna/cTZqvQ/btsJK8ztJJE/AAAAAAAAAAAAAAAAAAAAAGeMsnTuomDikB9484Mb26bOVEo8xHtW8jpamczy19d0/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=IP6kfrnYZ4sdIgn0PSK6VXV913s%3D
- 이미지 2: https://blog.kakaocdn.net/dna/FzTn6/btsJJIWBbue/AAAAAAAAAAAAAAAAAAAAANxeCD6WLYs05rZcONQ5fORYfJRDMp8FYKQerw7OB1d4/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=G7BUJ4Uncfz2JhWs7%2FJSbMbODLI%3D
- 이미지 3: https://blog.kakaocdn.net/dna/4a6kw/btsJLajNYra/AAAAAAAAAAAAAAAAAAAAABnxebM_fyYXp_EQwuJg0Cm9t0aLACwcExZg74_Aa8Bf/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=1m8NYwHOAwth6EPC9lRXwonm7DI%3D