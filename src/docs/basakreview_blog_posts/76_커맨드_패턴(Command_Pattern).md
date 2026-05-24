---
title: "커맨드 패턴(Command Pattern)"
date: "2025. 3. 4. 21:11"
category: "디자인패턴"
url: "https://basakreview.tistory.com/76"
---
# 커맨드 패턴이란

> 커맨드 패턴을 사용하면 요청 내역을 객체로 캡슐화해서 객체를 서로 다른 요청 내역에 따라 매개변수화할 수 있습니다. 이러면 요청을 큐에 저장하거나 로그로 기록하거나 작업 취소 기능을 사용할 수 있습니다.

# 만능 리모컨

여기 재미있는 리모컨이 있다고 가정해 보겠습니다. 이 리모컨에는 프로그래밍이 가능한 7개의 슬롯이 있고 각 슬롯에 원하는 제춤을 연결한 다음 옆에있는 버튼으로 조각할 수 있습니다. 그리고 7개의 슬롯마다 각각 ‘ON’ 버튼과 ‘OFF’ 버튼이 존재합니다. 그리고 마지막으로 ‘UNDO’ 버튼이 존재합니다. 우리는 이 리모컨을 여러 다양한 기기를 제어할 수 있는 만능리모컨으로 만들 예정입니다.

