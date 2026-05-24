---
title: "selection sort"
date: "2022. 4. 13. 15:10"
category: "언어/C언어"
url: "https://basakreview.tistory.com/4"
---
| #include void printArray(int a[], int n){     int i;     for (i = 0; i < n; i++)     {            printf("%d ", a[i]);      }      printf("\n");}int getMaxPos(int p[], int n){        int max;        int maxPos;        int i;        max = -1;        maxPos = -1;        for (i = 0; i < n; i++)        {              if (p[i] > max)              {                   max = p[i];                   maxPos = i;               }         }        return maxPos;}void swap(int* a, int* b){         int tmp;          tmp = *a;          *a = *b;           *b = tmp;}void selectionSort(int p[], int n){       int i;       int maxPos;       for (i = 0; i < 9; i++)       {            maxPos = getMaxPos(p, n -i);            swap(&p[maxPos], &p[n - 1 - i]);         }//sorting이라고 함           //phase 단계(변해가는 과정을 한 단계를 phase라고 함)}main(){       int x[10] = {38,54,67,45,89,12,29,17,82,11 };       printf("=========before sort=========\n");      printArray(x, 10);       selectionSort(x, 10);       printf("=========before sort=========\n");        printArray(x, 10);/*max = -1; // 제일 작은수 양수만 있다고 가정maxPos = -1;for (i = 0; i < 10; i++){if (x[i] > max){max = x[i];maxPos = i;}}//*///printf("max = %d, maxPos = %d\n",x[maxPos], maxPos);} |
|---|
|  |
|  |

**select  sort 선택 정렬
앞 에서 배운 swap을 이용해 위치를 바꿔 정렬하는것을 sorting 이라고 한다. 
sorting에는 다양한 방법들이 존재한다. 그 중 bubble sort, selection sort, insertion sort 순서로 쉬다고 한다. 교수님께서 위에 3가지를 먼저 익히라고 하셨다.  위 세가지 sorting  방법을 꼭 익히기 2학년 까지 눈가리고도 짤수 있어야 한다고 하셨고 그렇게 할것이다. 그럼 열심히 해야할듯 하다.**

**다른 sorting 방법중 대표적으로 quick sort, merge sort,heap sort,shell sort 이 4가지가 자주 사용한다고 하셨고 모두 공부 해야한다. 열심히 하자 **