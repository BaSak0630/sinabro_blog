---
title: "옵저버 패턴 (Observer Pattern)"
date: "2024. 9. 21. 07:53"
category: "디자인패턴"
url: "https://basakreview.tistory.com/65"
---
### 옵저버란?

Observer 의 의미는 감시자, 관찰자라는 뜻의 영어단어이고 한국어로는 참관인 정도로 해석할 수있습니다. 그리고 여담으로 영국의 매주 일요일 발행하는 신문이름이 옵저버라고 합니다. ㅋㅋ 디자인 패턴에서 옵저버 패턴(Observer Pattern) 헤드퍼스트 디자인패턴 책에서 정의는 아래와 같습니다.

> 옵저버 패턴은 한 객체의 상태가 바뀌면 그 객체에 의존하는 다른 객체에게 연락이 가고 자동으로 내용이 갱신되는 방식으로 일대다(1:N) 의 의존성을 정의합니다.

정의 만으로는 이해가 어려우니 더욱더 자세하게 알아보자

### 옵저버 패턴 이해하기

옵저버 패턴에는 주제(subject)객체와 옵저버(observer)객체로 이루어져 있다. 주제객체는 상태변화를 감지하는 객체이다 그리고 중요한 데이터를 관리합니다. 옵저버객체는 주제객체로 부터 변경환 데이터를 받아 갱신하고 갱신된 데이터를 이용해 각자의 역할을 수행하는 객체입니다. 책에서 간단한 비유를 들어 설명 하는데 “ 신문사 + 구독자 = 옵저버 패턴 “ 을 비유로 들어서 설명하는 부분이 이해를 위한 가장 좋은 비유라고 생각합니다.

신문사는 주제객체로 구독자는 옵저버객체로 비유를 하고있습니다. 새로운 정보들이 갱신되면 신문사는 구독자들에게 신문을 배부합니다. 매번 새로운 신문을 전달 받고 싶다면 구독자가 아닌 사람이 구독을 하면 구독자가 될 수 있는 것 처럼 옵저버 객체가 아닌 객체가 주제 객체에 등록하면 옵저버객체가 되고 반대의 경우도 마찬가지 입니다.

### 옵저버 패턴은 왜 사용하는가?

기상 스테이션 구축 프로젝트 예제를 이용해서 설명하고 있습니다. 이 예제는 기상 스테이션이 다양한 센서들로 부터 데이터를 계속적으로 받아 디스플레이 장비를 이용해 표시해주는 프로그램을 작성하는 예제입니다.

먼저 WeatherData 클래스를 제시하고 있습니다.

| WeatherData |
|---|
| getTemperature()getHumidity()getPressure()measurementsChanged() |

기상 관측값이 갱신될 때마다 위 3개의 메서드가 호출됩니다.

measurementsChanged() 메서드에서 정보를 업데이트되게 해야합니다.

현재는 각기 다른 의미의 정보를 보여주는 디스플레이가 3가지 존재합니다.

디스플레이는 실행 중 추가및 제거될 수 있습니다.

```
public class WeatherData {
    //인스턴스 변수 선언
    
    public void measurementsChanged(){  
        float temperature = getTemperature();
        float humidity = getHumidity();
        float pressure = getPressure();

        currentConditionsDisplay.update(temperature, humidity, pressure);
        statisticsDisplay.update(temperature, humidity, pressure);
        forecastDisplay.update(temperature, humidity, pressure);
    }
}

```

코드에서 기상 관측값의 갱신을 받아서 3가지의 디스플레이를 업데이트 해주는 코드입니다. 이 코드는 옵저버 패턴이 적용이 되어 있지 않습니다. 그리고 예제에서는 요구사항 변경의 가능성을 미리 이야기 하였습니다.

이 예제에서 강조하는 것은 ‘확장성’입니다. 아직 개발 초기 단계라고 가정해 보죠. 갑자기 새로운 구성의 디스플레이가 필요하게 되거나 기존의 디스플레이를 제거해야한다고 가정하고 만들어야합니다. 그렇게 되면 새로운 디스플레이를 추가하는 경우 코드의 변경점이 너무나 많이 발생하게 됩니다. 구체적인 구현에 맞춰서 코딩을 해서 프로그램을 수정하지 않으면 다른 디스플레이를 추가하거나 제거도 불가능합니다. 책에서는 Coupling(결합도)이 높다고 표현하고 있습니다. 위 코드에 옵저버 패턴을 적용해 여러 문제를 해결해 볼 예정입니다.