![](https://blog.kakaocdn.net/dna/dWFGy9/btsMAVZa0Vh/AAAAAAAAAAAAAAAAAAAAAM6NuJ9BCQADZhEHmVL8pwWBgSBVuYCj9aCYoaDFOg3n/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=DzwJbKhH7jraiz1vzTcJDbfZMOs%3D)

위에 다이얼로그는 리모컨으로 제어해야하는 객체입니다. 클래스가 많은데 공통적인 인터페이스가 있는 것 같진 않습니다. 더 큰 문제는 앞으로 이러한 클래스가 더 추가될 수 있다는 것입니다. 우리는 만능 리모컨을 만들기 위해서 커맨드 패턴을 적용해 보겠습니다. 그럼 커맨드 패턴에 대해서 더 알아보겠습니다.

# 커맨드 패턴 소개

책에서는 커맨드 패턴의 예제로 식당에서 고객과 웨이터 그리고 주문과 주방장 상이의 관계를 다시 살펴보면 커맨드 패턴 속 각 객체 사이의 관계를 쉽게 이해할 수 있을 겁니다. 객체들이 어떤 식으로 분리되는지 감을 잡을 수 있습니다.

**음식 주문 과정**

1. 고객이 종업원에게 주문을 합니다.
2. 종업원은 주문을 받아서 카운터에 전달하고 “주문 들어왔어요!!” 라고 합니다.
3. 주방장은 주문대로 음식을 준비합니다.

**객체와 메소드 과정**

1. 고객.createOrder();
2. 종업원.takeOrder();
3. 종업원.orderUp();
4. 주방장.makeBurger(), makeShake()
5. 결과 return

위에 과정이 이해되지 않을 수 있습니다. 이해를 돕기 위해서 커맨드 패턴을 적용해서 추가로 설명해보겠습니다.

### 1. 리시버

실제 동작이 정의된 리시버를 구현한다.

### 2. 커맨드

인보커(리모컨)에 탑재하기 위한 명령어 클래스를 만든다.

명령어 클래스는 리시버에 존재하는 기능을 활용하여 구현한다. 명령어의 일관성을 위해 Command 인터페이스를 구현하는 형태로 작성한다.

### 3. 인보커

setCommand 메소드를 통해서 인보커에 명령어를 할당받을 수 있도록한다.

명령어 클래스의 명령을 수행 할 수있는 메소드를 구현한다.

### 4. 클라이언트

명령어 인스턴스를 생성하며, 생성자로 리시버를 주입한다.

리시버가 주입된 명령어를 인보커에 주입한다.

인보커는 명령을 수행하면 주입된 커맨드의 메소드를 실행한다.

커맨드의 메소드는 리시버의 메소드를 호출한다.

그럼 앞서 말한 리모컨 예제를 직접 코드로 구현하면서 이야기를 이어가 보겠습니다.

# 커맨드 객체 만들고 사용하기

가장 먼저 커맨드 객체는 모두 같은 인터페이스를 구현해야 합니다. 위에 식당예제에서 종업원의 orderUp()의 메서드는 일반적으로 execute()라는 메서드명을 자주 사용합니다.

```
public interface Command {
	public void execute();
}

```

다음으로는 조명을 켜고 끄는 행위를 하는 커맨드 클래스를 구현해 보겠습니다. 리모컨 예제 속 제공된 Light 클래스의 메서드 2개를 사용하는 커맨드 객체의 코드는 아래와 같습니다.

![](https://blog.kakaocdn.net/dna/dJAbeN/btsMCtGU3Ko/AAAAAAAAAAAAAAAAAAAAANUPAywpZzjRwO483B1GTTYqcVJtq43v8CVa4X0e4dbE/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=dKrQcVSnxpYXQpt25ed3iQlULhg%3D)

```
public class LightOnCommand implements Command {
	Light light;

	public LightOnCommand(Light light) {
		this.light = light;
	}

	public void execute() {
		light.on();
	}
}

```

```
public class LightOffCommand implements Command {
	Light light;
 
	public LightOffCommand(Light light) {
		this.light = light;
	}
 
	public void execute() {
		light.off();
	}
}

```

코드를 확인해보면 커맨드 객체를 구현하였기 떄문에 Command 인터페이스를 구현하고 있고 생성자에 파라미터를 통해 이 커맨드 객체를 제어할 특정 조명 객체의 레퍼런스를 전달 받게 됩니다 . 이 레퍼런스를 데이터 멤버로 저장해서 execute() 메소드가 호출되면 light객체가 바로 그 요청의 리시버가 됩니다.

# 커맨드 객체 만들고 사용하기

제어할 기기를 연결할 슬롯과 버튼이 각각 하나씩 밖에 없는 리모컨에 커맨드 객체를 사용해 봅시다.

```
public class SimpleRemoteControl {
	Command slot;
 
	public SimpleRemoteControl() {}
 
	public void setCommand(Command command) {
		slot = command;
	}
 
	public void buttonWasPressed() {
		slot.execute();
	}
}

```

커맨드를 저장할 스롯1개가 있고 기기 1개를 제어 할 수 있습니다. setCommand(newCommand) 메소드를 이용해 제어할 기기를 변경할 수 있습니다. SimpleRemoteControl 객체는 인보커 객체 입니다. 그리고 책에서 가단한 테스트 코드도 제공하고 있습니다.

```
public class RemoteControlTest {
	public static void main(String[] args) {
		SimpleRemoteControl remote = new SimpleRemoteControl();
		Light light = new Light();
		LightOnCommand lightOn = new LightOnCommand(light);
 
		remote.setCommand(lightOn);
		remote.buttonWasPressed();
    }
	
}

```

# 커맨드 패턴 활용하기

```
public class RemoteLoader {
 
	public static void main(String[] args) {
		RemoteControl remoteControl = new RemoteControl();
 
		Light livingRoomLight = new Light("Living Room");
		Light kitchenLight = new Light("Kitchen");
		CeilingFan ceilingFan= new CeilingFan("Living Room");
		GarageDoor garageDoor = new GarageDoor("Garage");
		Stereo stereo = new Stereo("Living Room");
  
		LightOnCommand livingRoomLightOn = 
				new LightOnCommand(livingRoomLight);
		LightOffCommand livingRoomLightOff = 
				new LightOffCommand(livingRoomLight);
		LightOnCommand kitchenLightOn = 
				new LightOnCommand(kitchenLight);
		LightOffCommand kitchenLightOff = 
				new LightOffCommand(kitchenLight);
  
		CeilingFanOnCommand ceilingFanOn = 
				new CeilingFanOnCommand(ceilingFan);
		CeilingFanOffCommand ceilingFanOff = 
				new CeilingFanOffCommand(ceilingFan);
 
		GarageDoorUpCommand garageDoorUp =
				new GarageDoorUpCommand(garageDoor);
		GarageDoorDownCommand garageDoorDown =
				new GarageDoorDownCommand(garageDoor);
 
		StereoOnWithCDCommand stereoOnWithCD =
				new StereoOnWithCDCommand(stereo);
		StereoOffCommand  stereoOff =
				new StereoOffCommand(stereo);
 
		remoteControl.setCommand(0, livingRoomLightOn, livingRoomLightOff);
		remoteControl.setCommand(1, kitchenLightOn, kitchenLightOff);
		remoteControl.setCommand(2, ceilingFanOn, ceilingFanOff);
		remoteControl.setCommand(3, stereoOnWithCD, stereoOff);
  
		System.out.println(remoteControl);
 
		remoteControl.onButtonWasPushed(0);
		remoteControl.offButtonWasPushed(0);
		remoteControl.onButtonWasPushed(1);
		remoteControl.offButtonWasPushed(1);
		remoteControl.onButtonWasPushed(2);
		remoteControl.offButtonWasPushed(2);
		remoteControl.onButtonWasPushed(3);
		remoteControl.offButtonWasPushed(3);
	}
}

```

위 코드 처럼 main에서 사용할 수 있습니다. 아래는 실행 결과 입니다.

```
------ Remote Control -------
[slot 0] LightOnCommand           LightOffCommand
[slot 1] LightOnCommand           LightOffCommand
[slot 2] CeilingFanOnCommand      CeilingFanOffCommand
[slot 3] StereoOnWithCDCommand    StereoOffCommand
[slot 4] NoCommand                NoCommand
[slot 5] NoCommand                NoCommand
[slot 6] NoCommand                NoCommand

Living Room light is on
Living Room light is off
Kitchen light is on
Kitchen light is off
Living Room ceiling fan is on high
Living Room ceiling fan is off
Living Room stereo is on
Living Room stereo is set for CD input
Living Room stereo volume set to 11
Living Room stereo is off

```

### NoCommand 객체

위 실행 결과를 확인하면 4~6번 슬롯에 null이 아닌 NoCommand 라고 표시된 것을 확인할 수 있습니다. 여기서 NoCommand 는 일종의 널 객체(null object)입니다. 널 객체는 리턴 시 리턴하는 객체가 딱히 존재하지 않지만 null로 처리하지 않고 싶을때 활용하기 좋은 방법입니다. 다른 커맨드 객체와 동일하게 Command 인터페이스를 구현되어 execute() 메소드가 호출되어도 문제가 발생할지 않습니다

특정 슬롯을 쓰려고 할 떄마다 거기에 뭔가가 로딩되어 있는지 확인 하려면 좀 번거로워지게 됩니다. 로딩 현황을 파악하려면 아래의 코드처럼 해야합니다.

```
public void OnButtonWasPushed(int slot){
	  if (onCommands[slot] != null){
			  onCommands[slot].excute();
		}
}

```

그래서 일을 줄이려고 아무것도 하지 않는 커맨드 클래스를 구현하죠.

```
public class NoCommand implements Command {
	public void execute() { }
}

```

아래의 코드 처럼 생성자에서 기본 커맨드를 NoCommand 객체로 초기화 해서 나중에 사용하고 싶은 커맨드 객체를 세팅해주면 null을 따로 처리할 필요가 없어지게 됩니다.

```
Command noCommand = new NoCommand();
		for (int i = 0; i < 7; i++) {
			onCommands[i] = noCommand;
			offCommands[i] = noCommand;
		}

```

# 한마디 정리

> 행위를 매개변수화 할수 있다

---

## 📷 이미지 목록

- 이미지 1: https://blog.kakaocdn.net/dna/dWFGy9/btsMAVZa0Vh/AAAAAAAAAAAAAAAAAAAAAM6NuJ9BCQADZhEHmVL8pwWBgSBVuYCj9aCYoaDFOg3n/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=DzwJbKhH7jraiz1vzTcJDbfZMOs%3D
- 이미지 2: https://blog.kakaocdn.net/dna/dJAbeN/btsMCtGU3Ko/AAAAAAAAAAAAAAAAAAAAANUPAywpZzjRwO483B1GTTYqcVJtq43v8CVa4X0e4dbE/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=dKrQcVSnxpYXQpt25ed3iQlULhg%3D