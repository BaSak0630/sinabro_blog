---
title: "JAVA SWING GUI (With JDBC) 로그인 예제 프로그램 -2.JDBC 연결"
date: "2023. 7. 22. 16:27"
category: "JAVA"
url: "https://basakreview.tistory.com/47"
---
전에 글 이후로 JDBC연결에 대해서 이야기 할 것이다.  1.로그인 기능을 보지 않았다면 보고 것을 추천한다.

로그인 기능을 설명하기 전에 JDBC연결하는 것을 먼저 이야기했어야 하는 것이 아닌가 라는 생각을 해서 2편으로 JDBC를 이야기를 하기로 했다.

[2023.07.19 - [포트폴리오] - JAVA SWING GUI (With JDBC) 로그인 예제 프로그램 - 1. 로그인](https://basakreview.tistory.com/46)

[
 

JAVA SWING GUI (With JDBC) 로그인 예제 프로그램 - 1. 로그인

이번에 공부한 것들을 이용해서 간단한 로그인 예제 프로그램의 제작 과정과 생각들을 이야기 해볼 생각이다. 저는 현재 JAVA spring 을 공부시작 했는데 그전에 공부하던 것들을 이용해 무엇인가

basakreview.tistory.com

](https://basakreview.tistory.com/46)

일단 JDBC가 무엇인를 설명하고 이야기를 진행해야한다. JDBC는 간단하게 통역가라고 생각해주면 좋을 것 같다. 응용프로그램과 DBMS가 서로가 인자와 리턴값을 주고 받는 것을 가능하게 만들어준다.

![](https://blog.kakaocdn.net/dna/S2WY4/btsoz8Nt6ML/AAAAAAAAAAAAAAAAAAAAAIzWwgYtcRJq5BtKNsA3di3qk6gL6SQJJmtjO_2Yi50-/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=CGPGQqWHbpK%2BAA4SlxnRdGA9Fw0%3D)

간단히 설명하면 먼저 응용프로그램에서 원하는 리턴값을 받을 수 있는 SQL질의를 JDBC를 이용해 DBMS에 접근해 원하는 값을 리턴받아 응용프로그램에서 받은 리턴 값을 활용할 수 있는 형태로 사용한다. 1.로그인 글에서 했던 것 처럼 userid를 이용해 동일한 데이터를 찾아 userpw을 알아내고 현재 가지고 있는 값과 비교하는 등의 행위를 해줄 수 있다.

위에 JDBC를 이용하기 위해서 가장 먼저 준비해야 하는 내용은 Oracle DB와 응용프로그램이 준비되어야 한다. 먼저 user정보를 관리하는 테이블을 만들어야 한다.

![](https://blog.kakaocdn.net/dna/YFtnV/btsoyrzW972/AAAAAAAAAAAAAAAAAAAAAKBVY0VJipMUNp41IiUISN7Kq6FEdIMahnQRKlFc7lgw/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=P99XFqAMSpaTBeX4bVZGJpKsSCA%3D)

![](https://blog.kakaocdn.net/dna/bi7K8B/btsozR5Xl5e/AAAAAAAAAAAAAAAAAAAAADAE5_zYqyPCVY5uqxRvT9sE7cDTsH22tpoewipmNMdm/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=NIyFQVluT1gtYeOlfAqm6D%2BU7Oc%3D)

그리고 설명해야하는 용어가 있다. 그것은 바로 DAO(Data Access Object)의 약자로, 데이터베이스의 데이터에 접근하기 위해 생성하는 객체이다.  처음 연결한 방식을 코드로 먼저 보고 설명하는 것이 좋은것 같다.

```
import javax.swing.*;
import java.sql.*;

public class UserDAO {
    String url = "jdbc:oracle:thin:@localhost:1521:XE";
    String user = "admin";
    String pw = "admin";
    Connection conn = null;
    Statement stmt = null;
    ResultSet logInResult = null;

    boolean logincheck(String _i, String _p) {
        boolean flag = false;
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            // connection으로 db와 연결 (객체 생성)
            conn = DriverManager.getConnection(url, user, pw);
            System.out.println(conn.isClosed()?"접속종료":"접속중");
            stmt = conn.createStatement();
            System.out.println("접속 완료");
        } catch (ClassNotFoundException cnfe) {
            System.out.println("DB 드라이버 로딩 실패 :" + cnfe.toString());
        } catch (SQLException sqle) {
            System.out.println("DB 접속실패 : " + sqle.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
        String id = _i;
        String pw = _p;
        String dbpw;

        try {
            System.out.println("로그인 시도 중");
            //String checkingStr = "INSERT INTO USERINFO values (0000000003,'userid3','userpw3','userid@gmail.com','이시현')";
            String checkingStr = "SELECT USERPW FROM USERINFO WHERE USERID='" +id+ "'";
            logInResult = stmt.executeQuery(checkingStr);
            System.out.println("DB 접속중");
            while(logInResult.next()) {
                System.out.println("result.next 테스트 ");
                dbpw = logInResult.getString("USERPW");
                if(pw.equals(dbpw)){
                    flag = true;
                    System.out.println("로그인 성공");
                }
            }
        } catch(Exception e) {
            flag = false;
            System.out.println("로그인 실패 >>> " + e.toString());
        }finally {
            dbClose();
        }
        return flag;
    }
    public void dbClose() {
        try {
            if (logInResult != null)
                logInResult.close();
            if (stmt != null)
                stmt.close();
            if (conn != null)
                conn.close();
        } catch (Exception e) {
            System.out.println(e + "=> dbClose fail");
        }
    }
}
```

위코드에서 중요하는 부분은 아래 코드 부분이다.

```
Class.forName("oracle.jdbc.driver.OracleDriver");
// connection으로 db와 연결 (객체 생성)
conn = DriverManager.getConnection(url, user, pw);

System.out.println(conn.isClosed()?"접속종료":"접속중");

stmt = conn.createStatement();
```

"Class.forName("oracle.jdbc.driver.OracleDriver");" 는 JDBC interface로 JDBC Driver를 로드하는 역활을 한다.

Connection conn은 url과 DBMS의 아이디 비번을 인자로 DriverManager에게 넘겨서 Connection객체로 리턴 받는다. conn을 통해 연결 정보들을 얻을 수 있게 된다.

```
 try {
            System.out.println("로그인 시도 중");
            //String checkingStr = "INSERT INTO USERINFO values (0000000003,'userid3','userpw3','userid@gmail.com','이시현')";
            String checkingStr = "SELECT USERPW FROM USERINFO WHERE USERID='" +id+ "'";
            logInResult = stmt.executeQuery(checkingStr);
            System.out.println("DB 접속중");
            while(logInResult.next()) {
                System.out.println("result.next 테스트 ");
                dbpw = logInResult.getString("USERPW");
                if(pw.equals(dbpw)){
                    flag = true;
                    System.out.println("로그인 성공");
                }
            }
```

1.로그인 글에서 동일한 기능으로 checkingStr에 SQL문을 받아서 Statement를 이용해 ResultSet으로 받아 while문을 돌면서 ResultSet의 값을 하나씩 입력한 값을 비교해 결과를 flag변수에 담아 리턴한다. Statement(java.sql.Statement)는 Connection으로 연결한 객체에게  Query 작업을 실행하기 위한 객체로 Connection객체의 createStatement함수로 할당해 준다. 여기서 ResultSet는 한 행을 단위로 값을 확인할 수 있다.

그런데 위에 전체 코드의 문제점을 발견해 코드를 수정해 지금의 버전으로 만들게 되었다. 그 문제는 DBMS와 질의를 주고받을 때마다 계속 새롭게 연결해주는 점과 다른 기능을 추가해 여러 질의를 주고받을 때 문제가 발생한다는 점을 인지하고 연결하는 커넥터를 따로 만들어주고 여러번 질의를 주고 받다러도 연결을 한번만 해주는 행태를 생각하게 되었다. 그 내용은 다음 글에서 추가적으로 설명하겟다.

---

## 📷 이미지 목록

- 이미지 1: https://blog.kakaocdn.net/dna/S2WY4/btsoz8Nt6ML/AAAAAAAAAAAAAAAAAAAAAIzWwgYtcRJq5BtKNsA3di3qk6gL6SQJJmtjO_2Yi50-/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=CGPGQqWHbpK%2BAA4SlxnRdGA9Fw0%3D
- 이미지 2: https://blog.kakaocdn.net/dna/YFtnV/btsoyrzW972/AAAAAAAAAAAAAAAAAAAAAKBVY0VJipMUNp41IiUISN7Kq6FEdIMahnQRKlFc7lgw/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=P99XFqAMSpaTBeX4bVZGJpKsSCA%3D
- 이미지 3: https://blog.kakaocdn.net/dna/bi7K8B/btsozR5Xl5e/AAAAAAAAAAAAAAAAAAAAADAE5_zYqyPCVY5uqxRvT9sE7cDTsH22tpoewipmNMdm/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=NIyFQVluT1gtYeOlfAqm6D%2BU7Oc%3D