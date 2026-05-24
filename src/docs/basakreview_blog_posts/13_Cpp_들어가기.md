---
title: "Cpp 들어가기"
date: "2022. 6. 25. 15:30"
category: "언어/CPP"
url: "https://basakreview.tistory.com/13"
---
## **C -> Cpp iostream**

| #include <iostream>int main(){     char name[100];     char lang[200];     std::cout << "이름을 입력하세요"<< std::endl;     std::cin >> name;     std::cout << "좋아하는 프로그래밍 언어를 입력하세요" << std::endl;     std::cin >> lang;     std::cout << "내이름은 "<< name <<" 입니다"<<std::endl;     std::cout << "제가 좋아하는 프로그래밍 언어는"<< lang <<"입니다"<<std::endl;} |
|---|

cpp에서는 stdio.h를 대신해 iostream을 사용한다. cpp에서는 헤더파일의 선언에서는 확장자를 생략하기로 약속되어 있다
입출력 시 std,cout,cin 을 사용한다

## **C -> Cpp Function Overloading**

| #include <iostream>void MyFunc(){     std::cout<<"MyFunc() caled"<< std::endl;}void MyFunc(char c){     std::wcout<<"MyFunc(char c) called" <<std::endl;}void MyFunc(int a, int b){     std::wcout<<"MyFunc(int a, int b) called" <<std::endl;}int main(){     MyFunc();     MyFunc('A');     MyFunc(12,13);     return 0;} |
|---|

Cpp의 함수 오버로딩
C에서는 동일한 이름의 복수의 함수가 존재하지 못하는데 Cpp에서는
동일한 함수 명이지만 함수들이 다른 매개변수(parameter)를 가지고 있다면 이를 허용한다.
자료형또는 갯수가 달라야한다.

## **C -> Cpp Default Value**

| #include int adder(int num1 = 1, int num2 = 2);int adder(int num1, int num2)// int adder(int num = 1, int num2 =2){       return num1 + num2;}int main(){      std::cout<<adder()<<std::endl;      std::cout<<adder(5)<<std::endl;      std::cout<<asser(3,5)<<std::endl;      return 0; } |
|---|

함수의 원형을 별도로 선언하는 경우, 매개변수의 디폴트 값은 함수의 원형 선언에만 위치시켜야 한다.
위 코드처럼 함수 선언시 매개변수의 미리 값을 고정시켜서 함수 호출 시 인자가 전달하지 않으면
미리 선언해준 디폴트 값이 적용된다.
여기서 주의해야 할 것은
int YourFunc(int num1 = 10, int num2 = 20, int num3)
은 불가능하다 그이유는 함수에 전달되는 인자가 왼쪽에서붜 오른쪽으로 채워지기 때문이다
YourFunc(,,30)이 안되기 떄문이다.