---
title: "C_2차원 배열 Dynamic alloction"
date: "2022. 5. 7. 18:16"
category: "언어/C언어"
url: "https://basakreview.tistory.com/12"
---
| #include #include //#define _CRT_SECURE_NO_WARNINGSint getSum(int **x,int row,int col){     int s = 0;     int i,j;     for(i = 0; i < row;i++)     {         for(j = 0; j          {              s = s + x[i][j];          }     }     return s;}int** mallocArray(int m,int n){    int **p;     int i;     p = (int**)malloc(m*sizeof(int*));//3행 4열의 2차원배열의 동적할당     for(i = 0; i < m; i++)     {          p[i] = (int*)malloc(n*sizeof(int)/*int 4개 짜리 배열*/);     }     return p;}main(){     int **p;     int i,j;     int sum;     p = mallocArray(3,4);     //아래의 2중 루프문에서 i < 4로해서 다른 부분을 건드려서 디버깅이 되지 않았음     for( i = 0; i < 3; i++)     {         for(j = 0; j < 4; j++)          {             p[i][j] = i*4 +j +1;         }     }     for(i = 0; i < 3; i++)     {         for(j = 0; j < 4; j++)         {             printf_s("%4d",p[i][j]);         }           printf_s("\n");     }sum = getSum(p,3,4);printf("%d",sum);} |
|---|

/* 
2차원 배열 동적 할당  
-필요한 만큼의 기억장소 할당 
-함수 호출 시 인자 전달 편의성 
자동할당 할때는 2차원 배열을 1차원배열로 변환해서 사용한것을 안해도 됨 
-무진장 큰 배열의 할당 
-int ** double pointer 소개 
2차원 배열 동적할당할때 반드시 double pointer 사용 
- pointer array 
자료구조 사용 
-자바와 c#에서는 동적 할당만 가능  
배열사용시 무조건 동적할당 차후에는 자동할당하는 배열은 없을 것 

command line argument 
-main(int arg,har** argv) 

3*sizeof(int*)는  integer pointer 의 array int*를 3개의 저장공간을 확보 
p은 int **탑이이다.  

주의 사항 
동적 할당 2차원 배열은 저장 위치가 자동 할당처럼 바로 뒤에 오는 것이 아니라 
포인터 연산은 매우 주의 해야 한다. 임의에 주소를 사용해서 저장공간의 관계성이  
전혀 없다.  

인다이렉싱  
자동할당에 비해 동적할당의 단점은 시간이 더걸린다. 배열의 엘리먼트를 간접적으로 주소를 찾기 때문

계속 디버깅이 안되서 뭐가 문제인지 봤는데 이중루프문에서 배열에 테이터를 넣어줄때 내가 정해준 크기보다 더 많은 개수의 숫자를 넣을려해서
heap영역에 다른 주소값부분을 건드려서 디버깅이 않되더라.

*/