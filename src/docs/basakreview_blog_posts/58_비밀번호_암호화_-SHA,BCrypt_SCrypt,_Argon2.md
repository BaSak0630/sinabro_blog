---
title: "비밀번호 암호화 -SHA,BCrypt SCrypt, Argon2"
date: "2024. 6. 20. 17:29"
category: "JAVA"
url: "https://basakreview.tistory.com/58"
---
## 해시란?

```
해시(hash)란 임의의 길이의 데이터를 고정된 길이의 데이터로 매핑(mapping)한 값이다.

```

## SHA?

**SHA (Secure Hash Algorithm, 안전한 해시 알고리즘)** 함수들은 **암호학적 해시 함수**들의 모음입니다. 이는 미국 국가안보국(NSA)이 1993년에 처음으로 설계했으며 미국 국가 표준으로 지정되었습니다.

SHA 함수군에 속하는 최초의 함수는 공식적으로 SHA라고 불리지만, 나중에 설계된 함수들과 구별하기 위하여 SHA-0이라고도 불립니다. 2년 후(1995) SHA-0를 변형한, 개정된 알고리즘인 SHA-1이 발표되었으며, 그 후에 4종류의 변형, SHA-224, SHA-256, SHA-384, SHA-512가 더 발표되었습니다. 이들을 통칭해서 SHA-2라고 하기도 합니다. 후에 나머지 SHA 함수들과 내부적으로 다른 SHA-3가 개발되었습니다.

1.SHA1

SHA-1은 SHA-0을 변형한 SHA 함수들 중 하나이며, 1995년 발표되었고 SHA 함수들 중 가장 많이 쓰이고 있습니다.

SHA-1은 **임의의 길이의 입력데이터 (최대 2⁶⁴)를 160비트의 출력데이터(해시값)**로 바꿉니다.

로널드 라이베스트(Ronald Lorin Rivest)가 MD4 및 MD5 해시 함수에서 사용했던 것과 비슷한 방법을 사용합니다.

2.SHA256

**단방향 알고리즘**의 한 종류로, **해시 값을 이용한 암호화 방식 중 하나이다.** 256비트로 구성되며 64자리 문자열을 반환한다.

단방향 알고리즘이란 암호화는 가능하지만 복호화는 불가능한 것을 의미하고, 사용자의 비밀번호와 같은 보안상 문제가 발생할 수 있는 경우에 사용하면 좋다.

( 암호화는 단방향 뿐만아니라 양방향도 있다. 양방향은 암호화와 복호화가 가능하다. )

SHA-256 해시 함수는 어떤 길이의 값을 입력하더라도 256비트의 고정된 결과값을 출력한다. 일반적으로 입력값이 조금만 변동하여도 출력값이 완전히 달라지기 때문에 출력값을 토대로 입력값을 유추하는 것은 거의 불가능하다. 아주 작은 확률로 입력값이 다름에도 불구하고 출력값이 같은 경우가 발생하는데 이것을 충돌이라고 한다. 이러한 충돌의 발생 확률이 낮을수록 좋은 함수라고 평가된다.

3.MD5

SHA-1은 MD5보다 빠르고 더 높은 보안성을 가지고 있습니다. 보안성이 강하다고 하는 것은 두 가지를 의미하는데, 메시지 다이제스트(message digest) 된 값을 보고 이것에 해당하는 원본 메시지를 찾는 것이 어렵다는 것과 똑같은 메시지 다이제스트 값을 생성하는 2개의 서로 다른 메시지를 찾는 것이 어려운 것을 말한다고 합니다. 또한 SHA-1은 원본 메시지의 조그만 변화도 매우 급속하게 메시지 다이제스트에 변화를 전파합니다(눈사태 효과).

## 왜 위에 방식으로 암호화 하면 안되는 이유

### **문제점**

동일한 문자열은 동일한 해시값을 반환하게 됩니다. 따라서 해시값을 저장해두는 레인보우 테이블이라는게 생기고, 해커가 암호화된 데이터를 유추할 수 있게 되었습니다.

### **레인보우테이블이란 ?**

해시 함수의 모든 입력값에 대한 결과값을 표로 정리한 것 입니다.

**사용방법**

