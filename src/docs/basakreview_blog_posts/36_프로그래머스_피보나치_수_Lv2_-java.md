---
title: "프로그래머스 피보나치 수 Lv2 -java"
date: "2023. 3. 2. 19:37"
category: "알고리즘"
url: "https://basakreview.tistory.com/36"
---
피보나치 수
문제 설명
피보나치 수는 F(0) = 0, F(1) = 1일 때, 1 이상의 n에 대하여 F(n) = F(n-1) + F(n-2) 가 적용되는 수 입니다.

예를들어

F(2) = F(0) + F(1) = 0 + 1 = 1
F(3) = F(1) + F(2) = 1 + 1 = 2
F(4) = F(2) + F(3) = 1 + 2 = 3
F(5) = F(3) + F(4) = 2 + 3 = 5
와 같이 이어집니다.

2 이상의 n이 입력되었을 때, n번째 피보나치 수를 1234567으로 나눈 나머지를 리턴하는 함수, solution을 완성해 주세요.

제한 사항
n은 2 이상 100,000 이하인 자연수입니다.
입출력 예
n return
3 2
5 5
입출력 예 설명
피보나치수는 0번째부터 0, 1, 1, 2, 3, 5, ... 와 같이 이어집니다.

```
class Solution {
    public int solution(int n) {
      return f(n);
    }
    public int f(int n) {
        if(n <= 1) return n;
        else return (f(n-2) + f(n-1));
    }
}
```

위코드는 테스트 7에서 시간초과가 뜨는데 이유가 메모리 문제 때문에  %1234567을 해주어야 한다고 함.

```
class Solution {
    public int solution(int n) {
        int answer = 0;
        if(n == 1 || n == 0) return 1;
        int a = 0;
        int b = 1;

        for(int i = 2; i <= n; i++){
            answer = (a+b) % 1234567;
            a = b;
            b = answer;
        }
        return   answer;
    }
}
```

가 수정 코드임