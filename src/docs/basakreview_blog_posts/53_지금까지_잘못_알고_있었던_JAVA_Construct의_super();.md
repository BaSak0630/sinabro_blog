---
title: "지금까지 잘못 알고 있었던 JAVA Construct의 super();"
date: "2024. 4. 17. 20:42"
category: "JAVA"
url: "https://basakreview.tistory.com/53"
---
이야기의 시작은 동아리실에서 함께하는 동기가 나에게 정보처리기사 필기 기출 문제를 보여주게 되면서 시작되었다.

문제는 23년도 3회차 20번 문제인데 내가 가지고 있는 시나공 기출문제집과는 다른 코드의 문제였다. 그 코드는 다음과 같다.

```
//자바로 작성된 아래 코드의 실행 결과를 쓰시오.
class Parent {
    int x = 100;
    Parent() {
        this(500);
    }
    Parent(int x) {
        this.x = x;
    }
    int getX() {
        return x;
    }
}
class Child extends Parent {
    int x = 4000;
    Child() {
        this(5000);
    }
    Child(int x) {
        this.x = x;
    }
}

public class Main {
    public static void main(String[] args) {
        Child obj = new Child();
        System.out.println(obj.getX());
    }
}
```

**문제를 쉽게 풀었다면 이 글이 굉장히 바보같아 보이겠지만 지금와서 보면 내가 봐도 그렇게 보여서 부정하진 않겠다.**

나를 포함한 컴퓨터공학과 동기 4인은 모두 당연하게 답을 100 이라고 생각했다. 하지만 위 코드의 결과값은 500 이 출력된다.

나는 이해가 되지 않았다. 상속의 상위객체의 생성자의 실행코드가 없어 상위 클래스 즉, super클래스에게 상속받은 데이터 멤버가 생략되어 있지만 Child obj 레퍼런스가 인스터스를 생성할 때 2개의 x(부모클래스로 부터 받은 x 를 p.x라고하고 자식 클래스의 x를 c.x라고 지칭하겠다.)가 각각 p.x 는 100이되고 c.x 는 4000이 되고 생성자가 실행되어 c.x만 5000으로 변경되어 obj.getX(); 의 결과는 p.x 100 이 출력될 것 이라 예상하였다. 물론 당연하다고 필자가 바보같아 보일 수 있다. 하지만 나와 같은 동아리이면서 함께 웰체크 프로젝트를 진행하고 있는 이 친구와는 이해를 못하면 그냥 넘어가질 못하는 전형적인 공부 못하는 놈들의 습관이 갑자기 또 발동되어 둘이서 흥분해서 원인을 분석하기 시작했다. 그도 그럴게, (김교수님의 수업을 통해) 자바에 대해선 웬 만큼은 잘 알고 특히 이런 문제에 자신있는 사람들였기 때문이다.

### 첫 번째 논제 : this()를 실행했는데 왜 super()가 실행되는가?

출력 결과가 500 이라는 것은 즉, Parent 클래스의 생성자가 실행되었다는 것이다. 하지만 보다시피 어딜 봐도 super()를 실행하는 코드는 없다.
모두 한참 고민한 결과 첫 번째로, 다음과 같은 설득력 있는 가설로 종합되었다.

> 가설 1.
> 먼저, 모두 알다시피 자식 클래스 객체(인스턴스)에는 부모 클래스 객체의 데이터 멤버가 할당된다. 따라서 Child 객체를 생성 할 때, "Child 객체가 가지는 Parent 클래스의 데이터 멤버를 할당해주기 위해" 상속관계를 확인하고 따라가서 Parent 클래스의 생성자도 호출되는 것이다

