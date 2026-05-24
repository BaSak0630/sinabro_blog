---
title: "JWT -JSON Web Tokens"
date: "2024. 6. 19. 21:51"
category: "JAVA"
url: "https://basakreview.tistory.com/57"
---
인증 관련 공부를 하던중 JWT 공부의 필요성을 느끼고 찾아보았다.

JWS 란?

[더보기]()

JOSE (JSON Object Signining and Encryption) 의 아래에 있는 스펙 중 하나로 OAuth 의 근간이 된 기술이라고 한다.

아래는 JOSE 에 속한 기술들. 이 외에도 좀 더 있다고 합니다.

JWT (JSON Web Token) : JWS or JWE

JWS (JSON Web Signature) : 서버에서 인증을 증거로 인증 정보를 서버의 private key 로 서명한 것을 Token 화 한것.

JWE (JSON Web Encryption) : 서버와 클라이언트 간 암호화된 데이터를 Token 화 한것.

JWK (JSON Web Key) : JWE 에서 payload encryption 에 쓰인 키를 token 화 한것. (물론, 키 자체도 암호화되어 있죠.)

아래는 jws이다.

eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJKb2UifQ.8YGGUiu_kzUILU13WGw3uHpAhFYbRQO1zIQCXosA9Y4

Base64(header) = eyJhbGciOiJIUzI1NiJ9 (암호화 알고리즘 종류)

Base64(payload) = eyJzdWIiOiJKb2UifQ (sebject string에 대한 레지스터 페이로드)

Base64(signature) = 8YGGUiu_kzUILU13WGw3uHpAhFYbRQO1zIQCXosA9Y4 (시그니쳐 서명)

이렇게 3개의 부분으로 구성되어있다

2024년 4월기준으로 바뀐점들이 존재합니다.

```
public class JwtUtils {
    private static final String SECRET_KEY = "4261656A64756F67";

    private SecretKey getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(this.SECRET_KEY);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    // JWT 생성
    public String generateToken(Authentication authentication) {
        // 인증 정보에서 사용자 이름 추출
        String username = ((UserDetails) authentication.getPrincipal()).getUsername();

        return Jwts.builder()
                .subject(username)
                .issuedAt(new Date())
                .expiration(new Date((new Date()).getTime() + 3600000))
                .signWith(this.getSigningKey())
                .compact();
    }

    private Claims extractAllClaims(String token){
        return Jwts.parser()
                .verifyWith(this.getSigningKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }
}

```

문자열 혹은 바이트를 인수로 받는 signWith 메서드가 Deprecated 되었습니다.

특 정 문자열이나 byte를 인수로 받는 메서드는 사용중단되었다고 합니다.

이유는 많은 사용자가 원시적인 암호 문자열(안전하지 않은)을키 인수로 사용하려고 시도하며 혼란스러워 했기 때문이라고 합니다.

```
 Claims claims = Jwts.parser()
                .setSigningKey("abcd")
                .parseClaimsJws(token)
                .getBody();
                
                ->
                
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody();         

```

**Jwts의 parser메서드도 deprecated 되었으니 parserBuilder메서드를 사용해야한다고 합니다.**

**참고로  Base64란 Binary Data를 Text로 바꾸는 Encoding([binary-to-text encoding](http://en.wikipedia.org/wiki/Binary-to-text_encoding) schemes)의 하나로써 Binary Data를 Character set에 영향을 받지 않는 공통 ASCII 영역의 문자로만 이루어진 문자열로 바꾸는 Encoding이다.**

Base64를 글자 그대로 직역하면 64진법이라는 뜻이다. 64진법은 컴퓨터한테 특별한데 그 이유는 64가 2의 제곱수 64=2^6이며 2의 제곱수에 기반한 진법 중 화면에 표시되는 ASCII 문자들로 표시할 수 있는 가장 큰 진법이기 때문이다. (ASCII에는 제어문자가 다수 포함되어 있기 때문에 화면에 표시되는 ASCII 문자는 128개가 되지 않는다.)

핵심은 **Base64 Encoding은 Binary Data를 Text로 변경하는 Encoding이다.**

변경하는 방식을 간략하게 설명하면 Binary Data를 6 bit 씩 자른 뒤 6 bit에 해당하는 문자를 아래 Base64 색인표에서 찾아 치환한다. (실제로는 Padding을 더해주는 과정이 추가된다.)