### 옵저버 패턴의 구조

![](https://blog.kakaocdn.net/dna/bWB8E0/btsJGH4aQro/AAAAAAAAAAAAAAAAAAAAALuMDDp_NJBBs0XDiRtzpCyxlgp7loCCRELh8h08XX1q/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=ziIdVGd2ZzIpuXLIKcXA1h5Jb8Q%3D)

먼저 subject를 보면 observer를 추가하고 등록하는 함수를 볼수 있고 notifyObservers()는 변경발생 시 옵저버의 update를 이용해 변경점을 전달한다. 그리고 옵저버 패턴에서 코드상으로 중요도가 높은건 subject 쪽이다.

먼저 WetherStation 클래스를 확인해 보겠습니다.

```
public class WeatherStation {
    public static void main(String[] args) {
        WeaterData weaterData = new WeaterData();

        CurrentConditionsDisplay x = new CurrentConditionsDisplay(weaterData);
        //weaterData.registerObserver(x);
        StatisticsDisplay y = new StatisticsDisplay(weaterData);

        //센서가 있다고 가정
        weaterData.setMeasurements(80,65,30.4f);
        weaterData.setMeasurements(82,70,29.2f);
        weaterData.setMeasurements(78,90,29.2f);
    }
}

```

코드를 확인해보면 subject인 WeatherData를 만들어주고 2개의 observer객체를 생성해주는 동시에 observer객체의 생성자에서 WeatherData의 레퍼런스를 넘겨서 등록합니다.

```
public class CurrentConditionsDisplay implements Observer {
    private double temperature;
    private double humidity;
    private Subject weatherData;

    public CurrentConditionsDisplay(WeatherData weatherData) {
        this.weatherData = weatherData;
        weatherData.registerObserver(this);
    }

    @Override
    public void update(double temp, double humidity, double pressure) {
        this.temperature = temp;
        this.humidity = humidity;

        display();
    }

    private void display() {
        System.out.println("Current Conditions: " + temperature + "F degrees and, " + humidity + "% humidity");
    }
}

```

그러면 subject인 WeatherData의 컬랙션 객체에 observer들이 등록되고 관리할 수 있게 됩니다.

```
public class WeatherData implements Subject {
    private ArrayList<Observer> observers;
    private double temperature;
    private double humidity;
    private double pressure;

    public WeatherData() {
        this.observers = new ArrayList<>();
    }

    @Override
    public void registerObserver(Observer observer) {
        observers.add(observer);
    }

    @Override
    public void removeObserver(Observer observer) {
        observers.remove(observer);
    }

    @Override
    public void notifyObservers() {
        for (Observer observer : observers) {
            observer.update(temperature, humidity, pressure);
        }
    }

    private void measurementsChanged() {
        notifyObservers();
    }

    public void setMeasurements(double temp, double humidity, double pressure) {
        this.temperature = temp;
        this.humidity = humidity;
        this.pressure = pressure;

        measurementsChanged();
    }
}

```

옵저버 패턴에서는 컬랙션 객체는 등록,제거,업데이트를 일괄적으로 처리 하기 위해서 필수적이라 볼수 있다. WeatherStation에서 데이터들이 갱신될 경우 WeatherData의 setMeasurements() 메서드를 호출하여 등록된 observer 변경 알림을 update() 메서드를 통해 전달하여 각 observer객체에서 변경된 데이터를 이용해 각자의 역할을 수행합니다.

### 느슨한 결합 (Loose Coupling)

예제에서 옵저버 패턴을 적용하지 않았던 코드를 설명하면서 Coupling(결합도)이 높다고 이야기 했습니다. 결합도는 **모듈 간에 상호 의존하는 정도 또는 두 모듈 사이의 연관 관계를 의미합니다.** 그래서 결합도는 낮을 수록 좋고 프로그램의 유연성이 높다 또는 느슨한 결합이라 표현하기도 합니다. 느슨한 결합은 객체들이 상호작용할 수 있지만, 서로를 잘 모르는 관계를 의미합니다. 옵저버 패턴은 느슨한 결합을 보여주는 훌륭한 예입니다.

- 주제는 옵저버가 특정 인터페이스(Observer 인터페이스)를 구현한다는 사실만 압니다.
- 주제객체는 옵저버의 구상 클래스의 정보를 몰라도 되고 알 필요또한 없습니다. 결국 인터페이스만 인지하고 있다면 여러 구상클래스의 구현정보는 주제객체와 아무런 연관이 없습니다.
- 옵저버는 언제든지 새로 추가할 수 있습니다.
- 주제객체는 컬랙션 객체를 통해 옵저버의 레퍼런스를 일괄적으로 관리하기 때문에 언제든지 추가하고 제거해도 무방합니다. 결국 주제객체는 자신에게 등록된 레퍼런스를 통해 변경된 데이터를 전달하는것이 주목적이기 때문입니다.
- 새로운 형식의 옵저버를 추가할 때도 주제를 변경할 필요가 전혀 없습니다.
- 새로 만들어지는 옵저버가 발생하더라도 주제객체의 코드를 변경하는 일은 발생하지 않는다. 옵저버가 등록되기만 하면 문제가 없습니다.
- 주제와 옵저버는 서로 독립적으로 재사용할 수 있습니다.
- 주제나 옵저버 둘 모두 다른 용도로 활용할 일이 있다고 해도 손쉽게 재사용가능하다. 느슨한 결합으로 유연하기 때문에 가능한 일입니다.
- 주제나 옵저버가 달라져도 서로 영향을 미치지 않습니다.
- 인터페이스의 구현한다는 조건만 만족하면 어떻게 고쳐도 문제는 발생하지 않느다.

### Java 라이브러리의 옵저버

위의 예제는 subject와 observer를 직접 인터페이스 부터 구현체까지 직접 개발하였다. 하지만, 옵저버 패턴도 디자인 패턴이기 때문에 우리들의 수많은 스승 개발자님들이 너무나 대단하기 때문에 우리는 그저 가져다 쓰기만 하면 된다. 자바 라이브러리에서 아래와 같이 클래스들이 존재합니다.

subject interface → observable class

observer interface → observer class

둘다 라이브러리에 인터페이스로 존재한다. 가져다 구현제를 만들어주고 사용하면 된다.

### 옵저버의 push vs pull

Observer interface 함수의 update() 메소드의 특징은 pull 방식으로 작동 됩니다. push 와 pull방식을 설명은 아래와 같습니다.

push 방식 - subject가 모든 데이터를 옵저버에게 밀어주는 방식( 위에 예제처럼 페라미터에 직접적을 넘겨주는 것)

pull 방식 - 옵저버에게 subject의 레퍼런스를 전달하는 방식 (Java 라이브러리 에서 사용하는 방식)

| Modifier and Type | Method | Description |
|---|---|---|
| void | update(Observable o, Object arg) | Deprecated. This method is called whenever the observed object is changed. |

위와 같이 observer의 update() 메서드의 파라미터는 2개입니다. 그 이유는 범용적인 활용을 위해서 pull 방식과 push방식을 모두 사용할 수 있도록 개발 되었습니다. Observable o 는 subject 레퍼런스를 받습니다. object arg 는 subject의 데이터를 통제로 전달 받는데 객체 레퍼런스를 통해 데이터를 밀어넣으면 rtti를 해 풀어서 사용합니다. 개인적으로 생각했을때 push 방식은 묶여있는 데이터를 풀어서 작업을해 손이 더많이 가서 subject 객체 레퍼런스를 받아서 원하는 데이터를 getter를 통해 옵저버 구현체의 맞게 사용할 수 있어서 라이브러리에서 pull방식을 사용하는것 같습니다. 그리고 라이브러리에서 pull 방식을 사용할 떄 arg는 null 값이 넘어서 옵니다.

### 다시 정의 해보기

옵저버 패턴은 데이터의 발생(이벤트)를 사용하는 다수의 처리기(이벤트 처리기)에 전달하기 위한 방법

1. subject가 상태 변화 감지
2. collection 객체를 이용한 observer 관리
3. observer에서 데이터 처리

그리고 자바에서 이벤트 처리기 등록 메커니즘에서 이용되고 있습니다.

---

## 📷 이미지 목록

- 이미지 1: https://blog.kakaocdn.net/dna/bWB8E0/btsJGH4aQro/AAAAAAAAAAAAAAAAAAAAALuMDDp_NJBBs0XDiRtzpCyxlgp7loCCRELh8h08XX1q/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=ziIdVGd2ZzIpuXLIKcXA1h5Jb8Q%3D