> 증명 시도 1)
> 위 가설에 따르면 Child 클래스의 생성자가 먼저 실행되고, 그 다음에 Parent 클래스의 생성자가 실행되어야 한다. 따라서 위 문제의 각 생성자에 출력문을 넣어서 디버깅 해 보았다.
> 하지만
>  
> 예상과는 다르게 Parent 클래스의 생성자부터 실행되었다. Parent 클래스의 생성자가 호출되는 것 조차도 이해할 수 없는데, 호출 순서도 Parent 클래스부터 되니 상당히 황당했다. (후술하겠지만 참고로 사실 이 때의 디버깅 방식은 잘 못 되었었다.)
> 증명 시도 2)
> 그래서 두 번째로, Parent 클래스의 데이터 멤버를 제거해주고 실행해 보았다. 그렇다면 위 가설에 따라 Parent 클래스의 데이터 멤버를 할당해 줄 필요가 없으니 Parent의 생성자는 호출되지 않아야 했지만, 출력 결과는 이 전과 마찬가지로 Parent의 생성자부터 호출되고 있었다.
> -> 따라서 첫 번째 가설은 틀렸다는 것을 알게 되었다.

### 두 번째 논제 : 그렇다면 왜 부모 클래스의 생성자부터 호출되나?

super()가 호출되는 이유는 차치하고서라도, Child 객체를 Instantiation하는 코드를 실행했는데 뜬금없이 Parent 클래스의 생성자부터 호출되는 이유는 또 대체 무엇인가?
여기선 정말 답이 안 보였다. 그러던 중 위 4인 중 한 명인, 김 모 학생의 창의적인 발상이 유력한 가설로 채택되었다.

> ****가설 2.**
> 콜 스택(Call Stack)에 Child 클래스의 생성자, Parent 클래스의 생성자 순서로 호출되어 저장되었다가, Stack 로직에 따라 거꾸로 Parent 클래스의 생성자 함수부터 pop() 되어 실행되었다는 것이다.**

