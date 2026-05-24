---
title: "C_string_strlen"
date: "2022. 4. 25. 19:02"
category: "언어/C언어"
url: "https://basakreview.tistory.com/7"
---
오늘은 문자열 함수 중 srtlen()를 공부하고 직접 strlen를 구현해 보았다.

| #include <stdio.h> #include <string.h> int my_strlen(char *s) {      int n;      for(n = 0; *s != '\0'; s++)      {          n++;      }       return n; } main() {        char x[10];//= {'k','i','m','\0'};        int n;        int i;              /*        x[0] = 'k'; //''를 사용하는 이유는 문자 상수 이기 떄문에 실제로는 아스키 코드 값이라고 생각하면 됨        x[1] = 'i';        x[2] = 'm';        x[3] = '\0';// \0은 나머지 문자열 자리에 NULL 캐릭터 값을 넣는 역활을 한다.        */        //사용하지 않는다면 쓰레기 값이 들어가게 된다.        for(i = 0; i <5; i ++)        {              scanf("%s",x);              //n = strlen(x); //문자열의 크기를 나타내는 함수 논리적 크기만 포함 \0은 포함하지 않는다.              n = my_strlen(x);              printf("length of %s is %d\n",x,n);        } } |
|---|

char x[10] = "kim"; 에서 문자열 상수"kim"은 4bety이다.여기서 3bety가 아닌 이유는 \0이 생략 되어 있기 때문이다. 이와 같은 예로 'a'와 "a" 는 서로 다르다. 'a'는 아스키 코드 값이고 "a"는 문자열을 의미한다.

\0은 문자열 속에서 뒤에 빈 공간에 NULL을 넣는다.

strlen()를 이해 했듯이 앞으로 나오는 함수들도 이해하려고 노력할것이다.