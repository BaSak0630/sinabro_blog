---
title: "C_string_strcmp"
date: "2022. 4. 27. 16:50"
category: "언어/C언어"
url: "https://basakreview.tistory.com/10"
---
| #include #include int my_strcmp(char *s,char *t){     int i = 0;     while(s[i] == t[i])     {          if(s[i++] ==  '\0')// 이 if문의 목적은 두 문자열이 같을 때 0을 반환한다.          {             return (0);          }              i++;     }     return(s[i] - t[i]);}main(){     char *p = "kwon";     char *q = "Kim";     int cmp;     cmp =my_strcmp(p,q);      //cmp = strcmp(p,q); //함수가 여러번 수행되는 것을 막기 위해 strcmp의 값을 저장해서 사용한다고 함     if (cmp == 0/*"Kwon" > "Kim"*/) //문자열을 비교할때 부등호만 사용했을때 단순히 주솟값만 비교하게 된다.     {         printf("same\n");     }     else if (cmp > 0 )     {         printf("%s\n",p);     }          else     {         printf("%s\n",q);     }} |
|---|

strcmp함수는 두 문자열을 비교하는 함수이다. 단순히 문자열을 부등호로 비교했을 때 문자열의 크기비교가 아닌 주솟값을 비교 하게 되기 때문에 문자열의 크기 비교해준다. 두 문자열의 아스키 코드 값을 비교해 두 문자열을 뺼셈 했을때 양수면 뒤에 문자열이 작고 음수이면 앞에 문자열이 작은 것이다.