1. 해커는 정보를 탈취하기 위해, 해시 함수에 0 ~ 최대값을 전부 넣어 결과값을 구하고, 표(레인보우 테이블)에 정리한다.
2. 레인보우 테이블을 이용하여 입력값과 결과값을 비교해가면서 암호를 찾는다.

### **레인보우 테이블에 대비하는 방법**

레인보우 테이블에 대비하는 방법은 의외로 간단하다. 개발자만 알고있는 정보( **salt** 라고 함 ) 를 입력값에 더해준 뒤

SHA-256 알고리즘을 적용하면 된다.

**SALT 란?**

암호학에서솔트(salt)는 데이터, 비밀번호, 통과암호를 해시 처리하는 단방향 함수의 추가 입력으로 사용되는 랜덤 데이터 이다.

ex)   salt = "ABC",   비밀번호 = "ABCD"

salt + 비밀번호  =  "ABCABCD", 이를 암호화하면 전혀다른 해시값이 얻어진다.

### 정리표

알고리즘 해시값 크기 내부 상태 크기 블록 크기 길이 한계 워드 크기 과정 수 사용되는 연산 충돌

| SHA-0 | 160 | 160 | 512 | 64 | 32 | 80 | +,and,or,xor,rotl | 발견됨 |
|---|---|---|---|---|---|---|---|---|
| SHA-1 | 160 | 160 | 512 | 64 | 32 | 80 | +,and,or,xor,rotl | 발견됨 |
| SHA-256/224 | 256/224 | 256 | 512 | 64 | 32 | 64 | +,and,or,xor,shr,rotr | - |
| SHA-512/384 | 512/384 | 512 | 1024 | 128 | 64 | 80 | +,and,or,xor,shr,rotr | - |

## 해결법 - BCrypt SCrypt, Argon2

나는 안전한 패스워드 보안이 목적을 가지고 있기 때문에 어떤 암호화 알고리즘을 사용해야 안전한지 알아보자

## 단방향 해시 함수의 문제점

대부분의 웹 사이트에서는 SHA-256과 같은 해시 함수를 사용해 패스워드를 암호화해 저장하고 값을 비교하는 것만으로 충분한 암호화 메커니즘을 적용했다고 생각하지만, 실제로는 다음과 같은 두 가지 문제점이 있다.

### **인식 가능성(recognizability)**

동일한 메시지가 언제나 동일한 다이제스트를 갖는다면, 공격자가 전처리(pre-computing)된 다이제스트를 가능한 한 많이 확보한 다음 이를 탈취한 다이제스트와 비교해 원본 메시지를 찾아내거나 동일한 효과의 메시지를 찾을 수 있다. 이와 같은 다이제스트 목록을 레인보우 테이블(rainbow table)이라 하고, 이와 같은 공격 방식을 레인보우 공격(rainbow attack)이라 한다. 게다가 다른 사용자의 패스워드가 같으면 다이제스트도 같으므로 한꺼번에 모두 정보가 탈취될 수 있다.

### **속도(speed)**

해시 함수는 암호학에서 널리 사용되지만 원래 패스워드를 저장하기 위해서 설계된 것이 아니라 짧은 시간에 데이터를 검색하기 위해 설계된 것이다. 바로 여기에서 문제가 발생한다. 해시 함수의 빠른 처리 속도로 인해 공격자는 매우 빠른 속도로 임의의 문자열의 다이제스트와 해킹할 대상의 다이제스트를 비교할 수 있다(MD5를 사용한 경우 일반적인 장비를 이용하여 1초당 56억 개의 다이제스트를 대입할 수 있다).

이런 방식으로 패스워드를 추측하면 패스워드가 충분히 길거나 복잡하지 않은 경우에는 그리 긴 시간이 걸리지 않는다. 그리고 대부분 사용자의 패스워드는 길거나 복잡하지 않을 뿐 아니라, 동일한 패스워드를 사용하는 경우도 많다.

반면 사용자는 웹 사이트에서 패스워드를 인증하는 데 걸리는 시간에는 그리 민감하지 않다. 사용자가 로그인하기 위해 아이디와 패스워드를 입력하고 확인 버튼을 누르는 과정에 10초가 걸린다고 가정했을 때, 다이제스트를 생성하는 데 0.1초 대신 1초가 소요된다고 해서 크게 신경 쓰는 사람은 많지 않다. 즉, 해시 함수의 빠른 처리 속도는 사용자들보다 공격자들에게 더 큰 편의성을 제공하게 된다.

