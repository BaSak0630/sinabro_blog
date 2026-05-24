---
title: "C_포인터_swap"
date: "2022. 4. 12. 16:39"
category: "언어/C언어"
url: "https://basakreview.tistory.com/3"
---
| /* swap1.c *//* 강의 주제 :swapping*/#include main(){int a = 10;int b = 20;int tmp;printf("before swapping: a = %d b = %d\n", a, b);tmp = a;a = b;b = tmp;/* //아래 방식으로 했을땐...a = b;b = a;*/printf("after swapping: a = %d b = %d\n", a, b);} |
|---|

결과는 다음과 같이 나온다.
before swapping: a = 10 b = 20
after swapping: a = 20 b = 10

| #include void swap(int *a,int *b){  int tmp;    tmp = *a;  *a = *b;  *b = tmp;}main(){  int a = 10;   int b = 20;    printf("before swapping : a = %d , b = %d \n", a,b)  swap(&a,&b); //integer point type   printf("after swapping : a = %d , b = %d \n", a,b);}#include void swap(int *a,int *b){  int tmp;    tmp = *a;  *a = *b;  *b = tmp;}main(){  int a = 10;   int b = 20;    printf("before swapping : a = %d , b = %d \n", a,b)  swap(&a,&b); //integer point type   printf("after swapping : a = %d , b = %d \n", a,b);}#include void swap(int *a,int *b){  int tmp;    tmp = *a;  *a = *b;  *b = tmp;}main(){  int a = 10;   int b = 20;    printf("before swapping : a = %d , b = %d \n", a,b)  swap(&a,&b); //integer point type   printf("after swapping : a = %d , b = %d \n", a,b);} |
|---|

만약 f(x,y,&z,&a,p) 라는 함수가 있다고 가정했을 때 actual parameter 중  x,y,p는 call by value(원래의 값?)이고, &z,&a는 call by reference(주소값)이다.

| #incluidevoid set_10(int a, int b){a = 10;b = 10;}main(){int x;int y;print("beggore initialization : x = %d y =%d \n",x,y);set_10(x,y);pritnf("agter initialization : z = %d y = %d \n", x,y);} |
|---|

결과는 다음과 같이 나온다.

before initialization: x = -858993460 y = -858993460
after initialization: x = -85993460 y = -85996460

위의 코드가 저런 값이 나온 이유는 함수에서 포인터를 사용하지 않아 set_10 함수로 들어간 x,y가 빠져나오면서 메모리 변수 할당이 해제되기 때문이다.

| #includevoid set_10(int *a, int *b){*a = 10;* b = 10;}main(){int x;int y;print("beggore initialization : x = %d y =%d \n",x,y);set_10(&x,&y);pritnf("agter initialization : z = %d y = %d \n", x,y);} |
|---|

main의 값을 함수로 바꾸고 싶으면 call by referencef를해서 포인터를 이용해야 한다.