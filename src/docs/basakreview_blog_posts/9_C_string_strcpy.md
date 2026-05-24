---
title: "C_string_strcpy"
date: "2022. 4. 27. 15:51"
category: "언어/C언어"
url: "https://basakreview.tistory.com/9"
---
| #include <stdio.h>#include <string.h>void my_strcpy(char *to,char *from){     while(*to++ = *from++);}main(){     //char *x = "kim";     char *x = "Kim taegyun";     char y[4]; // 이렇게 되면 기억 장소가 확보 되어 있어야 다른 변수의 기억장소에 영향을 주는 것을 막을 수 있다.     //충분히 넉넉하게 용량을 확보 해야 한다.     //char *y = "Lee";// x,y 둘다 기억장소를 가르키고 있을때     //x의 "Kim"을 y의 "Lee"는 static area에 옮길때 상수풀에 있어 수정을 할수 없기 때문에 런타임 에러가 뜬다.     //char *y; // <= 쓰레기 값 우리가 접근이 안되서 런타임에러     /*     char *x = "kim";     char y[10];     */     my_strcpy(y,x);     //strcpy(y,x);     printf("y = %s\n",y);     //strcpy 사용시 주의할점     //} |
|---|

strcpy함수는 문자열을 복사할 때 사용되는 함수이다. strcpy함수를 사용할 때 주의 할점은 크게 3가지 정도가 존재한다. 첫번째는 문자열을 복사해서 값을 수정할때 수정되는 값이 저장되는 공간을 확보하지 않는 경우 Ex) char *y; 의 경우 y가 가르키는 곳의 쓰레기 값이 들어가 있어 런타임 에러가 발생하게 된다.

두번째는 y의 이미 다른 문자열이 초기화되어 있다면 메모리 static area에 상수풀에 있어 수정할 수 없기 때문이 이또한 런타임 에러가 발생하게 된다. 그리고 마지막 세번째는 저장되는 y의 충분한 장소가 확보되어 있지 않으면 당장은 실행 될수 도 있지만 다른 변수의 주솟값에 영향을 주어 아주 특이한 값변화가 일어나 통제가 힘들기 때문에 충분한 공간을 확보해야 한ㄷ.