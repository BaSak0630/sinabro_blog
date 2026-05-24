---
title: "structure"
date: "2022. 6. 25. 15:33"
category: "언어/C언어"
url: "https://basakreview.tistory.com/14"
---
| 구조체 (structure)서로 밀접한 연관이 있는 변수들을 모아 놓은 복합 변수 -> 나중에 "객체"라고 지칭함 |
|---|

| cf.배열*/#include <stdio.h>struct point {int x;int y;};void findCenterPoint(struct point *p,struct point q,struct point r){p->x = (q.x + r.x) / 2;p->y = (q.y + r.y) / 2;}void printPoint(char *name,struct point p){printf("%s = (%d,%d)\n",name,p.x,p.y);}main(){struct point a;struct point b;struct point c;a.x = 10;a.y = 10;b.x = 20;b.y = 30;findCenterPoint(&c,a,b);printPoint("a",a);printPoint("b",b);printPoint("c",c);}/* 결과는 다음과 같이 나온다.a = (10,10)b = (20,30)c = (15,20)*/ |
|---|

- © 2022 GitHub, Inc.

- [Terms](https://docs.github.com/en/github/site-policy/github-terms-of-service)