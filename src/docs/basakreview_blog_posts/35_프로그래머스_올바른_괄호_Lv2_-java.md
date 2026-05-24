---
title: "프로그래머스 올바른 괄호 Lv2 -java"
date: "2023. 2. 28. 18:15"
category: "알고리즘"
url: "https://basakreview.tistory.com/35"
---
- 올바른 괄호

문제 설명

괄호가 바르게 짝지어졌다는 것은 '(' 문자로 열렸으면 반드시 짝지어서 ')' 문자로 닫혀야 한다는 뜻입니다. 예를 들어

- "()()" 또는 "(())()" 는 올바른 괄호입니다.
- ")()(" 또는 "(()(" 는 올바르지 않은 괄호입니다.

'(' 또는 ')' 로만 이루어진 문자열 s가 주어졌을 때, 문자열 s가 올바른 괄호이면 true를 return 하고, 올바르지 않은 괄호이면 false를 return 하는 solution 함수를 완성해 주세요.

제한사항

- 문자열 s의 길이 : 100,000 이하의 자연수
- 문자열 s는 '(' 또는 ')' 로만 이루어져 있습니다.

---
입출력 예sanswer

| "()()" | true |
|---|---|
| "(())()" | true |
| ")()(" | false |
| "(()(" | false |

입출력 예 설명

입출력 예 #1,2,3,4
문제의 예시와 같습니다.

```
class Solution {
    boolean solution(String s) {
  int openCount = 0;
        int closeCount = 0;

        for (int i = 0; i < s.length(); i++) {
            if (s.charAt(i) == '(') {
                openCount++;
            } else if (s.charAt(i) == ')') {
                closeCount++;
            }
            if (openCount < closeCount) {
                return false;
            }
        }
        if (openCount == closeCount) {
            return true;
        }
        return false;
    }
}
```