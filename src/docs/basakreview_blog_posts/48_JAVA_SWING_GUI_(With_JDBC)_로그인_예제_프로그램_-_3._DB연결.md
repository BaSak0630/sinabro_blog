---
title: "JAVA SWING GUI (With JDBC) 로그인 예제 프로그램 - 3. DB연결"
date: "2023. 7. 24. 18:52"
category: "알고리즘"
url: "https://basakreview.tistory.com/48"
---
이 글에서는 제가 JAVA 응용프로그램에 DB를 연결하는 과정에 대해서 이야기 해볼생각이다. 본 글의 저자는 아직 배우고 있는 단계이기 때문에 문제가 있거나 더욱 좋은 방식이 존재한다면 댓글로 이야기 해주시면 공부에 더욱 도움이 될 것이라 기대된다. 본 글을 보기 이전에 전의 글들을 보는 것을 추천한다.

[2023.07.22 - [포트폴리오] - JAVA SWING GUI (With JDBC) 로그인 예제 프로그램 -2.JDBC 연결](https://basakreview.tistory.com/47)

[
 

JAVA SWING GUI (With JDBC) 로그인 예제 프로그램 -2.JDBC 연결

전에 글 이후로 JDBC연결에 대해서 이야기 할 것이다. 1.로그인 기능을 보지 않았다면 보고 것을 추천한다. 로그인 기능을 설명하기 전에 JDBC연결하는 것을 먼저 이야기했어야 하는 것이 아닌가

basakreview.tistory.com

](https://basakreview.tistory.com/47)

전에 글에서 언급했듯 DB를 연결하는 과정에서 문제를 해결하기 위해 DB를 연결하는 객체와 DAO 를 각각의 객체로 관리하는 방식을 선택하게 되었습니다. 우선 코드 보면서 설명할 예정이다.

```
import java.sql.*;

public class dbConnecter {
    String url = "jdbc:oracle:thin:@localhost:1521:XE";
    String user = "admin";
    String pw = "admin";
    Connection conn = null;
    PreparedStatement stmt = null;
    dbConnecter(){

    }
    public PreparedStatement dbConnecting(String sql){
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            // connection으로 db와 연결 (객체 생성)
            conn = DriverManager.getConnection(url, user, pw);
            System.out.println(conn.isClosed()?"접속종료":"접속중");
            stmt = conn.prepareStatement(sql);
            System.out.println("접속 완료");
        } catch (ClassNotFoundException cnfe) {
            System.out.println("DB 드라이버 로딩 실패 :" + cnfe);
        } catch (SQLException sqle) {
            System.out.println("DB 접속실패 : " + sqle);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stmt;
    }
    public PreparedStatement dbConnecting(String sql,String userID,String userPW,String userEmail,String userName){
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            // connection으로 db와 연결 (객체 생성)
            conn = DriverManager.getConnection(url, user, pw);
            System.out.println(conn.isClosed()?"접속종료":"접속중");
            stmt = conn.prepareStatement(sql);
            stmt.setString(1,userID);
            stmt.setString(2,userPW);
            stmt.setString(3,userEmail);
            stmt.setString(4,userName);

            System.out.println("접속 완료");
        } catch (ClassNotFoundException cnfe) {
            System.out.println("DB 드라이버 로딩 실패 :" + cnfe);
        } catch (SQLException sqle) {
            System.out.println("DB 접속실패 : " + sqle);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stmt;
    }
    public void dbClose() {
        try {
            if (stmt != null)
                stmt.close();
        } catch (Exception e) {
            System.out.println(e + "=> dbClose fail");
        }
    }
}
```

기존에 userDAO에서 DB연결을 따로 분리해서 DB Connecter를 만들어 DB와 연결하고 Statement를 리턴하는 객체이다.

전 글에서 논리적으로는 같은 내용이다. DB interface로 DB Driver를 로드하는 것은 동일하다.

전 글에서는 그냥 Statement를 사용했는데 지금은 PreparedStatement를 사용했는데 이 둘의 차이는 설명하면

| Statement 클래스- SQL 구문을 실행하는 역할- 스스로는 SQL 구문 이해 못 함(구문해석 X) -> 전달 역할- SQL 관리 O + 연결 정보 X | PreparedStatement 클래스- Statement 클래스의 기능 향상- 인자와 관련된 작업이 특화(매개변수)- 코드 안정성 높음. 가독성 높음.- 코드량이 증가 -> 매개변수를 set해줘야하기 때문- 텍스트 SQL 호출 |
|---|---|

간단히 말해 안정적으로 사용하기 위해서 Statement를 보완해서 만들어 낸 클래스이다.  본 저자 또한 이 사실을 코딩 도중에 인지하게 되어 코드를 수정하게 되었다.  그래서 DAO 에서 DB에 엑세스할 때 처음에 연결하고 기능수행 후 리턴하기전 DB를 연결을 해제하고 값을 리터 하는 방식으로 사용한다.

<회원가입 기능>

```
void signup(String ID,String PW,String email, String name){
        String userID = ID;
        String userPW = PW;
        String userEmail = email;
        String userName = name;

        try {
            System.out.println("아이디 중복 확인 중");
            String query = "INSERT INTO USERINFO (USERNO,USERID,USERPW,USEREMAIL,USERNAME) values (USER_SEQ.NEXTVAL,?,?,?,?)";
            stmt = dbc.dbConnecting(query,userID,userPW,userEmail,userName);
            result = stmt.executeQuery();
            /*String query ="INSERT INTO USERINFO values (USER_SEQ.NEXTVAL,'"+userID+"','"+userPW+"','"+userEmail+"','"+userName+"')";
            stmt = dbc.dbConnecting(query);
            result = stmt.executeQuery(query);*/
        } catch(Exception e) {
            System.out.println("유저 삽입 실패 >>> " + e.toString());
            JOptionPane.showMessageDialog(null, "회원가입의 실패하였습니다.\n 다시 한번 확인해주세요",
                    "회원가입", JOptionPane.PLAIN_MESSAGE);
        } finally {
            dbc.dbClose();
        }
    }
```

<아이디 중복확인>

```
boolean idDUniqueCheck(String _i) {
        boolean idFlag = false;
        String id = _i;
        String dbid;

        try {
            System.out.println("아이디 중복 확인 중");
            String query = "SELECT USERID FROM USERINFO WHERE USERID ='"+id+"'";
            stmt = dbc.dbConnecting(query);
            result = stmt.executeQuery(query);
            System.out.println("DB 접속중");
            while(result.next()) {
                dbid = result.getString("USERID");
                if(dbid.equals(id)){
                    idFlag = true;
                    System.out.println("중복");
                    return idFlag;
                }
            }
        } catch(Exception e) {
            System.out.println("중복확인 실패 >>> " + e.toString());
        } finally {
            dbc.dbClose();
        }
        return idFlag;
    }
```

회원가입의 경우 SQL문 INSERT문을 위해 커넥팅 할때 삽입할 인자를 넘겨주는 방식으로 작동한다.

ExecuteQuery 는 1. 수행결과로 ResultSet 객체의 값을 반환합니다. 2. SELECT 구문을 수행할 때 사용되는 함수입니다.

executeQuery 함수를 사용하는 방법입니다.