---
title: "JAVA SWING GUI (With JDBC) 로그인 예제 프로그램 - 1. 로그인"
date: "2023. 7. 19. 15:30"
category: "JAVA"
url: "https://basakreview.tistory.com/46"
---
이번에 공부한 것들을 이용해서 간단한 로그인 예제 프로그램의 제작 과정과 생각들을 이야기 해볼 생각이다. 저는 현재 JAVA spring 을 공부시작 했는데 그전에 공부하던 것들을 이용해 무엇인가를 만들어 보고 싶다고 생각해 제작하게 되었다.

본프로그램의 구성은 다음과 같다

![](https://blog.kakaocdn.net/dna/bkW05y/btsobIIxMkn/AAAAAAAAAAAAAAAAAAAAAFDdYPGGBaa5Sv7JU2NZpr0JDYuwyRJJCfyK8uCU5YuV/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=5bj1%2B%2BeQjgmIBHX7yCGXw6Sjibw%3D)

```
public class BaSaKPortfolio {
    public static void main(String[] args) {
        LoginDialog loginDialog = new LoginDialog();
        loginDialog.setVisible(true);
    }
}
```

먼저 프로그램이 실행되면 로그인 다이얼로그를 뛰운다. 아이디와 비밀번호를 입력 후 로그인 버튼을 누르면 testfild에 내용을 가지 JDBC을 이용해 검증하는 방식으로 작동한 하게 된다

다음은 로그인 다이얼로그의 판넬이다.

```
import javax.swing.*;
import java.awt.*;

public class LoginPanel extends SubPanel {
    private JLabel idLabel = new JLabel("아이디 ");
    private JLabel pwLabel = new JLabel("비밀번호 ");
    private JTextField idText = new JTextField();
    private JPasswordField pwText = new JPasswordField();
    private JButton loginBtn = new JButton("로그인");
    private JButton idpwSearchBtn = new JButton("아이디/비밀번호 찾기");
    private JButton singUp = new JButton("회원가입");
    private UserDAO _DAO;
    LoginPanel(LoginDialog loginDialog){
        _DAO = new UserDAO();
        this.setVisible(true);
        this.setLayout(null);

        idLabel.setSize(80,30);
        idLabel.setLocation(55,170);
        idLabel.setHorizontalAlignment(JLabel.CENTER);
        this.add(idLabel); //JFrame에 JLabel를 추가

        idText.setSize(130,30);
        idText.setLocation(120,170);
        this.add(idText);//JFrame에 JTextField를 추가

        pwLabel.setSize(80,30);
        pwLabel.setLocation(65,200);
        this.add(pwLabel);

        pwText.setSize(130,30);
        pwText.setLocation(120,200);
        this.add(pwText);

        idpwSearchBtn.setForeground(Color.WHITE);
        idpwSearchBtn.setBackground(Color.BLACK);
        idpwSearchBtn.setSize(200,40);
        idpwSearchBtn.setLocation(60,350);
        this.add(idpwSearchBtn);

        loginBtn.setForeground(Color.WHITE);
        loginBtn.setBackground(Color.BLACK);
        loginBtn.setSize(200,40);
        loginBtn.setLocation(60,250);
        this.add(loginBtn);

        singUp.setForeground(Color.WHITE);
        singUp.setBackground(Color.BLACK);
        singUp.setSize(200,40);
        singUp.setLocation(60,400);
        this.add(singUp);

        loginBtn.addActionListener(event ->{
            System.out.println("로그인 시도");
            String id = idText.getText().trim();
            String pw = pwText.getText().trim();

            if (id.isEmpty()) {
                JOptionPane.showMessageDialog(null, "아이디를 입력해주세요", "로그인 확인!",
                        JOptionPane.PLAIN_MESSAGE);

            } else if (pw.isEmpty()) {
                JOptionPane.showMessageDialog(null, "비밀 번호를 입력해주세요", "로그인 확인!",
                        JOptionPane.PLAIN_MESSAGE);

            } else if(id != null && pw != null) {
                if(_DAO.logincheck(id,pw)){
                    loginDialog.dispose();
                    MainFrame mainFrame = new MainFrame();
                    mainFrame.setVisible(true);
                }else {
                    System.out.println("로그인 실패");
                    JOptionPane.showMessageDialog(null, "등록되지 않은 아이디이거나 아이디 또는 비밀번호를 잘못 입력했습니다.",
                            "로그인 확인!", JOptionPane.PLAIN_MESSAGE);
                }
            } else {
                JOptionPane.showMessageDialog(null, "등록되지 않은 아이디이거나 아이디 또는 비밀번호를 잘못 입력했습니다.",
                        "로그인 확인!", JOptionPane.PLAIN_MESSAGE);
            }
        });

        idpwSearchBtn.addActionListener(event ->{
            loginDialog.changePanel("idpwFindPanel");
        });

        singUp.addActionListener(event->{
            //회원가입 판넬로 바꿈
            loginDialog.changePanel("signUpPanel");
        });
    }
}
```

위의 코드에서 중요하는 부분은  loginBtn의 ActionListener이다.

```
loginBtn.addActionListener(event ->{
            System.out.println("로그인 시도");
            String id = idText.getText().trim();
            String pw = pwText.getText().trim();

            if (id.isEmpty()) {
                JOptionPane.showMessageDialog(null, "아이디를 입력해주세요", "로그인 확인!",
                        JOptionPane.PLAIN_MESSAGE);

            } else if (pw.isEmpty()) {
                JOptionPane.showMessageDialog(null, "비밀 번호를 입력해주세요", "로그인 확인!",
                        JOptionPane.PLAIN_MESSAGE);

            } else if(id != null && pw != null) {
                if(_DAO.logincheck(id,pw)){
                    loginDialog.dispose();
                    MainFrame mainFrame = new MainFrame();
                    mainFrame.setVisible(true);
                }else {
                    System.out.println("로그인 실패");
                    JOptionPane.showMessageDialog(null, "등록되지 않은 아이디이거나 아이디 또는 비밀번호를 잘못 입력했습니다.",
                            "로그인 확인!", JOptionPane.PLAIN_MESSAGE);
                }
            } else {
                JOptionPane.showMessageDialog(null, "등록되지 않은 아이디이거나 아이디 또는 비밀번호를 잘못 입력했습니다.",
                        "로그인 확인!", JOptionPane.PLAIN_MESSAGE);
            }
        });
```

ID와 PW가 모두 입력 된것이 확인 되면 _DAO의 logincheck함수를 실행해서 DB에 ID,PW가 존재하는지 여부를 확인한다. 다음 코드는 _DAO의 logincheck함수 이다

```
 dbConnecter dbc = new dbConnecter();
 PreparedStatement stmt = null;
 ResultSet result = null;
    
boolean logincheck(String _i, String _p) {
        boolean flag = false;

        String id = _i;
        String pw = _p;
        String dbpw;

        try {
            System.out.println("로그인 시도 중");
            String query = "SELECT USERPW FROM USERINFO WHERE USERID='" +id+ "'";
            stmt = dbc.dbConnecting(query);
            result = stmt.executeQuery(query);
            System.out.println("DB 접속중");

            while(result.next()) {
                System.out.println("result.next 테스트 ");
                dbpw = result.getString("USERPW");
                if(pw.equals(dbpw)){
                    flag = true;
                    System.out.println("로그인 성공");
                }
            }
        } catch(Exception e) {
            flag = false;
            System.out.println("로그인 실패 >>> " + e.toString());
        }finally {
            dbc.dbClose();
        }
        return flag;
    }
```

query 에 원하는 SQL문은 넣어 dbc에 넘겨주어 DB와 연결시킨다

```
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
```

"SELECT USERPW FROM USERINFO WHERE USERID = '"+id+"'" 는 USERINFO테이블에서 USERID가 id 와 동일한 것을 찾아 USERPW를 보려라 라는 의미로 찾은 USERPW를 하나 씩 pw와 비교하 같으면 flag 를 true로 반환하는 과정으로 로그인 기능을 구현하였다.

추후에 추가로 다른 기능에 대한 이야기도 기재할 예정이다.

아래의 깃허브 를 참고 하면 도움이 될 것 이다.

[https://github.com/BaSak0630/BaSak-Login](https://github.com/BaSak0630/BaSak-Login)

---

## 📷 이미지 목록

- 이미지 1: https://blog.kakaocdn.net/dna/bkW05y/btsobIIxMkn/AAAAAAAAAAAAAAAAAAAAAFDdYPGGBaa5Sv7JU2NZpr0JDYuwyRJJCfyK8uCU5YuV/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=5bj1%2B%2BeQjgmIBHX7yCGXw6Sjibw%3D