## 단방향 해시 함수 보완하기

### **솔팅(salting)**

솔트(salt)는 단방향 해시 함수에서 다이제스트를 생성할 때 추가되는 바이트 단위의 임의의 문자열이다. 그리고 이 원본 메시지에 문자열을 추가하여 다이제스를 생성하는 것을 솔팅(salting)이라 한다.

### **키 스트레칭(Key Stretching)**

단방향 해시값을 계산 한 후 그 해시값을 해시하고 또 이를 반복하는 방식이다. 최근에는 일반적인 장비로 1초에 50억 개 이상의 해시값을 비교할 수 있지만, 키 스트레칭을 적용하여 동일한 장비에서 1초에 5번 가량 비교할 수 있다. GPU(Graphics Processing Unit)를 사용하더라도 수백에서 수천 번 정도만 비교할 수 있다.

## **Bcrypt 란?**

BCrypt는 브루스 슈나이어가 설계한 키(key) 방식의 대칭형 블록 암호에 기반을 둔 암호화 해시 함수다. Niels Provos 와 David Mazières가 설계했다. Bcrypt는 **레인보우 테이블 공격을 방지하기 위해 솔팅과 키 스트레칭을 적용**한 대표적인 예다.

### **scrypt**

scrypt는 PBKDF2와 유사한 adaptive key derivation function이며 Colin Percival이 2012년 9월 17일 설계했다. scrypt는 다이제스트를 생성할 때 메모리 오버헤드를 갖도록 설계되어, 억지 기법 공격(brute-force attack)을 시도할 때 병렬화 처리가 매우 어렵다. 따라서 PBKDF2보다 안전하다고 평가되며 미래에 bcrypt에 비해 더 경쟁력이 있다고 여겨진다. scrypt는 보안에 아주 민감한 사용자들을 위한 백업 솔루션을 제공하는 Tarsnap에서도 사용하고 있다. 또한 scrypt는 여러 프로그래밍 언어의 라이브러리로 제공받을 수 있다.

scrypt의 파라미터는 다음과 같은 6개 파라미터다.

DIGEST = scrypt(Password, Salt, N, r, p, DLen)

- Password: 패스워드
- Salt: 암호학 솔트
- N: CPU 비용
- r: 메모리 비용
- p: 병렬화(parallelization)
- DLen: 원하는 다이제스트 길이

### crypto

Spring Security crypto -[https://mvnrepository.com/artifact/org.springframework.security/spring-security-crypto/6.3.1](https://mvnrepository.com/artifact/org.springframework.security/spring-security-crypto/6.3.1)

[https://docs.spring.io/spring-security/reference/features/integrations/cryptography.html](https://docs.spring.io/spring-security/reference/features/integrations/cryptography.html)

[https://docs.spring.io/spring-security/site/docs/current/api/org/springframework/security/crypto/scrypt/SCryptPasswordEncoder.html](https://docs.spring.io/spring-security/site/docs/current/api/org/springframework/security/crypto/scrypt/SCryptPasswordEncoder.html)

build.gradle

```
implementation 'org.springframework.security:spring-security-crypto' //spring security crypto 라이브러리
implementation 'org.bouncycastle:bcprov-jdk15on:1.70' //암호화 알고리즘을 사용에 필요한 dependencies

```

사용법

```
SCryptPasswordEncoder encoder = new SCryptPasswordEncoder(
	 16,
   8,
   1,
   32,
   64);
   
String encryptedPassword = encoder.encode(signup.getPassword());

```

### argon2

- 최신 암호화 함수 중 하나로, 비밀번호 해시화에 사용되는 알고리즘입니다.
- 메모리 집약적이며, CPU 및 메모리 사용량을 조정할 수 있어 공격자에 대한 저항력을 높일 수 있습니다.
- 솔트와 함께 사용하여 보안성을 강화합니다.
- 시간 및 메모리 요구 사항을 조정하여 알고리즘의 복잡성을 설정할 수 있습니다.
- 현재까지 알려진 공격에 대해 강력한 보안성을 제공합니다.