![](https://blog.kakaocdn.net/dna/bOIqb1/btsGI7cwRE9/AAAAAAAAAAAAAAAAAAAAAJo6Q9GA6pezL2KFKc6PNg87yi3LXY4IHohsmfC4YMNN/img.jpg?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=1wsEBGRJDatdA1FgKfTWnEJiB8Y%3D)
콜스택의 가설을 그림으로 표현함(ㄱㅈㅅ)

(김 모 학생이 열심히 설명한 흔적이다. 구두로 함께 설명하여 알아보긴 어렵지만 기념으로 첨부한다.)

모두 감탄하며 해당 의견에 공감하는 뜻을 표했다. 하지만 결국 왜 부모 객체의 생성자가 실행되는지의 의문은 해결 되지 않았다고 생각했다.  한가지 의견은 ㅇㅎㅅ의 의견은 생성자를 무한히 호출하여 메모리 오버플로우를 유도해서 콜 스택을 터뜨려 보자는 것이었다. 하지만 순서를 확인하지 못하는데 그게 무슨 의미가 있냐며 내가 반문하게되었다. 두 번째로는 역시 최후의 수단으로 콜 스택을 직접 까(?)보는 방법을 찾아보려고 했다. 하지만 어떤 방법으로 시도해야하는지 감조차 오지않았다. 그러던 중 나는 위의 문제에서 더 나아가, 여러 단계에 걸쳐 상속받은 경우의 Constructor 실행 순서를 테스트한 결과 최상위 클래스의 Constructor 부터 순차적으로 실행된다는 사실을 확인하였다. 나는 사실 우연에 의한 결과가 아닐까 라고도 생각했지만 분명한 논리적인 이유가 있다는 사실을 확인한 순간이었다.

또한 이럴게 아니라, 작년에 수업내용을 필기한 자료나 보유중인 서적을 확인해보자는 의견이 (놀랍게도) 이제서야 나왔고 ㅇㅎㅅ이 처음 혼자서 자바를 공부할 때 사용했던 책인 '이것이 자바다'에서 1번 논제와 2번 논제에 대한 해답을 찾게 되었다.

> 1번 논제, 2번 논제에 대한 해답
> 책의 내용을 인용하면 다음과 같다."부모 생성자는 자식 생성자의 맨 첫 줄에 숨겨져 있는 super()에 의해 호출된다."
> - 이것이 자바다 289p

이에 따르면, 위 문제에서 this(5000)가 호출되기 전에 숨겨져 있는 super()가 먼저 실행된다는 것이다.
(미리 말하면, 책의 내용은 이상이 없음에도 불구하고 이 서술은 잘 못 되었다. 이는 세 번째 논제의 이야기를 통해 알 수 있다.)

```
Child(){
	//super();	숨겨져 있던 super()가 먼저 실행됨! (라고 생각했다)
    this(5000);
}
```

덧붙이면, 정확히는 super()는 컴파일 과정에서 자동으로 추가된다고 한다.
이 내용을 적용해 보니 문제의 출력 값도 정답대로 500이 나오고, 지금까지 언급한 모든 문제들의 아귀도 들어맞아 해결되었다고 생각했다. 하지만 여기서 또 문제가 발견되었다. **하지만 위에 코드는 틀렸다.** 그이야기는 아래에서 이어서 하겠다.

### 세 번째 논제 : 그럼 왜 super(); this(); 는 컴파일 오류가 뜨느냐?

![](https://blog.kakaocdn.net/dna/bOWBad/btsGH3PfqDR/AAAAAAAAAAAAAAAAAAAAAFjhvX-rbmS7Bm9d3uymbf0JxaabfjL0cfQWNr7PUKS3/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=RM%2BIwfr2vEOgK5JG0QCPb%2FGpc1s%3D)

현재 문제는 2번의 상황이라고 할 수 있다. 적힌대로 숨겨진 super()가 실행되고 this()가 실행된다면, 3번과 같이 super()를 직접 명시해주어도 똑같은 일 일 것이다. 따라서 이를 증명하고자 실행해 봤더니, 황당하게도 컴파일에러가 발생했다. 아니 2번은 되면서 3번은 왜 컴파일 에러가 뜨는 것인가?

이에 대한 가설은 다음과 같았다.

> **가설 3.**
> super()와 this() 모두 생성자를 호출하는 함수이므로, 숨겨진 super()를 실행하고 this()를 실행하는 것이 아니라, 숨겨진 super() **대신에** this()가 호출 된다는 것이다.

> 증명시도 1)
> 위 가설이 맞다면, 다음 코드를 통해 증명할 수 있다고 생각했다.
> 
> 
> ```
> class aaa {
>    aaa(){
>       System.out.printf("aaa ");
>    }
> }
> class bbb extends aaa {
>    int b;
>    bbb(){			//첫번째로 호출
>       this(10);
>       System.out.printf("bbb ");
>    }
>    bbb(int x){		//두번째로 호출
>       this("input ");
>       b = x;
>       System.out.printf("this ");
>    }
>    bbb(String s){	//세번째로 호출
>       //super();
>       System.out.printf(s + " ");
>    }
> }
> class Test3 {
>    public static void main(String args[])
>    {
>       bbb b = new bbb();
>    }
> }
> ```
> 
> 
> 가설에 따른 이 코드의 로직은
> 먼저 bbb()가 호출되고, 해당 생성자에 숨겨진 super()는 this(10)로 대체되어 두번째 생성자가 호출되고, 두번째 생성자에 숨겨진 super()는 this("input")으로 대체되어 세번째 생성자가 호출되고, 세번째 생성자에 숨겨진 super()가 호출될 것이다. 그리고 super()가 실행되어 aaa를 출력한 후, 돌아가면서 순서대로 print문을 출력할 것이다.
> 실행 결과 aaa input this bbb 가 나옴으로써 해당 가설이 증명되었다. (감격)

> ### 3번 논제에 대한 해답
> 
> 
> 숨겨진 super()를 실행하고 this()를 실행하는 것이 아니라, 숨겨진 super() 대신에 this()가 호출 된다, 즉 3번 가설이 곧 해답이다.

> ## 결론
> 
> 
> ### 1. 모든 Constructor에는 첫 번째 Line에 super()가 숨겨져 있다.
> 
> 
> ### 2. this()를 사용하면 super()와 치환된다.

본 결론에 따라 지금까지 언급한 모든 문제(정처기 문제, 정처기 문제에서의 생성자 호출 순서, 여러번에 걸쳐 상속받은 클래스의 생성자 호출 순서, 마지막 3번 가설)들이 해결되었다. **우리들이 이문제를 틀리게 된 이유를 집어보면 결론에서 this()를 상용하면 super()를 치환하게 된다는 사실만 인지한 생태로 문제를 풀었기 때문이다. **

우리가 평소에 작성하고 사용하는 코드 들은 상속을 받은 객체의 데이터 멤버과 하위 객체의 데이터 멤버를 생성하는 과정에서 대부분의 데이터 멤버를 초기화를 해주었기 때문 더욱 더 인지 하지 못했던 것 같다. this()는 자주 사용하면서도 this()안에 super()를 인지 못했던 이유를 다시 생각해보면 super()를 실행하여도 다시 생성자에서 초기화해 주어서 필자가 그것을 인지 못했던 것 같다.

우리는 하던 공부도 다 때려치고 이걸로 토론하며 원인을 찾아가는 과정도 재밌었다. 일전에도 이렇게 까지는 아니였지만, 함수와 메서드의 차이라던가, 메인 함수가 static 메서드로 선언되는 이유같은 재미있는 주제로 이야기를 자주한 또 이런 형태의 문제를 만나면 또 글을 쓸예정이다. 이글은 우리들이 생각한 과정을 동기인 ㅇㅎㅅ이 글로 정리한 것을 토대로 다시 나의 블로그에 작석한 글임을 알리는 바이다.

본 정처기 문제의 코드를 한 번 리뷰해 보자면, 변수 명을 중복해서 사용한 것도 문제지만 가장 큰 문제는 변수 값의 초기화와 super() 메서드 호출을 상당히 해괴한 방식으로 하고 있다는 것이다. 상위 객체에 대한 초기화 작업을 알기 쉽도록 평범하게 해준다면, 왠만하면 이런 문제를 겪진 않을 것 같다는 이야기를 했다.

![](https://blog.kakaocdn.net/dna/7S77l/btsGIUYHZj9/AAAAAAAAAAAAAAAAAAAAAEKumA0fp6GMsFiGtnwrnnt5u5KVLcUuZUg6kgBleFOT/img.jpg?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=0bHiYpQBkhZO9IaxFSxXfnIxm3M%3D)

---

## 📷 이미지 목록

- 이미지 1: https://blog.kakaocdn.net/dna/bOIqb1/btsGI7cwRE9/AAAAAAAAAAAAAAAAAAAAAJo6Q9GA6pezL2KFKc6PNg87yi3LXY4IHohsmfC4YMNN/img.jpg?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=1wsEBGRJDatdA1FgKfTWnEJiB8Y%3D
- 이미지 2: https://blog.kakaocdn.net/dna/bOWBad/btsGH3PfqDR/AAAAAAAAAAAAAAAAAAAAAFjhvX-rbmS7Bm9d3uymbf0JxaabfjL0cfQWNr7PUKS3/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=RM%2BIwfr2vEOgK5JG0QCPb%2FGpc1s%3D
- 이미지 3: https://blog.kakaocdn.net/dna/7S77l/btsGIUYHZj9/AAAAAAAAAAAAAAAAAAAAAEKumA0fp6GMsFiGtnwrnnt5u5KVLcUuZUg6kgBleFOT/img.jpg?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=0bHiYpQBkhZO9IaxFSxXfnIxm3M%3D