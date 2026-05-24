SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Categories
INSERT IGNORE INTO category (name) VALUES ('Dailelog');
INSERT IGNORE INTO category (name) VALUES ('JAVA');
INSERT IGNORE INTO category (name) VALUES ('JAVA/JAVA SPRING');
INSERT IGNORE INTO category (name) VALUES ('디자인패턴');
INSERT IGNORE INTO category (name) VALUES ('알고리즘');
INSERT IGNORE INTO category (name) VALUES ('언어/CPP');
INSERT IGNORE INTO category (name) VALUES ('언어/CS');
INSERT IGNORE INTO category (name) VALUES ('언어/C언어');
INSERT IGNORE INTO category (name) VALUES ('언어/심심풀이');
INSERT IGNORE INTO category (name) VALUES ('일기');
INSERT IGNORE INTO category (name) VALUES ('카테고리 없음');
INSERT IGNORE INTO category (name) VALUES ('활동');

-- Posts
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('C_string_strcmp', '| #include #include int my_strcmp(char *s,char *t){     int i = 0;     while(s[i] == t[i])     {          if(s[i++] ==  ''\0'')// 이 if문의 목적은 두 문자열이 같을 때 0을 반환한다.          {             return (0);          }              i++;     }     return(s[i] - t[i]);}main(){     char *p = "kwon";     char *q = "Kim";     int cmp;     cmp =my_strcmp(p,q);      //cmp = strcmp(p,q); //함수가 여러번 수행되는 것을 막기 위해 strcmp의 값을 저장해서 사용한다고 함     if (cmp == 0/*"Kwon" > "Kim"*/) //문자열을 비교할때 부등호만 사용했을때 단순히 주솟값만 비교하게 된다.     {         printf("same\n");     }     else if (cmp > 0 )     {         printf("%s\n",p);     }          else     {         printf("%s\n",q);     }} |
|---|

strcmp함수는 두 문자열을 비교하는 함수이다. 단순히 문자열을 부등호로 비교했을 때 문자열의 크기비교가 아닌 주솟값을 비교 하게 되기 때문에 문자열의 크기 비교해준다. 두 문자열의 아스키 코드 값을 비교해 두 문자열을 뺼셈 했을때 양수면 뒤에 문자열이 작고 음수이면 앞에 문자열이 작은 것이다.', '2022-04-27 16:50:00', 0, 1, (SELECT id FROM category WHERE name='언어/C언어' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('C_dynamic allocation', '| #include #include main(){     int *p;     //int p[3]; //원래는 이렇게 자동할당으로 배열을 만들어 주어야 하는데 만들어주지      // 않고 동적할당으로 heap영역에 만들게 됨     int i;     p = (int *) malloc(3*sizeof(int));//12byte를 할당해서 저장 장소 3개를 만드는 행위     //동적할당은 사용하는 이유는 배열에서 공간을 예상해서 선언해주는데 그 공간이 정해지지 않을때     //그리고 오버플로우를 방지하기 위해서     //int p[n]; 배열의 크기는 변수로 못함 그래서 sizeof앞에 수를 변수로 처리하면 오버플로우 없이      //저장공간을 그때그때 할당할수 있다.     p[0] = 13;     p[1] = 72;     p[2] = 81;     for(i = 0; i < 3; i++)     {         printf("p[%d] = %d \n",i,p[i]);     }/*p = (int *)malloc(sizeof(int));//malloc(4); //(int *) 을 타입캐스팅이라고 함 기본적으로 malloc()함수는 void type를 리턴함 //heap영역의 운영체제가 사용하지 않는 무작위 장소를 4byte의 공간에 malloc()가 주소값을 가지고옴*p = 25;printf("%d\n",*p);*/} |
|---|

동적할당 Dynamic allocation 
: 프로그래머의 지시에 의해서 "생겨라" 라고 하면 기억장소가 생기고
"없어져라"라고 하면 기억장소가 없어지는 방식으로 할당되는 방식이다.

heap영역에 할당되는데 원래 heap영역의 주인은 OS이다. 
malloc(int) 함수,free() 함수를 이용해서  할당과 해제를 한다.  이때 해제 해주지 않으면 우리 눈에 보이지

않기 때문에 계속 해서 남아있어 공간만 차지해서 시스템이 죽을 수 있다. 
특징으로는 동적할당된 기억장소는 변수명을 지을 수가 없기 떄문에 포인터의 사용이 필수적이며 
반드시 기억해야 하는것은 포인터의 사용목적 중
(3) 동적 할당
(4) 관계를 나타내는 정보처리(자료구조)

이다. 

주의 사항으로는 
1. garbage 포인터 위치 값을 잃어 나와 모든 프로그램이 사용못하는 기억장소가 생김
시스템의 영향을 줌 free()를 안하면 문제가 발생함
2.dangling reference 허상참조 free()를 해서 저장장소를 돌려줬는데 포인터롤 가르키면
오류가 발생한다.
3. garbage collection = garbage가 안생기도록하는 조치(free())', '2022-05-03 17:58:00', 0, 1, (SELECT id FROM category WHERE name='언어/C언어' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('C_2차원 배열 Dynamic alloction', '| #include #include //#define _CRT_SECURE_NO_WARNINGSint getSum(int **x,int row,int col){     int s = 0;     int i,j;     for(i = 0; i < row;i++)     {         for(j = 0; j          {              s = s + x[i][j];          }     }     return s;}int** mallocArray(int m,int n){    int **p;     int i;     p = (int**)malloc(m*sizeof(int*));//3행 4열의 2차원배열의 동적할당     for(i = 0; i < m; i++)     {          p[i] = (int*)malloc(n*sizeof(int)/*int 4개 짜리 배열*/);     }     return p;}main(){     int **p;     int i,j;     int sum;     p = mallocArray(3,4);     //아래의 2중 루프문에서 i < 4로해서 다른 부분을 건드려서 디버깅이 되지 않았음     for( i = 0; i < 3; i++)     {         for(j = 0; j < 4; j++)          {             p[i][j] = i*4 +j +1;         }     }     for(i = 0; i < 3; i++)     {         for(j = 0; j < 4; j++)         {             printf_s("%4d",p[i][j]);         }           printf_s("\n");     }sum = getSum(p,3,4);printf("%d",sum);} |
|---|

/* 
2차원 배열 동적 할당  
-필요한 만큼의 기억장소 할당 
-함수 호출 시 인자 전달 편의성 
자동할당 할때는 2차원 배열을 1차원배열로 변환해서 사용한것을 안해도 됨 
-무진장 큰 배열의 할당 
-int ** double pointer 소개 
2차원 배열 동적할당할때 반드시 double pointer 사용 
- pointer array 
자료구조 사용 
-자바와 c#에서는 동적 할당만 가능  
배열사용시 무조건 동적할당 차후에는 자동할당하는 배열은 없을 것 

command line argument 
-main(int arg,har** argv) 

3*sizeof(int*)는  integer pointer 의 array int*를 3개의 저장공간을 확보 
p은 int **탑이이다.  

주의 사항 
동적 할당 2차원 배열은 저장 위치가 자동 할당처럼 바로 뒤에 오는 것이 아니라 
포인터 연산은 매우 주의 해야 한다. 임의에 주소를 사용해서 저장공간의 관계성이  
전혀 없다.  

인다이렉싱  
자동할당에 비해 동적할당의 단점은 시간이 더걸린다. 배열의 엘리먼트를 간접적으로 주소를 찾기 때문

계속 디버깅이 안되서 뭐가 문제인지 봤는데 이중루프문에서 배열에 테이터를 넣어줄때 내가 정해준 크기보다 더 많은 개수의 숫자를 넣을려해서
heap영역에 다른 주소값부분을 건드려서 디버깅이 않되더라.

*/', '2022-05-07 18:16:00', 0, 1, (SELECT id FROM category WHERE name='언어/C언어' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('Cpp 들어가기', '## **C -> Cpp iostream**

| #include <iostream>int main(){     char name[100];     char lang[200];     std::cout << "이름을 입력하세요"<< std::endl;     std::cin >> name;     std::cout << "좋아하는 프로그래밍 언어를 입력하세요" << std::endl;     std::cin >> lang;     std::cout << "내이름은 "<< name <<" 입니다"<<std::endl;     std::cout << "제가 좋아하는 프로그래밍 언어는"<< lang <<"입니다"<<std::endl;} |
|---|

cpp에서는 stdio.h를 대신해 iostream을 사용한다. cpp에서는 헤더파일의 선언에서는 확장자를 생략하기로 약속되어 있다
입출력 시 std,cout,cin 을 사용한다

## **C -> Cpp Function Overloading**

| #include <iostream>void MyFunc(){     std::cout<<"MyFunc() caled"<< std::endl;}void MyFunc(char c){     std::wcout<<"MyFunc(char c) called" <<std::endl;}void MyFunc(int a, int b){     std::wcout<<"MyFunc(int a, int b) called" <<std::endl;}int main(){     MyFunc();     MyFunc(''A'');     MyFunc(12,13);     return 0;} |
|---|

Cpp의 함수 오버로딩
C에서는 동일한 이름의 복수의 함수가 존재하지 못하는데 Cpp에서는
동일한 함수 명이지만 함수들이 다른 매개변수(parameter)를 가지고 있다면 이를 허용한다.
자료형또는 갯수가 달라야한다.

## **C -> Cpp Default Value**

| #include int adder(int num1 = 1, int num2 = 2);int adder(int num1, int num2)// int adder(int num = 1, int num2 =2){       return num1 + num2;}int main(){      std::cout<<adder()<<std::endl;      std::cout<<adder(5)<<std::endl;      std::cout<<asser(3,5)<<std::endl;      return 0; } |
|---|

함수의 원형을 별도로 선언하는 경우, 매개변수의 디폴트 값은 함수의 원형 선언에만 위치시켜야 한다.
위 코드처럼 함수 선언시 매개변수의 미리 값을 고정시켜서 함수 호출 시 인자가 전달하지 않으면
미리 선언해준 디폴트 값이 적용된다.
여기서 주의해야 할 것은
int YourFunc(int num1 = 10, int num2 = 20, int num3)
은 불가능하다 그이유는 함수에 전달되는 인자가 왼쪽에서붜 오른쪽으로 채워지기 때문이다
YourFunc(,,30)이 안되기 떄문이다.', '2022-06-25 15:30:00', 0, 1, (SELECT id FROM category WHERE name='언어/CPP' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('structure', '| 구조체 (structure)서로 밀접한 연관이 있는 변수들을 모아 놓은 복합 변수 -> 나중에 "객체"라고 지칭함 |
|---|

| cf.배열*/#include <stdio.h>struct point {int x;int y;};void findCenterPoint(struct point *p,struct point q,struct point r){p->x = (q.x + r.x) / 2;p->y = (q.y + r.y) / 2;}void printPoint(char *name,struct point p){printf("%s = (%d,%d)\n",name,p.x,p.y);}main(){struct point a;struct point b;struct point c;a.x = 10;a.y = 10;b.x = 20;b.y = 30;findCenterPoint(&c,a,b);printPoint("a",a);printPoint("b",b);printPoint("c",c);}/* 결과는 다음과 같이 나온다.a = (10,10)b = (20,30)c = (15,20)*/ |
|---|

- © 2022 GitHub, Inc.

- [Terms](https://docs.github.com/en/github/site-policy/github-terms-of-service)', '2022-06-25 15:33:00', 0, 1, (SELECT id FROM category WHERE name='언어/C언어' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('입출금 프로그램 예제 만들어 보기', '| #include <iostream> #include <cstring> using namespace std; const int NAME_LEN = 20; void ShowMenu();  //메뉴출력 void MakeAccount();      //계좌개설을 위한 함수 void DepositMoney();     //입금 void WithdrawMoney();    //출금 void ShowAllAccInfo();   //잔액조회 enum {MAKE = 1, DEPOSIT, WITHDRAW, INQUIRE, EXIT}; typedef struct { int accID; //계좌 번호 int balance; //잔액 char cusName[NAME_LEN]; //고객 이름 }Account; Account accArr[100];   //Account 저장을 위한 배열 int accNum = 0;        //저장된 Account 수 int main(void) { int choice; while (1) { ShowMenu(); cout << "선택: "; cin >> choice; cout << endl; switch (choice) { case MAKE: MakeAccount(); break; case DEPOSIT: DepositMoney(); break; case WITHDRAW: WithdrawMoney(); break; case INQUIRE: ShowAllAccInfo(); break; case EXIT: return 0; default: cout << "Illegeal selection." << endl; } } return 0; } void ShowMenu() { cout << "---------Menu------------" << endl; cout << "1. 계좌 개설 " << endl; cout << "2. 입 금" << endl; cout << "3. 출금 " << endl;  cout << "4. 계좌 정보 전체 출력 " << endl; cout << "5.  프로그램 종룡" << endl; } void MakeAccount() { int id; char name[NAME_LEN]; int balance; cout << "[계좌 개설]" << endl; cout << "계좌 ID "; cin >> id; cout << "이름 : ";  cin >> name; cout << "입금액 : "; cin >> balance; cout << endl; accArr[accNum].accID = id; accArr[accNum].balance = balance; strcpy_s(accArr[accNum].cusName, name); accNum++; } void DepositMoney() { int money; int id; cout << "[입 금]" << endl; cout << "계좌 ID :";  cin >> id; cout << "입금액 :";  cin >> money; for (int i = 0; i < accNum; i++) { if (accArr[i].accID == id) { accArr[i].balance += money; cout << "입금 완료" << endl << endl; return; } } cout << "유효하지 않는 ID 입니다. " << endl << endl; } void WithdrawMoney() { int money; int id; cout << "[출 금]" << endl; cout << "계좌 ID : "; cin >> id; cout << "출금액: "; cin >> money; for (int i = 0; i < accNum; i++) { if (accArr[i].accID == id) { if (accArr[i].balance < money) { cout << "잔액 부족" << endl << endl; return; } accArr[i].balance -= money; cout << "출금 완료" << endl << endl; return; } } cout << "유효하지 않은 ID 입니다." << endl << endl; } void ShowAllAccInfo() { for (int i = 0; i < accNum; i++) { cout << "계좌 ID: " << accArr[i].accID << endl; cout << "이 름 : " << accArr[i].cusName << endl; cout << "잔액 : " << accArr[i].balance << endl << endl; } } |
|---|

윤성우 저자의 열혈 C++프로그래밍 예제 중 입출금 프로그램 예제를 그대로 만들어 보았다. strcpy를 사용할때 strcpy_s를 사용해야 최신 버전 비주얼 스튜디오에서 작동하는 듯 하다. 주의 하시길 바랍니다. 나는 이책으로 C++을 계속 공부해볼 생각입니다.', '2022-06-25 19:09:00', 0, 1, (SELECT id FROM category WHERE name='언어/CPP' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('4673번 셀프 넘버', '#include <iostream> 
using namespace std; 

bool num[10001]; 

int getSetNum(int n, int& a, int& b, int& c, int& d) 
{ 
int setNum1 = 0; 
int setNum10 = 0; 
int setNum100 = 0; 
int setNum1000 = 0; 
int x = 1000; 

setNum1000 = n / x; 
setNum100 = n - x * setNum1000; 
int i = n - x * setNum1000; 
x /= 10; 
setNum100 /= x; 
setNum10 = i - (x * setNum100); 
i = i - (x * setNum100); 
x /= 10; 
setNum10 /= x; 
setNum1 = i - (x * setNum10); 

a = setNum1000; 
b = setNum100; 
c = setNum10; 
d = setNum1; 

return n, a, b, c, d; 
} 
int d(int n) 
{ 
int a, b, c, d = 0; 

getSetNum(n, a, b, c, d); 

n = n + a + b + c + d; 

return n; 
} 

void self_number() { 
int temp; 
num[1] = false; 
for (int i = 0; i < 10000; i++) { 
if (i < 10000) { 
temp = d(i); 
if (temp < 10000) 
num[temp] = true; //selfnum은 생성자가 없는 수라서 d(n)에 모든 수를 ture 
                      //로 만들고 false를 출력해주면 된다. 
} 
} 
} 

int main() 
{ 
self_number(); 
for (int i = 1; i < 10000; i++) 
if (!num[i]) 
cout << i << endl; 
}', '2022-07-07 16:24:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('1.C-> C# (sum)', '| using System;using System.Collections.Generic;using System.Linq;using System.Text;using System.Threading.Tasks;// 강의 주제 : C로 작성된 getSum() 함수를 C#으로 만들어 보기////자동할당 복습//namespace : namespace안에는 여러개의 클래스를 포함할수 있다.//class//command line argument: 고급C프로그래밍 - 12-2-2차원 배열 동적 할당//command line argument 는 argc,argv와 같음// ex)//main(int argc,char* argv[])//{//}// C#에서 함수는 두가지로 나누어진다.//static function : C에서는 전역함수를 의미한다.//member function : class에서 설명함//// C언어의 함수를 C#에서 사용할때는 반드시 특정 클래스 안에 정의해주어야 한다.namespace GetSumTest{       class Program       {             static int getSum(int n) //static를 반드시 적어주어야 한다.             {                    int total = 0;                    int i;                     if(n <= 0)                      {                           Console.WriteLine("Please use positive numbver.");                           Environment.Exit(-1);                      }                      for(i = 1; i <= n; i++)                     {                         total = total + i;                     }          return total;          }          static void Main(string[] args)          {                   int sum;                    sum = Program.getSum(100);                    //전역함수를 호출할때 무슨클래스에 존재하는지 적어주어야 함                    Console.WriteLine("sum = " + sum);           }     }} |
|---|

2학기를 시작하면서 C#을 배우기 시작했다. 객체지향적인 것을 먼저하기 보다 C와 C#의 차이를 인지하고 새로운 문법을 익힌후에 객체지향적인 요소를 배울 예정이다.', '2022-09-02 18:03:00', 0, 1, (SELECT id FROM category WHERE name='언어/CS' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('2.namespace', '| using System;using System.Collections.Generic;using System.Linq;using System.Text;using System.Threading.Tasks;namespace 부산시{class 동래구{//visibility(가시성)// 동래구라는 class를 다른 namespace또는 class에서 사용하려면 public을 해주어야 한다.public static string wherAreYou(){return "부산시/동래구/사직동";}public static int add(int x, int y){return x + y +100;}}class Program{static int add(int x, int y){return x + y;}static double add(double x, double y){return x + y;}static string wherAreYou(){return "부산시/Program/Here";}static void Main(string[] args){int ans1;double ans2;ans1 = add(10, 20);Console.WriteLine(ans1);ans1 = 동래구.add(10, 20);Console.WriteLine(ans1);//동일한 이름의 add함수이지만 내부코드가 다른 함수를 클래스를 정의하면서 구분이 가능하다.ans2 = Program.add(10.1, 20.2);Console.WriteLine(ans2);Console.WriteLine(wherAreYou()); //이 코드가 위치하는 곳이 이미 부산시.Program에 있어서wherAreYou() 만 적어주어도 된다Console.WriteLine(동래구.wherAreYou());Console.WriteLine(서울시.종로구.wherAreYou()); //full nameConsole.WriteLine(경기도.광주시.wherAreYou());Console.WriteLine(전라남도.광주시.wherAreYou());}}}namespace 서울시{//visibility(가시성)class 종로구{public static string wherAreYou(){return "서울시/종로구/사직동";}}}namespace 경기도{//visibility(가시성)class 광주시{public static string wherAreYou(){return "경기도/광주시/Here";}}}namespace 전라남도{//visibility(가시성)class 광주시{public static string wherAreYou(){return "전라남도/광주시/Here";}}} |
|---|

[namespace 의 역확]
- 식별자(identifier)가 영향을 미치는 범위 지정
-대규모의 과제 수행시 식별자가 중복되는 현상을 고나리
- 주소와 비슷한 용도
  부산시 동래구 사직동
  서울시 종로구 사직동
  경기도 광주
 전라남도 광주

namespace는 한글도 사용가능하다.

namespace안에 동일한 이름을 가졌지만 타입이 다른함수를 인식가능하다.
하지만 한 class안에 동인한 이름과 타입 동인한 아규먼트까지 가지고 있으면
컴파일러는 인식하지 못한다.

하지만 똑같은 static 함수를 다른 namespace 또는 class에는 사용할수 있다.

지금 대학에서는  namespace를 각별하게 사용할 일은 없다고 한다. 하지만 다양한 사람과 함께 프로젝트나

업무를 할때 매우 중요하기 때문의 개념을 잘 인지 해야 한다.', '2022-09-02 18:07:00', 0, 1, (SELECT id FROM category WHERE name='언어/CS' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('2022/09/02 방학의 반성과 앞으로의 목표', '8월 한달동안  코딩에 집중하지 못했다. 아니다 하지 않았다고 해야한다. 내가 왜 하지 않았는지 후회스럽다.

또 그저그런 방학이 되었다. 변명이지만 알바와 개인사정으로 8월에는 학교에 나오지 않고 github와 블로그에 글을

작성하지 않았다. 그래서 학기중에는 매우 열심히 공부할 예정이다. 엉덩이가 무거워야 코딩실력이 늘것이다.

지금의 대략적 계획은 주 5일 월~금은  C#과 자료구조 수업의 예습과 복습 백준,프로그래머스 등 를 할예정이고

주말에는 sfml로 게임 프로잭트를 만들 예정이다. 7월에 C++을 이용해 간단한 중력 시뮬레이터를 만들었다. 각 객체에 상호작용 시킬 생각이였으나 쉽지 않았다. 이를 완성하고 이를 활용해 우주배경의 게임을 만들 예정이다. 먼저 기획서와 객체 테이블을 만든후 제작에 들어갈 예정이다. 블로그에 새로운 카테고리가 올라갈것이다. 기대 바람', '2022-09-02 18:15:00', 0, 1, (SELECT id FROM category WHERE name='일기' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('시작', '나는 본격적으로 프로그래밍 공부를 시작한 대학교 2학년입니다. 1학년 때는 공부의 필요성을 인지 했지만 학교가 끝나자 마자 바로 집에가서 게임을 하고 야간 알바를 하는 등의 공부와는 조금 떨어진 삶을 살았고 여느 다른 사람들 처럼 나또한 군대를 가고 인생의 처음으로 위기라는 걸 알게 되었다. 그리고 난 공부를 해야겠다고 생각했습니다. 복학을 하고 학과 연구실(그린비 동아리)에 들어가고 연구실에서 너무 좋은 사람들을 만나 공부하는 방법과 방향에 대해 조언을 듣고 많은 도움을 받았다. 이 티스토리 블로그 또한 공부하는 방법 중 하나로 사용할 예정이다. 난 이 블로그를 일기처럼 사용할 예정이다. 이 블로그를 다른 사람에게 보여질 수 있고 아닐 수 있습니다. 하지만 나와의 약속이라 생각하고 꾸준히 해보 생각입니다.

여기서 나는 코딩 공부뿐 아니라 다양한 공부를 하고싶습니다.  이제 방향은 정해졌다고 생각하고 이제는 앞으로 나아갈 길을 좁혀나가고 싶습니다. (목표를 구체화하기)  지금 당장의 목표는 C언어의 포인터와 자료구조를 익히는 것이고 C++를 자세히 공부하고 싶습니다. 지금은 너무 시작하는 단계라 어느 분야로 취직하고 싶은 지를 정하진 않았지만 다양한 공부를 하며 3학년때는 그 방향을 정할수 있으면 좋겠습니다.

| 공부해야하는 것 |
|---|
|  | 1.다이나믹 프로그래밍 |
|  | 2.그리드 알고리즘 |
|  | 3.소팅 |
|  |  |
|  | 등등 |
|  |  |
|  | 나는 c언어를 하고 나서 객체 지향언어 c++,java둘중 지금은 c++에 |
|  | 관심이 많다. |
|  |  |
|  | c++을 팔생각이다. |', '2022-04-12 10:08:00', 0, 1, (SELECT id FROM category WHERE name='일기' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('중력 시뮬레이터', '![](https://blog.kakaocdn.net/dna/bcfGWl/btrLgbb65cl/AAAAAAAAAAAAAAAAAAAAAOhr2keSQyvxOJeWjtlZDs9nBA5fUXoXwnO_qqF2JAxR/img.gif?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=IKgktdf8u3ML%2BzVx94h6QrjxwMI%3D)

#include <SFML/Graphics.hpp> 
#include <iostream> 

class GravitySource 
{ 
    sf::Vector2f pos; 
    float strength; 
    sf::CircleShape s; 

public: 
    GravitySource(float pos_x, float pos_y, float strength) 
    { 
        pos.x = pos_x; 
        pos.y = pos_y; 
        this->strength = strength; 

        s.setPosition(pos); 
        s.setFillColor(sf::Color::Red); 
        s.setRadius(15); //반지름 
    } 

    void render(sf::RenderWindow& wind) 
    { 
        wind.draw(s); 
    } 

    sf::Vector2f get_pos() 
    { 
        return pos; 
    } 

    float get_strength() 
    { 
        return strength; 
    } 
}; 

class Particle  
{ 
    sf::Vector2f pos; 
    sf::Vector2f vel; 
    sf::CircleShape s; 

public: 
    Particle(float pos_x, float pos_y, float vel_x, float vel_y) 
    { 
        pos.x = pos_x; 
        pos.y = pos_y; 

        vel.x = vel_x; 
        vel.y = vel_y; 

        s.setPosition(pos); 
        s.setFillColor(sf::Color::White); 
        s.setRadius(6); 
    } 

    void render(sf::RenderWindow& wind) 
    { 
        s.setPosition(pos); 
        wind.draw(s); 
    } 

    void update_physics(GravitySource& s) 
    { 
        float distance_x = s.get_pos().x - pos.x; 
        float distance_y = s.get_pos().y - pos.y; 

        float distance = sqrt(distance_x * distance_x + distance_y * distance_y); 

        float inverse_distance = 1.f / distance; 

        float normalized_x = inverse_distance * distance_x; //벡터 정규화 단위벡터  
        float normalized_y = inverse_distance * distance_y; //[https://wergia.tistory.com/304](https://wergia.tistory.com/304) 

        float inverse_square_dropoff = inverse_distance * inverse_distance; 

        float acceleration_x = normalized_x * s.get_strength() * inverse_square_dropoff; 
        float acceleration_y = normalized_y * s.get_strength() * inverse_square_dropoff; 

        vel.x += acceleration_x; 
        vel.y += acceleration_y; 

        pos.x += vel.x; 
        pos.y += vel.y; 
    } 
}; 

int main() 
{ 
    sf::RenderWindow window(sf::VideoMode(1600, 1000), "My Program"); 
    window.setFramerateLimit(60); 

    GravitySource source(800, 500, 3000); 
     

     
    Particle particle(700, 600, 1, 1); 
    Particle particle_1(900, 400, 1, 1); 
     
  
    while (window.isOpen()) 
    { 
        sf::Event event; 
        while (window.pollEvent(event)) 
        { 
            if (event.type == sf::Event::Closed) window.close(); 

            if (sf::Keyboard::isKeyPressed(sf::Keyboard::Escape)) window.close(); 
        } 
  

        window.clear(); 
        particle.update_physics(source); 
        particle_1.update_physics(source); 

        source.render(window); 
         
        particle.render(window); 
        particle_1.render(window); 
        //draw calls 
        window.display(); 
    } 

    return 0; 
}

소스와 파티클의 거리에 따라 가속도를 정해주어서 만듬

---', '2022-09-02 18:25:00', 0, 1, (SELECT id FROM category WHERE name='언어/심심풀이' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('3.  C# 기본형', 'using System; 
using System.Collections.Generic; 
using System.Linq; 
using System.Text; 
using Syste[m.Threading.Tasks;](http://m.Threading.Tasks;) 
/* 
 * built-int type 변수 특징 
 * -의미: 정수를 저장하는 거억장소 
 * -목적: 셀수 있는 숫자 저장 
 *        학생수, 지갑의 돈, 자동차 수 소수점 없음 
 * -상수: 1234. 0x7f12. 0755 
 * -크기: 4바이트 
 * -표형양식: 양수경우/음수경우 
 * -연산자: +-* %(modulo operator) 
 * -주의사항: overflow / truncation 
 * -short(ushort):2 bytes 
 * -long(ulong: 8bytes 
 *  
 * 문자형 변수(character variable) 
 * - 2 bytes unicode 
 *  
 * 실수형 변수(floating number variable) 
 * -float: 4bytes 
 * -double: 8bytes 
 * -decimal:16bytes (소수점 28~29자리) 
 *  
 * 불린 변수 (bool variable) 
 * - 상수 : true/ false 
 * -비교문 type checking 강화 
 *  
 * [잡다한 변화] 
 * 매크로 정의 -> 정적 데이터 멤버   /#define max (100) 같이 define을 사용하지 못한다. 클래스 외부에 선언불가능 
 * 변수 정의 순서 
 * 함수 이름 중복(function overloading) 
 * 한글 변수명 
 * is 연산자를 이용한 type checking 
 * as 연사자를 이용한  type casting 
 * format 문의 대동:  {0} {1} {2} .... 
 */ 
namespace BasicTypes 
{ 
    class Program 
    { 
        static int MAX = 100; //매크로 대용 

        static void Main(string[] args) 
        { 
            decimal x; 

            Console.WriteLine(sizeof(int)); 
            Console.WriteLine(sizeof(decimal)); 
            Console.WriteLine(sizeof(bool)); 

            x = 12.746489487463474111M; 
            Console.WriteLine(x); 

            bool b = true; 
            Console.WriteLine(b); 

            int i = MAX; 

            if( i == 10)   // i = 10 은 c언어에서는 = 가  대입이라서 요류가 생긴다. 블린변수 사용하기 
            { 
                Console.WriteLine("same"); 
            } 
            else 
            {    
                Console.WriteLine("not same"); 
            } 
            //변수 정의 순서 
            int a; 
            a = 10; 
            a++; 
            Console.WriteLine(a); 
            //한글 변수명  가능한 영어 사용 평생 사용할 일없음 
            int 돈; 
            돈 = 10; 
            돈++; 
            Console.WriteLine(돈); 

            //is 연산자를 이용한 type checking  특정타입인지를 확인하하는 연산자 
            if (a is double)  
            { 
                Console.WriteLine("a 는 실수형이다."); 
            } 
            else 
            { 
                Console.WriteLine("a 는 실수형이 아니다."); 
            } 

            //as 연사자를 이용한  type casting 보통 레퍼런스 타입의  type casting할때사용  

            a = (int)89.1; //이건 원래하는type casting 

            //format 문의 대동:  {0} {1} {2} .... 
            Console.WriteLine("a= " + a + "\n 돈= " + 돈); //원래 
            Console.WriteLine("a = {0}\n돈 = {1}", a, 돈); //format 활용한것 

            int[] arr = { 100, 300, 500, 200, 400 }; 

            foreach(int p in arr) //arr 배열의 모든 원소 
            { 
                Console.WriteLine(p); 
            } 

        } 
    } 
}', '2022-09-05 13:02:00', 0, 1, (SELECT id FROM category WHERE name='언어/CS' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('4.Recursive Function 재귀함수', 'using System; 
using System.Collections.Generic; 
using System.Linq; 
using System.Text; 
using Syste[m.Threading.Tasks;](http://m.Threading.Tasks;) 
/* 
 * Recursive FUnction(재귀함수) 
 *  
 * 어떠한 함수 정의 내에서 자기 자신 함수 호출 
 * ex) 
 * void f() 
 * {   
 *  ..... 
 *  f(); 
 *  ..... 
 * } 
 *  
 * 분할 정복(divide & conquer) 방식의 문제해결기법 
 * n개의 문제 -> 1개의 문제 + (n-1)개으 ㅣ문제  
 * n개의 문제 -> n/2개의 문제 + n/2개의 문제 
 * n개의 문제 -> n/4개의 문제 + n/4개의 문제+ n/4개의 문제 +n/4개의 문제 
 *  
 * 단점: 속도 느림 / 기억장소 소비 많음 
 * 장점: 알고리즘을 작성하거나 이해하기 쉬움 
 *  
 * 강의 목적: 재귀함수 소개 + 자동 할당 메카니즘 이해 
 *  
 * Fibonacci Sequence - 피보나치 수열 
 *  
 *   1    1    2    3    5    8    13    21 ..... 
 *   f0  f1   f2   f3   f4   f5    f6     
 *    
 * f(n) 의 정의  
 * f(n) = f(n-1) + f(n-2) when n  >= 2  n이 2 이상일때 가능 
 * f(1) = 1 when n = 1 
 * f(0) = 1 when n = 0 
 * boundary condition 는 위의 조건처럼 recursive function이 무한 루프의 빠지지 않게 하기 위한것이다

* 자동할당 메카니즘 이해  
 * 프로그램의 빠르기 척도 
 * complexity : O(1)[오덜오브원 딱 그만큼의 시간]  
 *              O(log(n))[오덜오브 로그 엔 로그엔만큼의 시간이 소요] 
 *              O(n) [오덜오브 엔 데이터의 갯수의 비례하여 선형적으로 증가한다.]       
 *              O(n+log(n))[오덜오브 엔 로그엔] 
 *              O(n*n)[오덜오브 엔 스쿼어 급격한 증가] 
 *  
 * time complextiy: O(n*n)  
 * space compleity: O(n) 
 */ 

namespace Fibo 
{ 
     
    class Program 
    { 
        static int fibo(int n) 
        { 
            if (n == 0) return 1; 
            if (n == 1) return 0; 
            if (n < 0) 
            { 
                Console.WriteLine("Unexpectde minus argument!!"); 
                Environment.Exit(-1); 
                return -1; 
            } 
            int f0 = 1; 
            int f1 = 1; 
            int f2 = 0; 
            for (int i = 1; i < n; i++) 
            { 
                f2 = f1 + f0; 
                f0 = f1; 
                f1 = f2; 
            } 
            return f2; 
        } 

        static int fiboRF(int n) 
        { 
            if (n == 0) return 1; 
            if (n == 1) return 0; 
            if (n >= 2) return fiboRF(n - 1) + fiboRF(n - 2); //함수호출 하나에서 2개로 분리되서 매우 비효율적이라서 그렇다 
            Console.WriteLine("Unexpectde minus argument!!"); 
            Environment.Exit(-1); 
            return -1; 
        } 

        static void f(int n) 
        { 
            //Recursive Function에는 반드시 아규먼트가 존재한다. 
            if (n == 0) return; 
            Console.WriteLine("hello"); 
            f(n-1); 
        } 

        static void Main(string[] args) 
        { 
           // f(5) 
             
            for (int i = 0; i < 44; i++) //프로그램이 비효율적이라서 속도가 느리다.  
            { 
                Console.WriteLine(fibo(i)); 
                //Console.WriteLine(fiboRF(i)); 
                //굳이 재귀함수사용안해도 되지만 소개하기 위해 사용 
                //다음시간에는 재귀함수의 자동할당 메카니즘 대해 배울것이다. 
            } 
        } 
    } 
}', '2022-09-07 19:09:00', 0, 1, (SELECT id FROM category WHERE name='언어/CS' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('실시간 위치 추적 안드로이드 앱', '교내 프로그램 전시회에서 참가하게 되어 안드로이스 스튜디오를 이용해 앱을 제작하게 되었다. 처음해보는 프로잭트라서  선배들의 조언을 통해 앱을 구상하게 되었는데, 올해 4학년 갭스톤 시간에 나온 아이디어였던 교내 셔틀 위치정보 서비스 이다. 하지만 이 아이디어는 기획단계 까지만 사용되고 그 이후 발전이 없는 상태 였다. 나는 이 아이디어를 알파 버전단계 까지 구형을 목표로 했다.

현재 부산외국어대학교에서 운행되는 셔틀 버스는 학교 근처 범어사역과 남산역을 지나는 노선으로 한반향만으로 운행된다. 노선 자체가 1개 뿐이고 버스의 소유가 학교가 아닌 개인 기사님 버스를 대여하고 운행하기 때문에 따로 GPS 모듈을 버스내에 설치하는 것은 기사님들의 사생활 침해 가능성으로 불가능하기 때문에 다른 방법을 생각해야 한다.

그래서 나는  GPS 모듈이 기본 내장되었는 휴대전화 공기계를 이용할 생각을 하게 되었다. 버스에 탈부착이 자유롭고 유저 인터페이스를 구축하기 편하고 가격적인 측면에서도 GPS 모듈을 따로 만들어 주지 않아도 되기 때문이다 .그리고 현재 학교 셔틀버스에는 와이파이가 설치  되어있지 않아서 공기계에 유심을 작착해야 한다. 이 부분은 학교와 상의가 필요하다.  나는 다양한 선택지들 중 휴대전화 공기계가 가장 저렴하고 유지 부수를 싶게 할수 있을 것 같아서 채택하게 되었다.

아래에 github주소와 호잇이라는 교내 전시회 아카이브에 본 프로잭트의 설명이 명시되어있습니다.

작동원리는 다음과 같습니다. 총 2가지의 안드로이드 앱과 firebase라는 실시간 데이터베이스를 지원하는  db 한개를 이용해 본 서비스가 가능합니다. 먼저 첫번째 앱은 현재 앱이 작동중인 기기의 위치 정보를 위도,경도를 알아내어 데이터베이스로 업로드 한는 앱입니다. 1초당으로 현재의 위치 정보를 데이터베이스에 업로드 합니다.  두번째 앱은 firebase의 실시간 DB에서 데이터를 가져와 google map에 뛰워주는 앱입니다.

GitHub 주소: [https://github.com/BaSak0630/HOIT_YOITNE](https://github.com/BaSak0630/HOIT_YOITNE)

[
 

GitHub - BaSak0630/HOIT_YOITNE

Contribute to BaSak0630/HOIT_YOITNE development by creating an account on GitHub.

github.com

](https://github.com/BaSak0630/HOIT_YOITNE)

교내 전시회 아카이브 사이트

Hoit : [https://hoit.netlify.app/project/62](https://hoit.netlify.app/project/62)

[
 

호잇 — 프로젝트 아카이브 서비스

hoit.netlify.app

](https://hoit.netlify.app/project/62)', '2022-12-05 14:12:00', 0, 1, (SELECT id FROM category WHERE name='JAVA' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('10828번 스텍 JAVA', '## 문제

정수를 저장하는 스택을 구현한 다음, 입력으로 주어지는 명령을 처리하는 프로그램을 작성하시오.

명령은 총 다섯 가지이다.

- push X: 정수 X를 스택에 넣는 연산이다.
- pop: 스택에서 가장 위에 있는 정수를 빼고, 그 수를 출력한다. 만약 스택에 들어있는 정수가 없는 경우에는 -1을 출력한다.
- size: 스택에 들어있는 정수의 개수를 출력한다.
- empty: 스택이 비어있으면 1, 아니면 0을 출력한다.
- top: 스택의 가장 위에 있는 정수를 출력한다. 만약 스택에 들어있는 정수가 없는 경우에는 -1을 출력한다.

## 입력

첫째 줄에 주어지는 명령의 수 N (1 ≤ N ≤ 10,000)이 주어진다. 둘째 줄부터 N개의 줄에는 명령이 하나씩 주어진다. 주어지는 정수는 1보다 크거나 같고, 100,000보다 작거나 같다. 문제에 나와있지 않은 명령이 주어지는 경우는 없다.

## 출력

출력해야하는 명령이 주어질 때마다, 한 줄에 하나씩 출력한다.

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.util.StringTokenizer;

public class Back_10828 { 
    public static int[] stack;
    public static int size = 0;
 
 
    public static void main(String[] args) throws IOException {
 
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringBuilder sb = new StringBuilder();
        
        
        StringTokenizer st;
        
        int N = Integer.parseInt(br.readLine());
 
        stack = new int[N];
        
     for(int i = 0; i <N; i++){
            st = new StringTokenizer(br.readLine(), " ");
 
            switch (st.nextToken()) {
            
            case "push":
                push(Integer.parseInt(st.nextToken()));
                break;
                
            case "pop":
                sb.append(pop()).append(''\n'');
                break;
                
            case "size":
                sb.append(size()).append(''\n'');
                break;
                
            case "empty":
                sb.append(empty()).append(''\n'');
                break;
                
            case "top":
                sb.append(top()).append(''\n'');
                break;
            }
 
        }
        System.out.println(sb);
    }
 
    public static void push(int item) {
        stack[size] = item;
        size++;
    }
    
    public static int pop() {
        if(size == 0) {
            return -1;
        }
        else {
            int res = stack[size - 1];
            stack[size - 1] = 0;
            size--;
            return res;
        }
    }
    
    public static int size() {
        return size;
    }
    
    public static int empty() {
        if(size == 0) {
            return 1;
        }
        else {
            return 0;
        }
    }
    
    public static int top() {
        if(size == 0) {
            return -1;
        }
        else {
            return stack[size - 1];
        }
    }
    
}', '2023-02-02 17:55:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('10807 개수 세기 - java', '# 개수 세기 성공

 

시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 1 초 | 256 MB | 39633 | 26378 | 23479 | 67.692% |
|---|---|---|---|---|---|

## 문제

총 N개의 정수가 주어졌을 때, 정수 v가 몇 개인지 구하는 프로그램을 작성하시오.

## 입력

첫째 줄에 정수의 개수 N(1 ≤ N ≤ 100)이 주어진다. 둘째 줄에는 정수가 공백으로 구분되어져있다. 셋째 줄에는 찾으려고 하는 정수 v가 주어진다. 입력으로 주어지는 정수와 v는 -100보다 크거나 같으며, 100보다 작거나 같다.

## 출력

첫째 줄에 입력으로 주어진 N개의 정수 중에 v가 몇 개인지 출력한다.

## 예제 입력 1 복사

```
11
1 4 1 2 4 2 4 2 3 4 4
2

```

## 예제 출력 1 복사

```
3

```

## 예제 입력 2 복사

```
11
1 4 1 2 4 2 4 2 3 4 4
5

```

## 예제 출력 2 복사

```
0
```

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

public class Back_10807 {
    public static void main(String[] args) {
        String buffer = "";
        int[] numArray;
        int N = 0;
        int v = 0;
        int count= 0;
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        try{
            buffer = br.readLine();

        }catch (Exception e) {
          
        }
        N = Integer.parseInt(buffer);
        numArray = new int[N];
        try {
            buffer = br.readLine();
        } catch (Exception e) {
            // TODO: handle exception
        }
      
        String[] strArray = buffer.split(" ");
        for(int i = 0; i < numArray.length; i++)
        {
            numArray[i] = Integer.parseInt(strArray[i]);
        }
        try {
            buffer = br.readLine();
        } catch (Exception e) {
            // TODO: handle exception
        }
        v = Integer.parseInt(buffer);
        for(int i = 0; i < numArray.length; i++)
        {
            if(numArray[i] == v)
            {
                count++;
            }
        }
        System.out.println(count);
    }
}', '2023-02-06 20:58:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('1475 방번호 -java 완', '# 방 번호 성공

시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 2 초 | 128 MB | 51984 | 23767 | 17291 | 44.404% |
|---|---|---|---|---|---|

## 문제

다솜이는 은진이의 옆집에 새로 이사왔다. 다솜이는 자기 방 번호를 예쁜 플라스틱 숫자로 문에 붙이려고 한다.

다솜이의 옆집에서는 플라스틱 숫자를 한 세트로 판다. 한 세트에는 0번부터 9번까지 숫자가 하나씩 들어있다. 다솜이의 방 번호가 주어졌을 때, 필요한 세트의 개수의 최솟값을 출력하시오. (6은 9를 뒤집어서 이용할 수 있고, 9는 6을 뒤집어서 이용할 수 있다.)

## 입력

첫째 줄에 다솜이의 방 번호 N이 주어진다. N은 1,000,000보다 작거나 같은 자연수이다.

## 출력

첫째 줄에 필요한 세트의 개수를 출력한다.

```
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Back_1475 {
    public static void main(String[] args){
        String s= " ";
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        try {
            s = br.readLine();
        } catch (Exception e) {
            // TODO: handle exception
        }
        
        int[] arr = new int[10];
        for (int i = 0; i < s.length(); i++) {
            int num = Character.getNumericValue(s.charAt(i));
            if (num == 6) {
                arr[9]++;
            } else {
                arr[num]++;
            }
        }
        int max = 0;
        for (int i = 0; i < 9; i++) {
            max = Math.max(max,arr[i]); //max는 if문을 사용하지 않고 큰값을 max에 넣는다.
        }
        int nine = arr[9]/2;
        if (arr[9]%2==1) nine++;
        max = Math.max(max,nine);
        System.out.print(max);
    }
}
```', '2023-02-10 20:41:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('2941 크로아티아 알파벳 - java', '# 크로아티아 알파벳 성공다국어

한국어    

시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 1 초 | 128 MB | 132952 | 58969 | 49850 | 44.550% |
|---|---|---|---|---|---|

## 문제

예전에는 운영체제에서 크로아티아 알파벳을 입력할 수가 없었다. 따라서, 다음과 같이 크로아티아 알파벳을 변경해서 입력했다.

크로아티아 알파벳변경

| č | c= |
|---|---|
| ć | c- |
| dž | dz= |
| đ | d- |
| lj | lj |
| nj | nj |
| š | s= |
| ž | z= |

예를 들어, ljes=njak은 크로아티아 알파벳 6개(lj, e, š, nj, a, k)로 이루어져 있다. 단어가 주어졌을 때, 몇 개의 크로아티아 알파벳으로 이루어져 있는지 출력한다.

dž는 무조건 하나의 알파벳으로 쓰이고, d와 ž가 분리된 것으로 보지 않는다. lj와 nj도 마찬가지이다. 위 목록에 없는 알파벳은 한 글자씩 센다.

## 입력

첫째 줄에 최대 100글자의 단어가 주어진다. 알파벳 소문자와 ''-'', ''=''로만 이루어져 있다.

단어는 크로아티아 알파벳으로 이루어져 있다. 문제 설명의 표에 나와있는 알파벳은 변경된 형태로 입력된다.

## 출력

입력으로 주어진 단어가 몇 개의 크로아티아 알파벳으로 이루어져 있는지 출력한다.

```
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Back_2941 {
    public static void main(String[] args) {
        String s = " ";
        int count = 0;
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        try {
            s = br.readLine();
        } catch (Exception e) {
        }
        count = s.length();
        if(s.charAt(0) == ''='')
        {
            count -= 1;
        }
        if(s.charAt(0) == ''-'')
        {
            count -= 1;
        }
        for(int i = 0; i < s.length(); i++)
        {
            if(s.charAt(i) == ''c'' && i+1 != s.length()){
                if(s.charAt(i+1) == ''='') count -= 1;
                else if(s.charAt(i+1) == ''-'') count -= 1;
            }
            else if(s.charAt(i) == ''d''&& i+1 != s.length()){
                if(s.charAt(i+1) == ''z''&& i+2 != s.length()){
                    if(s.charAt(i+2)== ''='')
                    { 
                        count -= 2;
                        i += 2;
                    }
                }
                else if(s.charAt(i+1) == ''-'') count -= 1;
            }
            else if(s.charAt(i) == ''l''&& i+1 != s.length()){
                if(s.charAt(i+1) == ''j'') count -= 1;
            }
            else if(s.charAt(i) == ''n''&& i+1 != s.length()){
                if(s.charAt(i+1) == ''j'')count -= 1;
            }
            else if(s.charAt(i) == ''s''&& i+1 != s.length()){
                if(s.charAt(i+1) == ''='')count -= 1;
            }
            else if(s.charAt(i) == ''z''&& i+1 != s.length()){
                if(s.charAt(i+1) == ''='') count -= 1;
            }
            else if(s.charAt(i) == ''=''&& i+1 != s.length()){
                if(s.charAt(i+1) == ''='') count -= 1;
                else if (s.charAt(i+1) == ''-'') count -= 1;
            }
            else if(s.charAt(i) == ''-''&& i+1 != s.length()){
                if(s.charAt(i+1) == ''='') count -= 1;
                else if (s.charAt(i+1) == ''-'') count -= 1;
            }
        }
        System.out.println(count);
    }
}
```

이 문제를 풀때 저자는처음 입력값의 알파벳 갯수에서 크로아티아 알파벳이 나올때 하나로 묶는 식으로 생각해주었다.', '2023-02-10 20:46:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('백준 3003 킹, 퀸, 룩, 비숍, 나이트, 폰 - java', '# 킹, 퀸, 룩, 비숍, 나이트, 폰 성공다국어

한국어   

시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 1 초 | 128 MB | 78067 | 42007 | 37274 | 55.019% |
|---|---|---|---|---|---|

## 문제

동혁이는 오래된 창고를 뒤지다가 낡은 체스판과 피스를 발견했다.

체스판의 먼지를 털어내고 걸레로 닦으니 그럭저럭 쓸만한 체스판이 되었다. 하지만, 검정색 피스는 모두 있었으나, 흰색 피스는 개수가 올바르지 않았다.

체스는 총 16개의 피스를 사용하며, 킹 1개, 퀸 1개, 룩 2개, 비숍 2개, 나이트 2개, 폰 8개로 구성되어 있다.

동혁이가 발견한 흰색 피스의 개수가 주어졌을 때, 몇 개를 더하거나 빼야 올바른 세트가 되는지 구하는 프로그램을 작성하시오.

## 입력

첫째 줄에 동혁이가 찾은 흰색 킹, 퀸, 룩, 비숍, 나이트, 폰의 개수가 주어진다. 이 값은 0보다 크거나 같고 10보다 작거나 같은 정수이다.

## 출력

첫째 줄에 입력에서 주어진 순서대로 몇 개의 피스를 더하거나 빼야 되는지를 출력한다. 만약 수가 양수라면 동혁이는 그 개수 만큼 피스를 더해야 하는 것이고, 음수라면 제거해야 하는 것이다.

```
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Back_3003 {
    public static void main(String[] args) {
        String buffer = "";
        int[] sample =new int[] {1,1,2,2,2,8};
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        try {
            buffer = br.readLine();
        } catch (Exception e) {
            // TODO: handle exception
        }
        String[] strArray = buffer.split(" ");
        int[] set = new int [strArray.length];

        for(int i = 0; i < strArray.length; i++)
        {
            set[i] = Integer.parseInt(strArray[i]);
        }
        for(int i = 0; i < set.length; i++)
        {
            if(sample[i] > set[i])
            {
                set[i] = sample[i] - set[i];
            }
            else if(sample[i] < set[i])
            {
                set[i] = sample[i] - set[i];
            }
            else if(sample[i] == set[i])
            {
                set[i] = 0;
            }
        }
        buffer = "";
        for(int i = 0; i < set.length; i++)
        {
            buffer = buffer.concat(Integer.toString(set[i]));
            buffer = buffer.concat(" ");
        }
        System.out.println(buffer);
       }
}
```

이 문제는 배열을 2개를 준비하는데 한개는 한 세트를 구성하는 수를 충족한 배열 다른 하나는 입력값의 배열을 준비한다.

구성하는 배열 과 입력값배열의 차를 이용하면 해결이 가능하다.', '2023-02-10 20:50:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('백준 2455 지능형 기차- java', '# 지능형 기차 성공

시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 1 초 | 128 MB | 24494 | 17858 | 15818 | 76.290% |
|---|---|---|---|---|---|

## 문제

최근에 개발된 지능형 기차가 1번역(출발역)부터 4번역(종착역)까지 4개의 정차역이 있는 노선에서 운행되고 있다. 이 기차에는 타거나 내리는 사람 수를 자동으로 인식할 수 있는 장치가 있다. 이 장치를 이용하여 출발역에서 종착역까지 가는 도중 기차 안에 사람이 가장 많을 때의 사람 수를 계산하려고 한다. 단, 이 기차를 이용하는 사람들은 질서 의식이 투철하여, 역에서 기차에 탈 때, 내릴 사람이 모두 내린 후에 기차에 탄다고 가정한다.

![](https://blog.kakaocdn.net/dna/3hyqX/btrYTVlpwk5/AAAAAAAAAAAAAAAAAAAAAHkmsenyIrG-38iBuBojhbdoH9KCGUGv-AOdJcS8OkGy/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=VKmCyjBLSF%2BO7J6umBZP33nvmLI%3D)

 내린 사람 수탄 사람 수1번역(출발역)2번역3번역4번역(종착역)

| 0 | 32 |
|---|---|
| 3 | 13 |
| 28 | 25 |
| 39 | 0 |

예를 들어, 위와 같은 경우를 살펴보자. 이 경우, 기차 안에 사람이 가장 많은 때는 2번역에서 3명의 사람이 기차에서 내리고, 13명의 사람이 기차에 탔을 때로, 총 42명의 사람이 기차 안에 있다.

이 기차는 다음 조건을 만족하면서 운행된다고 가정한다.

1. 기차는 역 번호 순서대로 운행한다.
2. 출발역에서 내린 사람 수와 종착역에서 탄 사람 수는 0이다.
3. 각 역에서 현재 기차에 있는 사람보다 더 많은 사람이 내리는 경우는 없다.
4. 기차의 정원은 최대 10,000명이고, 정원을 초과하여 타는 경우는 없다.

4개의 역에 대해 기차에서 내린 사람 수와 탄 사람 수가 주어졌을 때, 기차에 사람이 가장 많을 때의 사람 수를 계산하는 프로그램을 작성하시오.

## 입력

각 역에서 내린 사람 수와 탄 사람 수가 빈칸을 사이에 두고 첫째 줄부터 넷째 줄까지 역 순서대로 한 줄에 하나씩 주어진다.

## 출력

첫째 줄에 최대 사람 수를 출력한다.

```
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Back_2455 {
    public static void main(String[] args) {
        String[] buffer = new String [4];
        String[] stationBuffer = new String[2];
        int[] people =new int[8];

        int max = 0;
        int in =0;
        int j = 0;
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        try {
            for(int i = 0; i < buffer.length; i++)
            {
                buffer[i] = br.readLine(); 
                stationBuffer = buffer[i].split(" ");
                people[j] = Integer.parseInt(stationBuffer[0]);
                people[j+1] = Integer.parseInt(stationBuffer[1]);
                j += 2;
            }
        } catch (Exception e) {
            // TODO: handle exception
        }
       
        j = 0;
        for(int i = 0; i < 4; i++)
        {
             in -= people[j];
             in += people[j+1];
             if(in > max)
             {
                max = in;
             }
             j +=2;
        }
        System.out.println(max);
    }
}
```

이 문제는 in 이 내부인원인데 매번 역에 도착할때 마다 내리는 사람을 빼주고 탄사람을 더한후 그값을 max와 비교하면서 최대값을 찾는다

---', '2023-02-10 20:54:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('C_포인터_swap', '| /* swap1.c *//* 강의 주제 :swapping*/#include main(){int a = 10;int b = 20;int tmp;printf("before swapping: a = %d b = %d\n", a, b);tmp = a;a = b;b = tmp;/* //아래 방식으로 했을땐...a = b;b = a;*/printf("after swapping: a = %d b = %d\n", a, b);} |
|---|

결과는 다음과 같이 나온다.
before swapping: a = 10 b = 20
after swapping: a = 20 b = 10

| #include void swap(int *a,int *b){  int tmp;    tmp = *a;  *a = *b;  *b = tmp;}main(){  int a = 10;   int b = 20;    printf("before swapping : a = %d , b = %d \n", a,b)  swap(&a,&b); //integer point type   printf("after swapping : a = %d , b = %d \n", a,b);}#include void swap(int *a,int *b){  int tmp;    tmp = *a;  *a = *b;  *b = tmp;}main(){  int a = 10;   int b = 20;    printf("before swapping : a = %d , b = %d \n", a,b)  swap(&a,&b); //integer point type   printf("after swapping : a = %d , b = %d \n", a,b);}#include void swap(int *a,int *b){  int tmp;    tmp = *a;  *a = *b;  *b = tmp;}main(){  int a = 10;   int b = 20;    printf("before swapping : a = %d , b = %d \n", a,b)  swap(&a,&b); //integer point type   printf("after swapping : a = %d , b = %d \n", a,b);} |
|---|

만약 f(x,y,&z,&a,p) 라는 함수가 있다고 가정했을 때 actual parameter 중  x,y,p는 call by value(원래의 값?)이고, &z,&a는 call by reference(주소값)이다.

| #incluidevoid set_10(int a, int b){a = 10;b = 10;}main(){int x;int y;print("beggore initialization : x = %d y =%d \n",x,y);set_10(x,y);pritnf("agter initialization : z = %d y = %d \n", x,y);} |
|---|

결과는 다음과 같이 나온다.

before initialization: x = -858993460 y = -858993460
after initialization: x = -85993460 y = -85996460

위의 코드가 저런 값이 나온 이유는 함수에서 포인터를 사용하지 않아 set_10 함수로 들어간 x,y가 빠져나오면서 메모리 변수 할당이 해제되기 때문이다.

| #includevoid set_10(int *a, int *b){*a = 10;* b = 10;}main(){int x;int y;print("beggore initialization : x = %d y =%d \n",x,y);set_10(&x,&y);pritnf("agter initialization : z = %d y = %d \n", x,y);} |
|---|

main의 값을 함수로 바꾸고 싶으면 call by referencef를해서 포인터를 이용해야 한다.', '2022-04-12 16:39:00', 0, 1, (SELECT id FROM category WHERE name='언어/C언어' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('백준 1092 배 - java', '# 배 성공

시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 2 초 | 128 MB | 19498 | 4786 | 3383 | 24.070% |
|---|---|---|---|---|---|

## 문제

지민이는 항구에서 일한다. 그리고 화물을 배에 실어야 한다. 모든 화물은 박스에 안에 넣어져 있다. 항구에는 크레인이 N대 있고, 1분에 박스를 하나씩 배에 실을 수 있다. 모든 크레인은 동시에 움직인다.

각 크레인은 무게 제한이 있다. 이 무게 제한보다 무거운 박스는 크레인으로 움직일 수 없다. 모든 박스를 배로 옮기는데 드는 시간의 최솟값을 구하는 프로그램을 작성하시오.

## 입력

첫째 줄에 N이 주어진다. N은 50보다 작거나 같은 자연수이다. 둘째 줄에는 각 크레인의 무게 제한이 주어진다. 이 값은 1,000,000보다 작거나 같다. 셋째 줄에는 박스의 수 M이 주어진다. M은 10,000보다 작거나 같은 자연수이다. 넷째 줄에는 각 박스의 무게가 주어진다. 이 값도 1,000,000보다 작거나 같은 자연수이다.

## 출력

첫째 줄에 모든 박스를 배로 옮기는데 드는 시간의 최솟값을 출력한다. 만약 모든 박스를 배로 옮길 수 없으면 -1을 출력한다.

```
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Comparator;
import java.util.*;

public class Back_1092 {
    public static void main(String[] args) {
        String[] buffer = new String [4];
        ArrayList<Integer> crane;
        ArrayList<Integer> box;
        int N = 0;
        int M = 0;
        int min = 0;
        
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        try {
            for(int i = 0; i < buffer.length; i++)
            {
                buffer[i] = br.readLine();
            }
        } catch (Exception e) {
            // TODO: handle exception
        }
        N = Integer.parseInt(buffer[0]);

        crane = new ArrayList<>();
        String[] bufferArr = buffer[1].split(" ");
        for(int i = 0; i < N; i++)
        {   
            crane.add(Integer.parseInt(bufferArr[i]));
        }

        M = Integer.parseInt(buffer[2]);

        box = new ArrayList<>();
        String[] boxWeightArr = buffer[3].split(" ");
        for(int i = 0; i < M; i++)
        {   
            box.add(Integer.parseInt(boxWeightArr[i]));
        }
        
        Collections.sort(crane,Comparator.reverseOrder());
        Collections.sort(box,Comparator.reverseOrder());

      
        if(box.get(0) > crane.get(0))
        {
            System.out.println(-1);
            return;
        }
    
        while(!box.isEmpty()) {
            int idx =0;
            for(int i=0; i< N; ) {
                if(idx == box.size()) break;
                else if(crane.get(i) >= box.get(idx)) {
                    box.remove(idx);
                    i++;
                }else idx++;
            }
            min++;
        }
        
        System.out.println(min);
    }
    
}
```', '2023-02-13 19:36:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('백준 1267 핸드폰 요금 -java', '# 핸드폰 요금 성공

시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 2 초 | 128 MB | 16223 | 7497 | 6651 | 46.980% |
|---|---|---|---|---|---|

## 문제

동호는 새악대로 T 통신사의 새 핸드폰 옴머나를 샀다. 새악대로 T 통신사는 동호에게 다음 두 가지 요금제 중 하나를 선택하라고 했다.

1. 영식 요금제
2. 민식 요금제

영식 요금제는 30초마다 10원씩 청구된다. 이 말은 만약 29초 또는 그 보다 적은 시간 통화를 했으면 10원이 청구된다. 만약 30초부터 59초 사이로 통화를 했으면 20원이 청구된다.

민식 요금제는 60초마다 15원씩 청구된다. 이 말은 만약 59초 또는 그 보다 적은 시간 통화를 했으면 15원이 청구된다. 만약 60초부터 119초 사이로 통화를 했으면 30원이 청구된다.

동호가 저번 달에 새악대로 T 통신사를 이용할 때 통화 시간 목록이 주어지면 어느 요금제를 사용 하는 것이 저렴한지 출력하는 프로그램을 작성하시오.

## 입력

동호가 저번 달에 이용한 통화의 개수 N이 주어진다. N은 20보다 작거나 같은 자연수이다. 둘째 줄에 통화 시간 N개가 주어진다. 통화 시간은 10,000보다 작거나 같은 자연수이다.

## 출력

첫째 줄에 싼 요금제의 이름을 출력한다. 그 후에 공백을 사이에 두고 요금이 몇 원 나오는지 출력한다. 만약 두 요금제의 요금이 모두 같으면 영식을 먼저 쓰고 민식을 그 다음에 쓴다.

영식은 Y로, 민식은 M으로 출력한다.

```
import java.util.Scanner;
 
public class Main {
 
    public static void main(String args[]) throws Exception {
        Scanner sc = new Scanner(System.in);
        int N = sc.nextInt();
        int K;
        int YoungSik = 0, MinSik = 0;
        for (int i = 0; i < N; i++) {
            K = sc.nextInt();
            YoungSik += ((K / 30) + 1) * 10;
            MinSik += ((K / 60) + 1) * 15;
 
        }
        if (YoungSik == MinSik) {
            System.out.println("Y M " + YoungSik);
        } else if (YoungSik < MinSik) {
            System.out.println("Y " + YoungSik);
        } else if (YoungSik > MinSik) {
            System.out.println("M " + MinSik);
        }
    }
}
```', '2023-02-14 20:10:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('백준 5430  AC - java', '# AC 성공다국어

한국어   

시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 1 초 | 256 MB | 103322 | 22884 | 16146 | 19.826% |
|---|---|---|---|---|---|

## 문제

선영이는 주말에 할 일이 없어서 새로운 언어 AC를 만들었다. AC는 정수 배열에 연산을 하기 위해 만든 언어이다. 이 언어에는 두 가지 함수 R(뒤집기)과 D(버리기)가 있다.

함수 R은 배열에 있는 수의 순서를 뒤집는 함수이고, D는 첫 번째 수를 버리는 함수이다. 배열이 비어있는데 D를 사용한 경우에는 에러가 발생한다.

함수는 조합해서 한 번에 사용할 수 있다. 예를 들어, "AB"는 A를 수행한 다음에 바로 이어서 B를 수행하는 함수이다. 예를 들어, "RDD"는 배열을 뒤집은 다음 처음 두 수를 버리는 함수이다.

배열의 초기값과 수행할 함수가 주어졌을 때, 최종 결과를 구하는 프로그램을 작성하시오.

## 입력

첫째 줄에 테스트 케이스의 개수 T가 주어진다. T는 최대 100이다.

각 테스트 케이스의 첫째 줄에는 수행할 함수 p가 주어진다. p의 길이는 1보다 크거나 같고, 100,000보다 작거나 같다.

다음 줄에는 배열에 들어있는 수의 개수 n이 주어진다. (0 ≤ n ≤ 100,000)

다음 줄에는 [x1,...,xn]과 같은 형태로 배열에 들어있는 정수가 주어진다. (1 ≤ xi ≤ 100)

전체 테스트 케이스에 주어지는 p의 길이의 합과 n의 합은 70만을 넘지 않는다.

## 출력

각 테스트 케이스에 대해서, 입력으로 주어진 정수 배열에 함수를 수행한 결과를 출력한다. 만약, 에러가 발생한 경우에는 error를 출력한다.

아래 주석에 있는 2개의 코드는 시간초과로 백준에서는 정답이 아니다. 하지만 시간초과를 제외하고 아직 반례를 찾지 못해서 문제점이나 반례가 존재하다면 댓글을 남겨주시면 열심히 공부하겠습니다.

```
import java.io.*;
import java.util.*;

public class Back_5430 { 
	
	public static void main(String[] args) throws Exception {		
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		StringTokenizer st;
		StringBuilder sb = new StringBuilder();
				
		int n = Integer.parseInt(br.readLine());
		
		while (n-- > 0) {
			String ac = br.readLine();
			int elementNum = Integer.parseInt(br.readLine());
			String inputArr = br.readLine();
			boolean isReversed = false;
			boolean isError = false;
			
			st = new StringTokenizer(inputArr, "[],");
			
			ArrayList<Integer> list = new ArrayList<Integer>();
			for (int i = 0; i < elementNum; i++) 
				list.add(Integer.parseInt(st.nextToken()));
			
			for (int i = 0; i < ac.length(); i++) {				
				if (ac.charAt(i) == ''R'' && !isReversed) {
					isReversed = true;
				}
				else if (ac.charAt(i) == ''R'' && isReversed) {
					isReversed = false;
				}
				if (ac.charAt(i) == ''D'') {
					if (list.size() == 0) {
						isError = true;
						break;
					}
					if (!isReversed)
						list.remove(0);
					else
						list.remove(list.size()-1);
				}
			}
			
			if (isError) sb.append("error\n");
			else {
				if (isReversed) {
					/*sb.append("[");
					for (int i = list.size()-1; i >= 0; i--) {
						sb.append(list.get(i) + ",");
					}
					if (sb.charAt(sb.length()-1) == '','')
						sb.deleteCharAt(sb.length()-1);
					sb.append("]\n");*/
					
					ListIterator<Integer> it = list.listIterator(list.size());
					sb.append("[");
					while (it.hasPrevious()) {
						sb.append(it.previous() + ",");
					}
					if (sb.charAt(sb.length()-1) == '','')
						sb.deleteCharAt(sb.length()-1);
					sb.append("]\n");
				}
				else {
					ListIterator<Integer> it = list.listIterator();
					sb.append("[");
					while (it.hasNext()) {
						sb.append(it.next() + ",");
					}
					if (sb.charAt(sb.length()-1) == '','')
						sb.deleteCharAt(sb.length()-1);
					sb.append("]\n");
				}
			}
			
			/*for (int i = 0; i < list.size(); i++) {
				if (i == 0)
					sb.append("[");
				if (i == list.size()-1) {
					sb.append(list.get(i) + "]");
					break;
				}
				sb.append(list.get(i) + ",");
			}
			sb.append("\n");*/
		}
		System.out.println(sb);
		
	}	
} 

//========================첫번째 ArrayList를 덱처럼 푼거
// import java.io.*;
// import java.util.*;

// public class Back_5430 {
//     public static void main(String[] args) throws IOException {
//         Deque<Integer> numDeque = new ArrayDeque<>();
//         int numOfCase = 0;
//         Boolean rIsOn = false;
//         boolean error = false;
//         BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
//         BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(System.out));
//         numOfCase = Integer.parseInt(br.readLine());
    
//         String[] result = new String[numOfCase];
//         String command = "";
//         int numOfElements = 0;
//         String inputArr = "";
//         for(int i = 0; i < numOfCase; i++)
//         {
//             list.clear();
//             rIsOn = false;
//             command = br.readLine();
//             numOfElements = Integer.parseInt(br.readLine());
//             inputArr = br.readLine();
            
//             char[] charArr = new char [command.length()];
//             for(int j = 0; j < command.length(); j++)
//             {
//                 charArr[j] = command.charAt(j);
//             }
//             StringTokenizer st = new StringTokenizer(inputArr, "[],");
//             list.clear();
//             for(int j = 0; j < numOfElements; j++){
//                 list.add(Integer.parseInt(st.nextToken()));
//             }

            
//             for(int j = 0; j < charArr.length; j++){
//                 if(charArr[j] == ''R''){
//                     if(rIsOn == false) rIsOn = true;
//                     else if(rIsOn == true)rIsOn = false;
//                     }
//             else if(charArr[j] == ''D'' && list.size() - 1 >= 1 ){
//                     if(rIsOn == false)  list.remove(0);
//                     else if(rIsOn == true) list.remove(list.size()-1);
//                 }
//             else if(charArr[j] == ''D'' && list.size() - 1 < 1 ){
//                 result[i] = "error";
//                 list.clear();
//             }
//             }
//             if(rIsOn == false && list.size() != 0){
//                 String ans = "";
//                 ans += "[";
//                 for(int k = 0; k < list.size(); k++){
//                     ans += list.get(k);
//                     if(k != list.size()-1) ans += ",";
//                 }
//                 ans += "]";
//                 result[i] = ans;
//             }
//             else if(rIsOn ==true && list.size() != 0){
//                 String ans = "";
//                 ans += "[";
//                 for(int k = (list.size() -1); k >= 0; k--){
//                     ans += list.get(k);
//                     if(k != 0) ans += ",";
//                 }
//                 ans += "]";
//                 result[i] = ans;
//             }
            
//         }

//         for(int i = 0; i < result.length; i++){   
//             bw.write(result[i]+"\n");
//         }
//         bw.flush();
//         bw.close(); 
//}

//===================================2번째 덱으로 푼거
// import java.io.*;
// import java.util.*;

// public class Back_5430 {
//     public static void main(String[] args) throws IOException {
//         Deque<Integer> numDeque = new ArrayDeque<>();
//         int numOfCase = 0;
//         Boolean rIsOn = false;
//         boolean error = false;
//         BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
//         BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(System.out));
//         numOfCase = Integer.parseInt(br.readLine());
    
//         String[] result = new String[numOfCase];
//         String command = "";
//         int numOfElements = 0;
//         String inputArr = "";

//         for(int i = 0; i < numOfCase; i++)
//         {
//             numDeque.clear();
//             rIsOn = false;
//             error = false;
//             command = br.readLine();
//             numOfElements = Integer.parseInt(br.readLine());
//             inputArr = br.readLine();

//             StringTokenizer dequTokenizer = new StringTokenizer(inputArr, "[],");
//             numDeque.clear();
//             for(int j = 0; j < numOfElements; j++){
//                 numDeque.addFirst(Integer.parseInt(dequTokenizer.nextToken()));
//             }
//             for (int j = 0; j < command.length(); j++) {
// 				switch (command.charAt(j)) {
// 					case ''R'':
//                     rIsOn = !rIsOn;
// 						break;

// 					case ''D'':
// 						if (!numDeque.isEmpty()) {
// 							if (rIsOn) { // 순방향
// 								numDeque.pollFirst();
// 							} else { // 역방향
// 								numDeque.pollLast();
// 							}
// 							break;
// 						} else {
// 							error = true;
// 							break;
// 						}
// 					default:
// 						break;
// 				}

// 				// 비어있는 덱 원소 삭제 시도시
// 				if (error)
// 					break;
// 			}
//             if (error) { // 비어있는 덱 원소 삭제 시도시
// 				result[i] = "error";
// 			} 
//             else {
//                 String ans = "";
// 				ans += "[";
// 				if (rIsOn) {
// 					while (!numDeque.isEmpty()) {
// 						ans += numDeque.pollFirst();
// 						if (numDeque.isEmpty())
// 							break;
//                             ans += ",";
// 					}

// 				} else {
// 					while (!numDeque.isEmpty()) {
// 						ans += numDeque.pollLast();
// 						if (numDeque.isEmpty())1
// 							break;
//                             ans += ",";
// 					}
// 				}
// 				ans +=  "]";
//                 result[i] = ans;
// 			}
//         }

//         for(int i = 0; i < result.length; i++){   
//             bw.write(result[i]+"\n");
//         }
// 		bw.flush();
//         bw.close(); 
//     }
// }
```', '2023-02-14 20:14:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('백준 11660 구간 합구하기 5 - java', '# 구간 합 구하기 5 성공

시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 1 초 | 256 MB | 38963 | 18182 | 14020 | 45.672% |
|---|---|---|---|---|---|

## 문제

N×N개의 수가 N×N 크기의 표에 채워져 있다. (x1, y1)부터 (x2, y2)까지 합을 구하는 프로그램을 작성하시오. (x, y)는 x행 y열을 의미한다.

예를 들어, N = 4이고, 표가 아래와 같이 채워져 있는 경우를 살펴보자.

| 1 | 2 | 3 | 4 |
|---|---|---|---|
| 2 | 3 | 4 | 5 |
| 3 | 4 | 5 | 6 |
| 4 | 5 | 6 | 7 |

여기서 (2, 2)부터 (3, 4)까지 합을 구하면 3+4+5+4+5+6 = 27이고, (4, 4)부터 (4, 4)까지 합을 구하면 7이다.

표에 채워져 있는 수와 합을 구하는 연산이 주어졌을 때, 이를 처리하는 프로그램을 작성하시오.

## 입력

첫째 줄에 표의 크기 N과 합을 구해야 하는 횟수 M이 주어진다. (1 ≤ N ≤ 1024, 1 ≤ M ≤ 100,000) 둘째 줄부터 N개의 줄에는 표에 채워져 있는 수가 1행부터 차례대로 주어진다. 다음 M개의 줄에는 네 개의 정수 x1, y1, x2, y2 가 주어지며, (x1, y1)부터 (x2, y2)의 합을 구해 출력해야 한다. 표에 채워져 있는 수는 1,000보다 작거나 같은 자연수이다. (x1 ≤ x2, y1 ≤ y2)

## 출력

총 M줄에 걸쳐 (x1, y1)부터 (x2, y2)까지 합을 구해 출력한다.

```
import java.io.*;
import java.util.*;

public class Back_11660 {
    public static void main(String[] args) throws Exception{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringBuilder sb = new StringBuilder();
        StringTokenizer st = new StringTokenizer(br.readLine(), " ");   
        int numOfMatrix = Integer.parseInt(st.nextToken());
        int numOfAddCount = Integer.parseInt(st.nextToken());
        int [][] matrix = new int [numOfMatrix+1][numOfMatrix+1];

        for (int i = 1; i <= numOfMatrix; i++) {
            st = new StringTokenizer(br.readLine());
            for (int j = 1; j <= numOfMatrix; j++) {
                matrix[i][j] = matrix[i][j-1] + Integer.parseInt(st.nextToken());
            }
        }
        for (int k = 1; k <= numOfAddCount; k++) {
            int sum = 0;
            st = new StringTokenizer(br.readLine());
            int x1 = Integer.parseInt(st.nextToken());
            int y1 = Integer.parseInt(st.nextToken());
            int x2 = Integer.parseInt(st.nextToken());
            int y2 = Integer.parseInt(st.nextToken());
            for (int i = x1; i <= x2; i++) {
                sum = sum + (matrix[i][y2] - matrix[i][y1-1]);
            }
            sb.append(sum + "\n");
        }
        System.out.print(sb);
    }
}
```

이 문제는 DP로 풀어야하는 것을 알게되어', '2023-02-15 18:39:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('백준 11660 구간 합구하기 5 -DP - java', '# 구간 합 구하기 5 성공

시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 1 초 | 256 MB | 38963 | 18182 | 14020 | 45.672% |
|---|---|---|---|---|---|

## 문제

N×N개의 수가 N×N 크기의 표에 채워져 있다. (x1, y1)부터 (x2, y2)까지 합을 구하는 프로그램을 작성하시오. (x, y)는 x행 y열을 의미한다.

예를 들어, N = 4이고, 표가 아래와 같이 채워져 있는 경우를 살펴보자.

| 1 | 2 | 3 | 4 |
|---|---|---|---|
| 2 | 3 | 4 | 5 |
| 3 | 4 | 5 | 6 |
| 4 | 5 | 6 | 7 |

여기서 (2, 2)부터 (3, 4)까지 합을 구하면 3+4+5+4+5+6 = 27이고, (4, 4)부터 (4, 4)까지 합을 구하면 7이다.

표에 채워져 있는 수와 합을 구하는 연산이 주어졌을 때, 이를 처리하는 프로그램을 작성하시오.

## 입력

첫째 줄에 표의 크기 N과 합을 구해야 하는 횟수 M이 주어진다. (1 ≤ N ≤ 1024, 1 ≤ M ≤ 100,000) 둘째 줄부터 N개의 줄에는 표에 채워져 있는 수가 1행부터 차례대로 주어진다. 다음 M개의 줄에는 네 개의 정수 x1, y1, x2, y2 가 주어지며, (x1, y1)부터 (x2, y2)의 합을 구해 출력해야 한다. 표에 채워져 있는 수는 1,000보다 작거나 같은 자연수이다. (x1 ≤ x2, y1 ≤ y2)

## 출력

총 M줄에 걸쳐 (x1, y1)부터 (x2, y2)까지 합을 구해 출력한다.

```
import java.util.*;
import java.io.*;

public class Back_11660_DP {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringTokenizer st = new StringTokenizer(br.readLine());
        StringBuilder sb = new StringBuilder();
        int matrixSize = Integer.parseInt(st.nextToken());
        int numOfAddcount = Integer.parseInt(st.nextToken());
        int[][] matrixArr = new int[matrixSize+1][matrixSize+1];
        int[][] dpArr = new int[matrixSize+1][matrixSize+1];
        for (int i = 1; i <= matrixSize; i++) {
            st = new StringTokenizer(br.readLine());
            for (int j = 1; j <= matrixSize; j++) {
                matrixArr[i][j] = Integer.parseInt(st.nextToken());
            }
        }
        for (int i = 1; i <= matrixSize; i++) {
            for (int j = 1; j <= matrixSize; j++) {
                dpArr[i][j] = dpArr[i-1][j] + dpArr[i][j-1] - dpArr[i-1][j-1] + matrixArr[i][j];
            }
        }
        for (int k = 1; k <= numOfAddcount; k++) {
            st = new StringTokenizer(br.readLine());
            int x1 = Integer.parseInt(st.nextToken());
            int y1 = Integer.parseInt(st.nextToken());
            int x2 = Integer.parseInt(st.nextToken());
            int y2 = Integer.parseInt(st.nextToken());
            int ans = dpArr[x2][y2] - dpArr[x2][y1-1] - dpArr[x1-1][y2] + dpArr[x1-1][y1-1];
            sb.append(ans + "\n");
        }
        System.out.print(sb);
    }
}
```

DP로 풀어야 한다는 것을 인지하고 다른 블로그들과 책들을 참고 했다. 추후에도 Dp 문제들을 풀어 나갈 예정이다.', '2023-02-17 18:18:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('프로그래머스 올바른 괄호 Lv2 -java', '- 올바른 괄호

문제 설명

괄호가 바르게 짝지어졌다는 것은 ''('' 문자로 열렸으면 반드시 짝지어서 '')'' 문자로 닫혀야 한다는 뜻입니다. 예를 들어

- "()()" 또는 "(())()" 는 올바른 괄호입니다.
- ")()(" 또는 "(()(" 는 올바르지 않은 괄호입니다.

''('' 또는 '')'' 로만 이루어진 문자열 s가 주어졌을 때, 문자열 s가 올바른 괄호이면 true를 return 하고, 올바르지 않은 괄호이면 false를 return 하는 solution 함수를 완성해 주세요.

제한사항

- 문자열 s의 길이 : 100,000 이하의 자연수
- 문자열 s는 ''('' 또는 '')'' 로만 이루어져 있습니다.

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
            if (s.charAt(i) == ''('') {
                openCount++;
            } else if (s.charAt(i) == '')'') {
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
```', '2023-02-28 18:15:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('프로그래머스 피보나치 수 Lv2 -java', '피보나치 수
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

가 수정 코드임', '2023-03-02 19:37:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('프로그래머스 짝지어 제거하기 Lv2 -java', '- 짝지어 제거하기

문제 설명

짝지어 제거하기는, 알파벳 소문자로 이루어진 문자열을 가지고 시작합니다. 먼저 문자열에서 같은 알파벳이 2개 붙어 있는 짝을 찾습니다. 그다음, 그 둘을 제거한 뒤, 앞뒤로 문자열을 이어 붙입니다. 이 과정을 반복해서 문자열을 모두 제거한다면 짝지어 제거하기가 종료됩니다. 문자열 S가 주어졌을 때, 짝지어 제거하기를 성공적으로 수행할 수 있는지 반환하는 함수를 완성해 주세요. 성공적으로 수행할 수 있으면 1을, 아닐 경우 0을 리턴해주면 됩니다.

예를 들어, 문자열 S = baabaa 라면

b aa baa → bb aa → aa →

의 순서로 문자열을 모두 제거할 수 있으므로 1을 반환합니다.

제한사항

- 문자열의 길이 : 1,000,000이하의 자연수
- 문자열은 모두 소문자로 이루어져 있습니다.

---
입출력 예sresult

| baabaa | 1 |
|---|---|
| cdcd | 0 |

입출력 예 설명

입출력 예 #1
위의 예시와 같습니다.
입출력 예 #2
문자열이 남아있지만 짝지어 제거할 수 있는 문자열이 더 이상 존재하지 않기 때문에 0을 반환합니다.

```
import java.util.Stack;

class Solution
{
    public int solution(String s)
    {
		Stack<Character> match = new Stack<>();
		
		for (int i = 0; i < s.length(); i++) {
			char item = s.charAt(i);
			
			if(!match.isEmpty() && match.peek() == item) match.pop();
			else match.push(item);
		}

		return match.isEmpty() ? 1 : 0;
    }
}
```

괄호 스택문제들과 매우 유사하다.', '2023-03-09 00:38:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('프로그래머스 덧킬하기 Lv2 - java', '```
class Solution 
{
    public int solution(int n, int m, int[] section) {
    int answer = 0;
    int empty = section[0];
    for(int i = 0; i < section.length; i++)
    {
        if(i == 0){
            empty += m - 1;
            answer++;
        } 
        else if(i > 0){
            if(empty >=section[i]) {
            }
            else if(empty < section[i]){
                empty = section[i];
                empty += m - 1;
                answer++;
            }
        } 
        
    }
    return answer;
    }           
}
```

덧칠하기 
문제 설명 
어느 학교에 페인트가 칠해진 길이가 n미터인 벽이 있습니다. 벽에 동아리 · 학회 홍보나 회사 채용 공고 포스터 등을 게시하기 위해 테이프로 붙였다가 철거할 때 떼는 일이 많고 그 과정에서 페인트가 벗겨지곤 합니다. 페인트가 벗겨진 벽이 보기 흉해져 학교는 벽에 페인트를 덧칠하기로 했습니다. 

넓은 벽 전체에 페인트를 새로 칠하는 대신, 구역을 나누어 일부만 페인트를 새로 칠 함으로써 예산을 아끼려 합니다. 이를 위해 벽을 1미터 길이의 구역 n개로 나누고, 각 구역에 왼쪽부터 순서대로 1번부터 n번까지 번호를 붙였습니다. 그리고 페인트를 다시 칠해야 할 구역들을 정했습니다. 

벽에 페인트를 칠하는 롤러의 길이는 m미터이고, 롤러로 벽에 페인트를 한 번 칠하는 규칙은 다음과 같습니다. 

롤러가 벽에서 벗어나면 안 됩니다. 
구역의 일부분만 포함되도록 칠하면 안 됩니다. 
즉, 롤러의 좌우측 끝을 구역의 경계선 혹은 벽의 좌우측 끝부분에 맞춘 후 롤러를 위아래로 움직이면서 벽을 칠합니다. 현재 페인트를 칠하는 구역들을 완전히 칠한 후 벽에서 롤러를 떼며, 이를 벽을 한 번 칠했다고 정의합니다. 

한 구역에 페인트를 여러 번 칠해도 되고 다시 칠해야 할 구역이 아닌 곳에 페인트를 칠해도 되지만 다시 칠하기로 정한 구역은 적어도 한 번 페인트칠을 해야 합니다. 예산을 아끼기 위해 다시 칠할 구역을 정했듯 마찬가지로 롤러로 페인트칠을 하는 횟수를 최소화하려고 합니다. 

정수 n, m과 다시 페인트를 칠하기로 정한 구역들의 번호가 담긴 정수 배열 section이 매개변수로 주어질 때 롤러로 페인트칠해야 하는 최소 횟수를 return 하는 solution 함수를 작성해 주세요. 

제한사항 
1 ≤ m ≤ n ≤ 100,000 
1 ≤ section의 길이 ≤ n 
1 ≤ section의 원소 ≤ n 
section의 원소는 페인트를 다시 칠해야 하는 구역의 번호입니다. 
section에서 같은 원소가 두 번 이상 나타나지 않습니다. 
section의 원소는 오름차순으로 정렬되어 있습니다. 
입출력 예 
n m section      result 
8 4 [2, 3, 6]       2 
5 4 [1, 3]           1 
4 1 [1, 2, 3, 4]   4', '2023-03-10 21:31:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('백준 1002 터렛 -java', '# 터렛 성공

시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 2 초 | 128 MB | 184387 | 39756 | 31658 | 22.203% |
|---|---|---|---|---|---|

## 문제

조규현과 백승환은 터렛에 근무하는 직원이다. 하지만 워낙 존재감이 없어서 인구수는 차지하지 않는다. 다음은 조규현과 백승환의 사진이다.

![](https://blog.kakaocdn.net/dna/bj2azP/btr3gPOAb1P/AAAAAAAAAAAAAAAAAAAAAN8D1Om55NqEtamYuY_TvXPAJkDTfJlWXyb8mfQ-a3Q5/img.jpg?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=XCMrPc0Y67XB8gepqNYn0BtQLFo%3D)

이석원은 조규현과 백승환에게 상대편 마린(류재명)의 위치를 계산하라는 명령을 내렸다. 조규현과 백승환은 각각 자신의 터렛 위치에서 현재 적까지의 거리를 계산했다.

조규현의 좌표 (x1, y1)와 백승환의 좌표 (x2, y2)가 주어지고, 조규현이 계산한 류재명과의 거리 r1과 백승환이 계산한 류재명과의 거리 r2가 주어졌을 때, 류재명이 있을 수 있는 좌표의 수를 출력하는 프로그램을 작성하시오.

## 입력

첫째 줄에 테스트 케이스의 개수 T가 주어진다. 각 테스트 케이스는 다음과 같이 이루어져 있다.

한 줄에 x1, y1, r1, x2, y2, r2가 주어진다. x1, y1, x2, y2는 -10,000보다 크거나 같고, 10,000보다 작거나 같은 정수이고, r1, r2는 10,000보다 작거나 같은 음이 아닌 정수이다.

## 출력

각 테스트 케이스마다 류재명이 있을 수 있는 위치의 수를 출력한다. 만약 류재명이 있을 수 있는 위치의 개수가 무한대일 경우에는 -1을 출력한다.

## 예제 입력 1 복사

```
3
0 0 13 40 0 37
0 0 3 0 7 4
1 1 1 1 1 5

```

## 예제 출력 1 복사

```
2
1
0

```

## 출처

- 문제를 번역한 사람: [baekjoon](https://www.acmicpc.net/user/baekjoon)
- 문제의 오타를 찾은 사람: [baemin0103](https://www.acmicpc.net/user/baemin0103), [koyh1200](https://www.acmicpc.net/user/koyh1200)

```
import java.util.*;
import java.io.*;

public class Back_1002  {
    public static void main(String args[])throws IOException{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringTokenizer st ;
        int numOfTestCase =Integer.parseInt(br.readLine());
        double[][] posData = new double[numOfTestCase][6];
        int[] result = new int [numOfTestCase];
        double x1;
        double y1;
        double r1;
        double x2;
        double y2;
        double r2;
        double distance;

        for(int i = 0; i < numOfTestCase; i++){
            st = new StringTokenizer(br.readLine());
            for(int j = 0; j < 6; j++){
                posData[i][j] = Double.parseDouble(st.nextToken());
            }
        }

        for(int i = 0; i < numOfTestCase; i++){
            x1 = posData[i][0];
            y1 = posData[i][1];
            r1 = posData[i][2];
            x2 = posData[i][3];
            y2 = posData[i][4];
            r2 = posData[i][5];
            distance = Math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
        
            if(x1 == x2 && y1 == y2){
                //동심원인 경우
                if(r1 == r2) result[i] = -1;
                else result[i] = 0;
            }
            else{
                //동심원이 아닌경우
                if(r1 + r2 == distance) result[i] = 1;  //한접점에서 만남
                else if(r1 +r2 > distance){         
                    if(distance + r1 == r2 || distance + r2 == r1) result[i] = 1;
                    else if(r1 + distance < r2||  r2 + distance < r1 )result[i] = 0;
                    else result[i] = 2;
                }
                else if(r1 + r2 < distance) result[i] = 0;
            }
        }
        for(int i = 0; i < result.length; i++)
        {
            System.out.println(result[i]);
        }
        
    }
}
```

---', '2023-03-11 18:25:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('selection sort', '| #include void printArray(int a[], int n){     int i;     for (i = 0; i < n; i++)     {            printf("%d ", a[i]);      }      printf("\n");}int getMaxPos(int p[], int n){        int max;        int maxPos;        int i;        max = -1;        maxPos = -1;        for (i = 0; i < n; i++)        {              if (p[i] > max)              {                   max = p[i];                   maxPos = i;               }         }        return maxPos;}void swap(int* a, int* b){         int tmp;          tmp = *a;          *a = *b;           *b = tmp;}void selectionSort(int p[], int n){       int i;       int maxPos;       for (i = 0; i < 9; i++)       {            maxPos = getMaxPos(p, n -i);            swap(&p[maxPos], &p[n - 1 - i]);         }//sorting이라고 함           //phase 단계(변해가는 과정을 한 단계를 phase라고 함)}main(){       int x[10] = {38,54,67,45,89,12,29,17,82,11 };       printf("=========before sort=========\n");      printArray(x, 10);       selectionSort(x, 10);       printf("=========before sort=========\n");        printArray(x, 10);/*max = -1; // 제일 작은수 양수만 있다고 가정maxPos = -1;for (i = 0; i < 10; i++){if (x[i] > max){max = x[i];maxPos = i;}}//*///printf("max = %d, maxPos = %d\n",x[maxPos], maxPos);} |
|---|
|  |
|  |

**select  sort 선택 정렬
앞 에서 배운 swap을 이용해 위치를 바꿔 정렬하는것을 sorting 이라고 한다. 
sorting에는 다양한 방법들이 존재한다. 그 중 bubble sort, selection sort, insertion sort 순서로 쉬다고 한다. 교수님께서 위에 3가지를 먼저 익히라고 하셨다.  위 세가지 sorting  방법을 꼭 익히기 2학년 까지 눈가리고도 짤수 있어야 한다고 하셨고 그렇게 할것이다. 그럼 열심히 해야할듯 하다.**

**다른 sorting 방법중 대표적으로 quick sort, merge sort,heap sort,shell sort 이 4가지가 자주 사용한다고 하셨고 모두 공부 해야한다. 열심히 하자 **', '2022-04-13 15:10:00', 0, 1, (SELECT id FROM category WHERE name='언어/C언어' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('7576 토마토 - java', '# 토마토 성공

시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 1 초 | 256 MB | 150475 | 57073 | 36054 | 35.671% |
|---|---|---|---|---|---|

## 문제

철수의 토마토 농장에서는 토마토를 보관하는 큰 창고를 가지고 있다. 토마토는 아래의 그림과 같이 격자 모양 상자의 칸에 하나씩 넣어서 창고에 보관한다.

![](https://blog.kakaocdn.net/dna/deK0NN/btr5A3Yt931/AAAAAAAAAAAAAAAAAAAAAAsvXQkOEV0xw1dw8qtD_vWJGWnDvuJqRYRyM01obsxy/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=twn09hWUkjVBaJbp%2FoUJl2SA%2Fqc%3D)

창고에 보관되는 토마토들 중에는 잘 익은 것도 있지만, 아직 익지 않은 토마토들도 있을 수 있다. 보관 후 하루가 지나면, 익은 토마토들의 인접한 곳에 있는 익지 않은 토마토들은 익은 토마토의 영향을 받아 익게 된다. 하나의 토마토의 인접한 곳은 왼쪽, 오른쪽, 앞, 뒤 네 방향에 있는 토마토를 의미한다. 대각선 방향에 있는 토마토들에게는 영향을 주지 못하며, 토마토가 혼자 저절로 익는 경우는 없다고 가정한다. 철수는 창고에 보관된 토마토들이 며칠이 지나면 다 익게 되는지, 그 최소 일수를 알고 싶어 한다.

토마토를 창고에 보관하는 격자모양의 상자들의 크기와 익은 토마토들과 익지 않은 토마토들의 정보가 주어졌을 때, 며칠이 지나면 토마토들이 모두 익는지, 그 최소 일수를 구하는 프로그램을 작성하라. 단, 상자의 일부 칸에는 토마토가 들어있지 않을 수도 있다.

## 입력

첫 줄에는 상자의 크기를 나타내는 두 정수 M,N이 주어진다. M은 상자의 가로 칸의 수, N은 상자의 세로 칸의 수를 나타낸다. 단, 2 ≤ M,N ≤ 1,000 이다. 둘째 줄부터는 하나의 상자에 저장된 토마토들의 정보가 주어진다. 즉, 둘째 줄부터 N개의 줄에는 상자에 담긴 토마토의 정보가 주어진다. 하나의 줄에는 상자 가로줄에 들어있는 토마토의 상태가 M개의 정수로 주어진다. 정수 1은 익은 토마토, 정수 0은 익지 않은 토마토, 정수 -1은 토마토가 들어있지 않은 칸을 나타낸다.

토마토가 하나 이상 있는 경우만 입력으로 주어진다.

## 출력

여러분은 토마토가 모두 익을 때까지의 최소 날짜를 출력해야 한다. 만약, 저장될 때부터 모든 토마토가 익어있는 상태이면 0을 출력해야 하고, 토마토가 모두 익지는 못하는 상황이면 -1을 출력해야 한다.

```
import java.io.*;
import java.util.*;

public class Back_7576{
    public static class Pos {
        int pos_x;
        int pos_y;
        Pos(){
            pos_y = 0;
            pos_x = 0;
        }
        Pos(int x, int y){
            pos_x = x;
            pos_y = y;
        }
    }
    public static void main(String args[]) throws Exception{
        int days = 1;
        int matrix_x;
        int matrix_y;
        int x;
        int y;
        int[] dx = {0,1,0,-1};
        int[] dy = {1,0,-1,0};
        String buffer;
        Queue<Pos> queue = new LinkedList<Pos>();
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        buffer = br.readLine();
        StringTokenizer st = new StringTokenizer(buffer," ");
        matrix_y = Integer.parseInt(st.nextToken());
        matrix_x = Integer.parseInt(st.nextToken());
        int[][] matrix = new int[matrix_x][matrix_y];
        for(int i = 0; i < matrix_x; i++){
            buffer = br.readLine();
            st = new StringTokenizer(buffer," ");
            for(int j = 0; j < matrix_y; j++){
                matrix[i][j] = Integer.parseInt(st.nextToken());
                if(matrix[i][j]==1){
                    queue.add(new Pos(i,j));
                }
            }
        }
//      bfs Priority Queue 방식
        while(!queue.isEmpty()){
            Pos tomatPos = queue.poll();
            int yesterday =matrix[tomatPos.pos_x][tomatPos.pos_y];
            for(int i = 0; i < 4; i++){
                x = tomatPos.pos_x+dx[i];
                y = tomatPos.pos_y+dy[i];
                if(-1 < x && x < matrix_x && -1 < y && y < matrix_y && matrix[x][y] == 0 ){

                        queue.add(new Pos(x,y));
                        matrix[x][y] = yesterday + 1;
                }
            }
        }
        //독립된 토마토 검증
        for(int i = 0; i < matrix_x; i++){
            for(int j = 0; j < matrix_y; j++){
                if(matrix[i][j] > days) days = matrix[i][j];
                if(matrix[i][j] == 0) {
                    System.out.println("-1");
                    return;
                }
            }
        }
        if(days != -1) days -= 1;
        System.out.println(days);
    }
}
```

최근  알고리즘 공부 중 DP문제를 만나게 되었다. 하지만 나에게는 상당히 높은 난이도 였고 많은 부분이 이해되지 않았다.   그런 도중 함께 공부를 하던 형이 DP 문제를 접하기전에 BFS(너비 우선 탐색),DFS(깊이 우선 탐색) 을 먼저 공부하면 사고 하는 것에 도움이 된다고 해서 BFS를 풀게 되었다. BFS는 다차원 배열에서 너비를 우선해서 탐색하는 알고리즘으로 즉 그래프에서 자주 사용되는 알고리즘 중 하나이다. 그래프는 자료구조의 형태중 하나로 정점과 간선으로 이루어져있다.

이 토마토 문제를 풀기까지 나는 4일 정도 소요되었다. 물론 하루 종일 공부한것은 아니다. 여러가지 햇갈리거나 어려웠던 점들을 이야기 해볼 생각이다. 처음으로는  while문에서 queue에 들어가 있는 가지점의 인덱스를 전에 방문했는가 의 대한 조치를 해주는 과정에서 익지않은 토마토 0를 읶은 토마토 1로 바꾸는 것이 아니라 소요된 날짜와 동일한 숫자로 만들어 주면서 0이 아니면 queue에 들어가지 않게 조치 해줘었다.

두번째는 위에서 언급한 모두 읶은 토마토가 되는 최소 일수를 카운팅 해주는 작업에서 상당히 머리가 아팠다. 먼저 처음 int형 배열을 만들어 주고 그 배열에 1일차에 queue의 수를 넣어주고 날이  2일차 토마토의 수를 새어주는 식으로 만들 생각이였는데 생각보다 잘되지 않았고 각 토마토가 언제 읶었는지를 표시할려고 하다보니 결국 지금의 형태가 되었다.

다음으로는 읶은 토마토와 완전히 독립되어 있는 토마토를 확인하고 -1을 return해줘야 하는 상황을 늦게 인지하였고 이중for문을 사용하지 않을 방법을 찾던 도중 그냥 이중 for문을 사용하는 방법을 채택하게 되었습니다.

---', '2023-03-23 18:32:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('백준 7569 토마토 - java', '# 토마토 성공

 

시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 1 초 | 256 MB | 67518 | 28022 | 20498 | 41.401% |
|---|---|---|---|---|---|

## 문제

철수의 토마토 농장에서는 토마토를 보관하는 큰 창고를 가지고 있다. 토마토는 아래의 그림과 같이 격자모양 상자의 칸에 하나씩 넣은 다음, 상자들을 수직으로 쌓아 올려서 창고에 보관한다.

![](https://blog.kakaocdn.net/dna/b8xhs2/btr5Pdnv8sQ/AAAAAAAAAAAAAAAAAAAAAGaDXBAK26WFvuQNz5rkMXhCH-CAtA4qal5LAhFa_N65/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=%2BAZAn8vQ1dbKlBmyc4UWGS1jfD0%3D)

창고에 보관되는 토마토들 중에는 잘 익은 것도 있지만, 아직 익지 않은 토마토들도 있을 수 있다. 보관 후 하루가 지나면, 익은 토마토들의 인접한 곳에 있는 익지 않은 토마토들은 익은 토마토의 영향을 받아 익게 된다. 하나의 토마토에 인접한 곳은 위, 아래, 왼쪽, 오른쪽, 앞, 뒤 여섯 방향에 있는 토마토를 의미한다. 대각선 방향에 있는 토마토들에게는 영향을 주지 못하며, 토마토가 혼자 저절로 익는 경우는 없다고 가정한다. 철수는 창고에 보관된 토마토들이 며칠이 지나면 다 익게 되는지 그 최소 일수를 알고 싶어 한다.

토마토를 창고에 보관하는 격자모양의 상자들의 크기와 익은 토마토들과 익지 않은 토마토들의 정보가 주어졌을 때, 며칠이 지나면 토마토들이 모두 익는지, 그 최소 일수를 구하는 프로그램을 작성하라. 단, 상자의 일부 칸에는 토마토가 들어있지 않을 수도 있다.

## 입력

첫 줄에는 상자의 크기를 나타내는 두 정수 M,N과 쌓아올려지는 상자의 수를 나타내는 H가 주어진다. M은 상자의 가로 칸의 수, N은 상자의 세로 칸의 수를 나타낸다. 단, 2 ≤ M ≤ 100, 2 ≤ N ≤ 100, 1 ≤ H ≤ 100 이다. 둘째 줄부터는 가장 밑의 상자부터 가장 위의 상자까지에 저장된 토마토들의 정보가 주어진다. 즉, 둘째 줄부터 N개의 줄에는 하나의 상자에 담긴 토마토의 정보가 주어진다. 각 줄에는 상자 가로줄에 들어있는 토마토들의 상태가 M개의 정수로 주어진다. 정수 1은 익은 토마토, 정수 0 은 익지 않은 토마토, 정수 -1은 토마토가 들어있지 않은 칸을 나타낸다. 이러한 N개의 줄이 H번 반복하여 주어진다.

토마토가 하나 이상 있는 경우만 입력으로 주어진다.

## 출력

여러분은 토마토가 모두 익을 때까지 최소 며칠이 걸리는지를 계산해서 출력해야 한다. 만약, 저장될 때부터 모든 토마토가 익어있는 상태이면 0을 출력해야 하고, 토마토가 모두 익지는 못하는 상황이면 -1을 출력해야 한다.

```
import java.io.*;
import java.util.*;
public class Back_7569 {
    static class Pos{
        int pos_x;
        int pos_y;
        int pos_z;
        Pos(){
            pos_z = 0;
            pos_x = 0;
            pos_y = 0;
        }
        Pos(int z,int x, int y){
            pos_z = z;
            pos_x = x;
            pos_y = y;
        }
    }
    public static void main(String args[]) throws  Exception{
        int days = 1;
        int matrix_row;
        int matrix_col;
        int matrix_floor;
        int x;
        int y;
        int z;
        Queue<Pos> queue = new LinkedList<Pos>();
        int[] dx = {0,1,0,-1};
        int[] dy = {1,0,-1,0};
        int[] dz = {-1,1};

        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringTokenizer st = new StringTokenizer(br.readLine());
        //여기서 조심 하자 38번째 줄에서 3차원 matrix을 만드는 과정에서 햇갈리면 안된다
        matrix_col = Integer.parseInt(st.nextToken());
        matrix_row = Integer.parseInt(st.nextToken());
        matrix_floor = Integer.parseInt(st.nextToken());

        int[][][] tomatoBox = new int[matrix_floor][matrix_row][matrix_col];

        for(int k = 0; k < matrix_floor; k++){
            for(int i = 0;  i  < matrix_row; i++){
                st = new StringTokenizer(br.readLine());
                for(int j = 0; j < matrix_col; j++){
                    tomatoBox[k][i][j] = Integer.parseInt(st.nextToken());
                    if(tomatoBox[k][i][j] == 1){
                        queue.add(new Pos(k,i,j));
                    }
                }
            }
        }

        while(!queue.isEmpty()){
            Pos tomatPos = queue.poll();
            int yesterday =tomatoBox[tomatPos.pos_z][tomatPos.pos_x][tomatPos.pos_y];
            //같은 면 검증
            for(int i = 0; i < 4; i++){
                z = tomatPos.pos_z;
                x = tomatPos.pos_x + dx[i];
                y = tomatPos.pos_y + dy[i];
                if(-1 < x && x < matrix_row && -1 < y && y < matrix_col && tomatoBox[z][x][y] == 0 ) {
                    queue.add(new Pos(z, x, y));
                    tomatoBox[z][x][y] = yesterday + 1;
                }
            }
            //위아래 면 검증
            for(int i = 0; i < 2; i++) {
                z = tomatPos.pos_z + dz[i];
                x = tomatPos.pos_x;
                y = tomatPos.pos_y;
                if (-1 < z && z < matrix_floor && tomatoBox[z][x][y] == 0) {
                    queue.add(new Pos(z, x, y));
                    tomatoBox[z][x][y] = yesterday + 1;
                }
            }
        }
        //독립된 토마토 검증
        for(int k = 0; k < matrix_floor; k++){
            for(int i = 0; i < matrix_row; i++){
                for(int j = 0; j < matrix_col; j++){
                    if(tomatoBox[k][i][j] > days) days = tomatoBox[k][i][j];
                    if(tomatoBox[k][i][j] == 0) {
                        System.out.println("-1");
                        return;
                    }
                }
            }
        }

        if(days != -1) days -= 1;
        System.out.println(days);
    }
}
```

전 글에서 말했드 2차원 matrix문제에서 조금 변형된 3차원 matrix 문제이다. 동일하게 BFS를 사용하여 불었다. 주의 사항은 3차원 matrix를 변수 선언 시에 첫번째 인덱스가 면을 의미하고 나머지 는 동일하다는 점이다. 그저 Queue 를 검증할때 x,y값이 같은 다른 면을 한번더 검증해주기 만한다면 전과 동일하다.

---', '2023-03-26 18:00:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('b15649.java 백준  N과 M(1)', '# N과 M (1) 성공

![](https://blog.kakaocdn.net/dna/Igsfr/btr7OofHNft/AAAAAAAAAAAAAAAAAAAAAOcTV33_SrlqB1OesOQYpykFVnzyuCSWV5ni-8ORnE0T/img.jpg?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=0le6MFpWZjeAoi4%2FJ%2BRMoKKZ9iQ%3D)

시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 1 초 | 512 MB | 82751 | 52217 | 34030 | 62.312% |
|---|---|---|---|---|---|

## 문제

자연수 N과 M이 주어졌을 때, 아래 조건을 만족하는 길이가 M인 수열을 모두 구하는 프로그램을 작성하시오.

- 1부터 N까지 자연수 중에서 중복 없이 M개를 고른 수열

## 입력

첫째 줄에 자연수 N과 M이 주어진다. (1 ≤ M ≤ N ≤ 8)

## 출력

한 줄에 하나씩 문제의 조건을 만족하는 수열을 출력한다. 중복되는 수열을 여러 번 출력하면 안되며, 각 수열은 공백으로 구분해서 출력해야 한다.

수열은 사전 순으로 증가하는 순서로 출력해야 한다.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

위 문제는 백트래킹을 익히는 과정 중 가장 기초가 되는 문제이다.

```
import java.io.*;
import java.util.*;

public class b15649 {
    static int N, M;
    static int[] arr;
    static boolean[] isUsed;

    public static void main(String[] args) throws Exception {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringTokenizer st = new StringTokenizer(br.readLine());

        //Scanner sc = new Scanner(System.in); //런타임 에러

        N =Integer.parseInt(st.nextToken());
        M =Integer.parseInt(st.nextToken());

        isUsed = new boolean[N + 1];
        arr = new int[M + 1];

        back(0);
    }

    private static void back(int flow) {
        if (flow == M) {
            for (int i = 0; i < M; i++) {
                System.out.print(arr[i] + " ");
            }
            System.out.println();
            return;
        }

        for (int i = 1; i <= N; i++) {
            if (!isUsed[i]) {
                isUsed[i] = true;
                arr[flow] = i;
                back(flow + 1); // arr의 인덱스를 +1 시켜준다.
                isUsed[i] = false;
            }
        }
    }
}
```

---', '2023-04-04 01:59:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('b1926.java 백준 그림', '# 그림 성공

 

> ![](https://blog.kakaocdn.net/dna/bcvpHC/btscxnvCP27/AAAAAAAAAAAAAAAAAAAAAHIho0qyndNPxTkbCVrwDOxgTdFGPtQcRpVw4FPOme1T/img.jpg?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=a5MHW7LxJbDBAc8ABL4Dpr5uvc4%3D)

| 2 초 | 128 MB | 27726 | 11727 | 8187 | 41.073% |
|---|---|---|---|---|---|

## 문제

어떤 큰 도화지에 그림이 그려져 있을 때, 그 그림의 개수와, 그 그림 중 넓이가 가장 넓은 것의 넓이를 출력하여라. 단, 그림이라는 것은 1로 연결된 것을 한 그림이라고 정의하자. 가로나 세로로 연결된 것은 연결이 된 것이고 대각선으로 연결이 된 것은 떨어진 그림이다. 그림의 넓이란 그림에 포함된 1의 개수이다.

## 입력

첫째 줄에 도화지의 세로 크기 n(1 ≤ n ≤ 500)과 가로 크기 m(1 ≤ m ≤ 500)이 차례로 주어진다. 두 번째 줄부터 n+1 줄 까지 그림의 정보가 주어진다. (단 그림의 정보는 0과 1이 공백을 두고 주어지며, 0은 색칠이 안된 부분, 1은 색칠이 된 부분을 의미한다)

## 출력

첫째 줄에는 그림의 개수, 둘째 줄에는 그 중 가장 넓은 그림의 넓이를 출력하여라. 단, 그림이 하나도 없는 경우에는 가장 넓은 그림의 넓이는 0이다.

```
package Test;

import java.util.*;
import java.io.*;
public class b1926 {
    public static class Pos {
        int pos_x;
        int pos_y;
        Pos(int x, int y) {
            pos_x = x;
            pos_y = y;
        }
    }
    public static void main(String[] args) throws Exception{
        int numOfPaint = 0;
        int bigPaint = 0;
        int paintSizeCount =1;
        int x;
        int y;
        int paint_R;
        int paint_C;
        Pos tmpPos;
        Queue<Pos> queue= new LinkedList<Pos>();
        int[] dx = {0,1,0,-1};
        int[] dy = {1,0,-1,0};
        String buffer;
        Pos posBuffer;

        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        buffer = br.readLine();
        StringTokenizer st = new StringTokenizer(buffer," ");
        paint_R= Integer.parseInt(st.nextToken());
        paint_C = Integer.parseInt(st.nextToken());

        int[][] matrix = new int[paint_R][paint_C];
        boolean[][] isUsed = new boolean[paint_R][paint_C];

        for(int i = 0; i < paint_R; i++){
            buffer = br.readLine();
            st = new StringTokenizer(buffer," ");
            for(int j = 0; j < paint_C; j++){
                matrix[i][j] = Integer.parseInt(st.nextToken());
                if (matrix[i][j] == 0) {
                    isUsed[i][j] = true;
                }
            }
        }
        for(int i = 0; i < paint_R; i++){
            for(int j = 0; j < paint_C; j++){
                if(matrix[i][j] == 1 && !isUsed[i][j]){
                    posBuffer = new Pos(i,j);
                    queue.add(posBuffer);
                    numOfPaint++;
                    paintSizeCount =1;
                    isUsed[i][j] = true;
                    while(!queue.isEmpty()) {
                        tmpPos = queue.poll();
                        for (int k = 0; k < dx.length; k++) {
                            x = tmpPos.pos_x + dx[k];
                            y = tmpPos.pos_y + dy[k];
                            if (-1 < x && x < paint_R && -1 < y && y < paint_C) {
                                if (matrix[x][y] == 1 && !isUsed[x][y]){
                                    posBuffer = new Pos(x,y);
                                    queue.add(posBuffer);
                                    paintSizeCount++;
                                    isUsed[x][y] = true;
                                }
                            }
                        }
                    }
                    bigPaint = Math.max(bigPaint,paintSizeCount);
                }
            }
        }

        System.out.println(numOfPaint);
        System.out.println(bigPaint);
    }
}
```

이 문제는 BFS를 사용하여 푸는 문제입니다. 이 문제는 전에 플었던  토마토 문제([https://basakreview.tistory.com/40](https://basakreview.tistory.com/40))와 달리  queue에 모든 BFS시작 위치를 넣고 시작하는 것이 아닌 이중 for문을 돌면서 독립된 그룹의 개수를 파악하고 최대 너비를 가진 그룹의 크기를 알아내야 합니다.  저자는 중간에 matrix와 isUsed 두 2차원 배열의 인덱스를 혼동해서 코드 수정 과정에서 매우 힘들었다. 인덱스를 자주 사용하는 만큼 잘 확인해야한다.

---', '2023-04-24 21:14:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('b10026.java 백준 적록색약', '# 적록색약 성공다국어

> ![](https://blog.kakaocdn.net/dna/bCLIN4/btsdG4PGPzZ/AAAAAAAAAAAAAAAAAAAAAFjbjplQsEu0AZOv-7uq5E7Tk-JhpYUmPIlZ17Z5f9DI/img.jpg?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=MW8pIsun%2BgzKht1nWt3DTczIMDM%3D)

 
 
 
 
시간 제한메모리 제한제출정답맞힌 사람정답 비율

| 1 초 | 128 MB | 49598 | 28536 | 21851 | 56.518% |
|---|---|---|---|---|---|

## 문제

적록색약은 빨간색과 초록색의 차이를 거의 느끼지 못한다. 따라서, 적록색약인 사람이 보는 그림은 아닌 사람이 보는 그림과는 좀 다를 수 있다.

크기가 N×N인 그리드의 각 칸에 R(빨강), G(초록), B(파랑) 중 하나를 색칠한 그림이 있다. 그림은 몇 개의 구역으로 나뉘어져 있는데, 구역은 같은 색으로 이루어져 있다. 또, 같은 색상이 상하좌우로 인접해 있는 경우에 두 글자는 같은 구역에 속한다. (색상의 차이를 거의 느끼지 못하는 경우도 같은 색상이라 한다)

예를 들어, 그림이 아래와 같은 경우에

```
RRRBB
GGBBB
BBBRR
BBRRR
RRRRR
```

적록색약이 아닌 사람이 봤을 때 구역의 수는 총 4개이다. (빨강 2, 파랑 1, 초록 1) 하지만, 적록색약인 사람은 구역을 3개 볼 수 있다. (빨강-초록 2, 파랑 1)

그림이 입력으로 주어졌을 때, 적록색약인 사람이 봤을 때와 아닌 사람이 봤을 때 구역의 수를 구하는 프로그램을 작성하시오.

## 입력

첫째 줄에 N이 주어진다. (1 ≤ N ≤ 100)

둘째 줄부터 N개 줄에는 그림이 주어진다.

## 출력

적록색약이 아닌 사람이 봤을 때의 구역의 개수와 적록색약인 사람이 봤을 때의 구역의 수를 공백으로 구분해 출력한다.

이 문제를 다른 BFS처럼 동일한 방식으로 풀수 있다. 전에 풀었던 그림([https://basakreview.tistory.com/43)](https://basakreview.tistory.com/43) 문제에서 적록색약이라는 조건을 하나를 생각해주면 풀리게 되는데 처음에는 인텔리제이에서는 원한는데로 출력값이 잘나와서 아래의 코드를 백준에 제출하였지만 동일하게 4%에서 틀리는 현상이 발생하여 코드를 수정해 제출했다.  아래의 코드가 이중for문의 사용을 줄인 코드여서 코드 적으로 깔끔한것 같지만 백준사이트에서 반례가 존재하는 듯하다.

```
import java.io.*;
import java.util.*;

public class b10026 {
    public static class Pos {
        int pos_x;
        int pos_y;

        Pos(int x, int y) {
            pos_x = x;
            pos_y = y;
        }
    }

    public static void main(String[] args) throws Exception {
        int N;
        int x;
        int y;
        int numOfpaintR = 0;
        int numOfpaintG = 0;
        int numOfpaintB = 0;
        int numOfpaintRG = 0;
        String stringBuffer;
        int[][] paint;
        boolean[][] isUsed;
        boolean[][] isUsedGR;
        char[] charBuffer ;
        Queue<Pos> queueR = new LinkedList<>();
        Queue<Pos> queueG = new LinkedList<>();
        Queue<Pos> queueB = new LinkedList<>();
        Queue<Pos> queueRG = new LinkedList<>();
        Pos tmpPos;
        Pos posBuffer;
        int[] dx = {0, 1, 0, -1};
        int[] dy = {1, 0, -1, 0};

        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        N = Integer.parseInt(br.readLine());
        paint = new int[N][N];
        isUsed = new boolean[N][N];
        isUsedGR = new boolean[N][N];
        charBuffer = new char[N];

        for (int i = 0; i < N; i++) {
            stringBuffer = br.readLine();
            for (int j = 0; j < N; j++) {
                charBuffer[j] = stringBuffer.charAt(j);
                if (charBuffer[j]== ''R'') {
                    paint[i][j] = 1;
                } else if (charBuffer[j] == ''G'') {
                    paint[i][j] = 2;
                } else if (charBuffer[j] == ''B'') {
                    paint[i][j] = 3;
                }
            }
        }
        /*
        //주어지는 입력이 String 한줄인데 착각으로 nextToken을 받으면 각으로 끝는걸 까먹음
        for (int i = 0; i < N; i++) {
            st = new StringTokenizer(br.readLine());
            for (int j = 0; j < N; j++) {
                if (st.nextToken() == "R") {
                    paint[i][j] = 1;
                } else if (st.nextToken() == "G") {
                    paint[i][j] = 2;
                } else if (st.nextToken() == "B") {
                    paint[i][j] = 3;
                }
            }
        }
        */
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                if (paint[i][j] == 1 && !isUsed[i][j]) {
                    posBuffer = new Pos(i,j);
                    queueR.add(posBuffer);
                    numOfpaintR++;
                    while(!queueR.isEmpty()) {
                        tmpPos = queueR.poll();
                        for (int k = 0; k < dx.length; k++) {
                            x = tmpPos.pos_x + dx[k];
                            y = tmpPos.pos_y + dy[k];
                            if (-1 < x && x < N && -1 < y && y < N) {
                                if (paint[x][y] == 1 && !isUsed[x][y]){
                                    posBuffer = new Pos(x,y);
                                    queueR.add(posBuffer);
                                    isUsed[x][y] = true;
                                }
                            }
                        }
                    }
                }
                else if (paint[i][j] == 2 && !isUsed[i][j]) {
                    posBuffer = new Pos(i,j);
                    queueG.add(posBuffer);
                    numOfpaintG++;
                    while(!queueG.isEmpty()) {
                        tmpPos = queueG.poll();
                        for (int k = 0; k < dx.length; k++) {
                            x = tmpPos.pos_x + dx[k];
                            y = tmpPos.pos_y + dy[k];
                            if (-1 < x && x < N && -1 < y && y < N) {
                                if (paint[x][y] == 2 && !isUsed[x][y]){
                                    posBuffer = new Pos(x,y);
                                    queueG.add(posBuffer);
                                    isUsed[x][y] = true;
                                }
                            }
                        }
                    }
                }
                else if (paint[i][j] == 3 && !isUsed[i][j]) {
                    posBuffer = new Pos(i,j);
                    queueB.add(posBuffer);
                    numOfpaintB++;
                    while(!queueB.isEmpty()) {
                        tmpPos = queueB.poll();
                        for (int k = 0; k < dx.length; k++) {
                            x = tmpPos.pos_x + dx[k];
                            y = tmpPos.pos_y + dy[k];
                            if (-1 < x && x < N && -1 < y && y < N) {
                                if (paint[x][y] == 3 && !isUsed[x][y]){
                                    posBuffer = new Pos(x,y);
                                    queueB.add(posBuffer);
                                    isUsed[x][y] = true;
                                }
                            }
                        }
                    }
                }
                else if (((paint[i][j] == 1) ||(paint[i][j] == 2)) && !isUsedGR[i][j]) {
                    posBuffer = new Pos(i, j);
                    queueRG.add(posBuffer);
                    numOfpaintRG++;
                    while (!queueRG.isEmpty()) {
                        tmpPos = queueRG.poll();
                        for (int k = 0; k < dx.length; k++) {
                            x = tmpPos.pos_x + dx[k];
                            y = tmpPos.pos_y + dy[k];
                            if (-1 < x && x < N && -1 < y && y < N) {
                                if (((paint[x][y] == 1) || (paint[x][y] == 2)) && !isUsedGR[x][y]) {
                                    posBuffer = new Pos(x, y);
                                    queueRG.add(posBuffer);
                                    isUsedGR[x][y] = true;
                                }
                            }
                        }
                    }
                }

            }
        }
        System.out.println(numOfpaintR + numOfpaintG + numOfpaintB);
        System.out.println(numOfpaintRG + numOfpaintB);
    }
}
```

이 아래 코드는 적록색약 조건을 그냥 따로 다시 한번더 구해주는 코드이기 떄문에 크게 다르지 않지만 다시한번 차이점을 파악해볼 필요가 있다. 추후 스터디에서 코드 리뷰후에 문제점을 추가해서 기입할 예정이다.

```
import java.io.*;
import java.util.*;

public class b10026 {
    public static class Pos {
        int pos_x;
        int pos_y;

        Pos(int x, int y) {
            pos_x = x;
            pos_y = y;
        }
    }

    public static void main(String[] args) throws Exception {
        int N;
        int x;
        int y;
        int numOfpaintR = 0;
        int numOfpaintG = 0;
        int numOfpaintB = 0;
        int numOfpaintRG = 0;
        String stringBuffer;
        int[][] paint;
        boolean[][] isUsed;
        boolean[][] isUsedGR;
        char[] charBuffer ;
        Queue<Pos> queueR = new LinkedList<>();
        Queue<Pos> queueG = new LinkedList<>();
        Queue<Pos> queueB = new LinkedList<>();
        Queue<Pos> queueRG = new LinkedList<>();
        Pos tmpPos;
        Pos posBuffer;
        int[] dx = {0, 1, 0, -1};
        int[] dy = {1, 0, -1, 0};

        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        N = Integer.parseInt(br.readLine());
        paint = new int[N][N];
        isUsed = new boolean[N][N];
        isUsedGR = new boolean[N][N];
        charBuffer = new char[N];

        for (int i = 0; i < N; i++) {
            stringBuffer = br.readLine();
            for (int j = 0; j < N; j++) {
                charBuffer[j] = stringBuffer.charAt(j);
                if (charBuffer[j]== ''R'') {
                    paint[i][j] = 1;
                } else if (charBuffer[j] == ''G'') {
                    paint[i][j] = 2;
                } else if (charBuffer[j] == ''B'') {
                    paint[i][j] = 3;
                }
            }
        }
        /*
        //주어지는 입력이 String 한줄인데 착각으로 nextToken을 받으면 각으로 끝는걸 까먹음
        for (int i = 0; i < N; i++) {
            st = new StringTokenizer(br.readLine());
            for (int j = 0; j < N; j++) {
                if (st.nextToken() == "R") {
                    paint[i][j] = 1;
                } else if (st.nextToken() == "G") {
                    paint[i][j] = 2;
                } else if (st.nextToken() == "B") {
                    paint[i][j] = 3;
                }
            }
        }
        */
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                if (paint[i][j] == 1 && !isUsed[i][j]) {
                    posBuffer = new Pos(i,j);
                    queueR.add(posBuffer);
                    numOfpaintR++;
                    while(!queueR.isEmpty()) {
                        tmpPos = queueR.poll();
                        for (int k = 0; k < dx.length; k++) {
                            x = tmpPos.pos_x + dx[k];
                            y = tmpPos.pos_y + dy[k];
                            if (-1 < x && x < N && -1 < y && y < N) {
                                if (paint[x][y] == 1 && !isUsed[x][y]){
                                    posBuffer = new Pos(x,y);
                                    queueR.add(posBuffer);
                                    isUsed[x][y] = true;
                                }
                            }
                        }
                    }
                }
                else if (paint[i][j] == 2 && !isUsed[i][j]) {
                    posBuffer = new Pos(i,j);
                    queueG.add(posBuffer);
                    numOfpaintG++;
                    while(!queueG.isEmpty()) {
                        tmpPos = queueG.poll();
                        for (int k = 0; k < dx.length; k++) {
                            x = tmpPos.pos_x + dx[k];
                            y = tmpPos.pos_y + dy[k];
                            if (-1 < x && x < N && -1 < y && y < N) {
                                if (paint[x][y] == 2 && !isUsed[x][y]){
                                    posBuffer = new Pos(x,y);
                                    queueG.add(posBuffer);
                                    isUsed[x][y] = true;
                                }
                            }
                        }
                    }
                }
                else if (paint[i][j] == 3 && !isUsed[i][j]) {
                    posBuffer = new Pos(i,j);
                    queueB.add(posBuffer);
                    numOfpaintB++;
                    while(!queueB.isEmpty()) {
                        tmpPos = queueB.poll();
                        for (int k = 0; k < dx.length; k++) {
                            x = tmpPos.pos_x + dx[k];
                            y = tmpPos.pos_y + dy[k];
                            if (-1 < x && x < N && -1 < y && y < N) {
                                if (paint[x][y] == 3 && !isUsed[x][y]){
                                    posBuffer = new Pos(x,y);
                                    queueB.add(posBuffer);
                                    isUsed[x][y] = true;
                                }
                            }
                        }
                    }
                }

            }
        }
        System.out.println(numOfpaintR + numOfpaintG + numOfpaintB);

        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                if (((paint[i][j] == 1) ||(paint[i][j] == 2)) && !isUsedGR[i][j]) {
                    posBuffer = new Pos(i, j);
                    queueRG.add(posBuffer);
                    numOfpaintRG++;
                    while (!queueRG.isEmpty()) {
                        tmpPos = queueRG.poll();
                        for (int k = 0; k < dx.length; k++) {
                            x = tmpPos.pos_x + dx[k];
                            y = tmpPos.pos_y + dy[k];
                            if (-1 < x && x < N && -1 < y && y < N) {
                                if (((paint[x][y] == 1) || (paint[x][y] == 2)) && !isUsedGR[x][y]) {
                                    posBuffer = new Pos(x, y);
                                    queueRG.add(posBuffer);
                                    isUsedGR[x][y] = true;
                                }
                            }
                        }
                    }
                }
            }
        }
        System.out.println(numOfpaintRG + numOfpaintB);
    }
}
```

---', '2023-05-03 07:08:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('SQLD 합격 후기', '안녕하세요 바삭입니다. 본론부터 이야기 하면 한국데이터산업진흥원에서 주관하는 SQLD자격증은 취득했습니다

저처럼 SQLD 자격증을 취득하려고 하는 분들께 조금 도움이 될까 본 글을 쓰게 되었습니다.

![](https://blog.kakaocdn.net/dna/deRwH6/btsn0DAIZ0a/AAAAAAAAAAAAAAAAAAAAADEDKhD6Ha-8-DDVvuS1yFklpEsqKA6GuRDNV40ybaRd/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=%2BwbgN7R6ZTOhP2Z3hIqyleTR0YA%3D)

합격 기준인 60점 턱걸이로 운좋게 1회차로 통과하게 되었습니다. 저는 실질적인 준비기간은 2023년 4월부터 준비를 해서 약 2개월간 준비했습니다. 저는 컴퓨터 공학과 학생이여서 기존에 데이터 베이스를 사용해본 경험과 당시 학기중 데이터베이스 이론수업을 수강중이였습니다. 본 자격증과 관련이 없는 수업이긴 하지만 이론적인 지식을 어느정도 알고 있는 상태였습니다. 관계대수와 1과명의 지식을 알고있고 SQL를 조금 사용해본 정도의 상태에서 시작하게 되었습니다. 제가 사용한 교재는 ''이기적 SQL 개발자 이론서 + 기출문제'' 를 사용했습니다.

 

![](https://blog.kakaocdn.net/dna/A23U2/btsn27ad6js/AAAAAAAAAAAAAAAAAAAAAJQp0gkwIsYpmsyUxnxBmf6DHyY3IiQ5u8KFbaTo50Dc/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=ebtV17bA5ymvSxepTkVkeQpMQjw%3D)

저도 준비할 당시 이론서와 기출문제 2가지를 구매하면 좋다는 이야기를 듣고 2가지를 모두 구입할려 했으나 저는 기간을 널널하게 잡고 공부하고 싶어서 이론과 기출이 있는 문제집으로 공부 후 추가로 기출문제집을 구입할려고 했습니다. 그런데 막상 책을 사고 공부를 하니 이미 기출문제나 복원 문제들이 카페나 블로그 등으로 많이 구할 수 있는 점을 알게 되고 저는 PDF파일로 거의 모든 기출 문제를 풀어본거 같습니다.  그리고 저는 인프런에서 slqd 강의를 찾아보고 공부를 했습니다.

만약 자신이 sql이나 데이터 베이스의 개념을 어느정도 알고 있다면 정리본 pdf와 기출문제만으로 저는 공부해도 충분하다고 보고 있습니다. 저는 요즘 JDBC를 공부하고 있는 중이 였어서 실습을 직접 하면서 공부를 병해한 점 덕분에 이해가 조금 더 빨라던 점이 좋았습니다. 이론만을 공부한는 것보다 실습을 병행하는것을 추천드립니다.

---', '2023-07-18 11:35:00', 0, 1, (SELECT id FROM category WHERE name='일기' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('JAVA SWING GUI (With JDBC) 로그인 예제 프로그램 - 1. 로그인', '이번에 공부한 것들을 이용해서 간단한 로그인 예제 프로그램의 제작 과정과 생각들을 이야기 해볼 생각이다. 저는 현재 JAVA spring 을 공부시작 했는데 그전에 공부하던 것들을 이용해 무엇인가를 만들어 보고 싶다고 생각해 제작하게 되었다.

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
            String query = "SELECT USERPW FROM USERINFO WHERE USERID=''" +id+ "''";
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

"SELECT USERPW FROM USERINFO WHERE USERID = ''"+id+"''" 는 USERINFO테이블에서 USERID가 id 와 동일한 것을 찾아 USERPW를 보려라 라는 의미로 찾은 USERPW를 하나 씩 pw와 비교하 같으면 flag 를 true로 반환하는 과정으로 로그인 기능을 구현하였다.

추후에 추가로 다른 기능에 대한 이야기도 기재할 예정이다.

아래의 깃허브 를 참고 하면 도움이 될 것 이다.

[https://github.com/BaSak0630/BaSak-Login](https://github.com/BaSak0630/BaSak-Login)

---', '2023-07-19 15:30:00', 0, 1, (SELECT id FROM category WHERE name='JAVA' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('JAVA SWING GUI (With JDBC) 로그인 예제 프로그램 -2.JDBC 연결', '전에 글 이후로 JDBC연결에 대해서 이야기 할 것이다.  1.로그인 기능을 보지 않았다면 보고 것을 추천한다.

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
            //String checkingStr = "INSERT INTO USERINFO values (0000000003,''userid3'',''userpw3'',''userid@gmail.com'',''이시현'')";
            String checkingStr = "SELECT USERPW FROM USERINFO WHERE USERID=''" +id+ "''";
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
            //String checkingStr = "INSERT INTO USERINFO values (0000000003,''userid3'',''userpw3'',''userid@gmail.com'',''이시현'')";
            String checkingStr = "SELECT USERPW FROM USERINFO WHERE USERID=''" +id+ "''";
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

---', '2023-07-22 16:27:00', 0, 1, (SELECT id FROM category WHERE name='JAVA' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('JAVA SWING GUI (With JDBC) 로그인 예제 프로그램 - 3. DB연결', '이 글에서는 제가 JAVA 응용프로그램에 DB를 연결하는 과정에 대해서 이야기 해볼생각이다. 본 글의 저자는 아직 배우고 있는 단계이기 때문에 문제가 있거나 더욱 좋은 방식이 존재한다면 댓글로 이야기 해주시면 공부에 더욱 도움이 될 것이라 기대된다. 본 글을 보기 이전에 전의 글들을 보는 것을 추천한다.

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
            /*String query ="INSERT INTO USERINFO values (USER_SEQ.NEXTVAL,''"+userID+"'',''"+userPW+"'',''"+userEmail+"'',''"+userName+"'')";
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
            String query = "SELECT USERID FROM USERINFO WHERE USERID =''"+id+"''";
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

executeQuery 함수를 사용하는 방법입니다.', '2023-07-24 18:52:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('백준 알고리즘-C-2562번:최댓값', '**2562번:최댓값**

문제
9개의 서로 다른 자연수가 주어질 때, 이들 중 최댓값을 찾고 그 최댓값이 몇 번째 수인지를 구하는 프로그램을 작성하시오.
예를 들어, 서로 다른 9개의 자연수
3, 29, 38, 12, 57, 74, 40, 85, 61
이 주어지면, 이들 중 최댓값은 85이고, 이 값은 8번째 수이다.

입력
첫째 줄부터 아홉 번째 줄까지 한 줄에 하나의 자연수가 주어진다. 주어지는 자연수는 100 보다 작다.

출력
첫째 줄에 최댓값을 출력하고, 둘째 줄에 최댓값이 몇 번째 수인지를 출력한다.

| #include <stdio.h>int getMax(int p[],int n){       int max;       int maxPos;        int i;        max = -1;        maxPos = -1;        for(i = 0; i < n; i++)        {               if(p[i] > max)               {                    max = p[i];                    maxPos = i;              }        }        return maxPos;}main(){        int a[9];        int i;        int maxPos;        for(i = 0; i < 9; i++)       {               scanf_s("%d",&a[i]);               if(a[i]<0 || 100 <a[i])//조건              {                    scanf_s("%d",&a[i]);               }        } maxPos = getMax(a,9); printf("%d\n",a[maxPos]); printf("%d\n",maxPos+1);} |
|---|

배열의 최댓값과 최댓값의 자리를 찾을 때 앞전에 배운 select sorting에서 방법을 이용해 문제를 해결했습니다.

개인적으로 이 문제에서 한번더 생각해야한는 것은 maxPos를 출력해줄때 배열의 자릿값은 0부터 시작하기 때문에 1을 더하여 출력해주어야 우리가 생각하는 1부터 시작하는 자리값을 얻을 수 있다.

아직 저는 함수를 만들고 이용하는 것에 있어 미숙하기 때문에 계속 사용하며 익숙해지려 한다.

지금 시험주라 백준을 잘 안풀고 있지만 끝나면 꾸준히 백준을 풀어 github와 블로그에 글을 작성하겠습니다.', '2022-04-20 19:41:00', 0, 1, (SELECT id FROM category WHERE name='알고리즘' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('JAVA Spring API - 조회 API 지연 로딩과 성능 최적화', '김영한님의 실전! 스프링 부트와 JPA 활용 2 - API 개발과 성능 최적화 편을 공부하는 과정중 나의 생각을 정리하는 목적을 가지고 있다.

xToOne(ManyToOne,OneToOne)관계에서 성능 최적화

```
    @GetMapping("/api/v1/members")
    public List<Member> membersV1(){
        return memberService.findMembers();
    }
```

위 코드에 경우 엔티티가 직접 노출되게 된다. 하지만 협업에서는 엔티티를 직접 노출하면 안되다. 그리고 array를 넘겨주기 때문 확장성이 떨어진다.

별도의 DTO나 Request,Response객체를 만들어 엔티티를 숨기고 내가 원한 스펙 엔티티의 정보를 담아 보낼 수 있게 만들어 주어야 한다.  아래는 내가 진행하는 프로젝트의 일부 코드이다.

```
    @GetMapping("/facilitys")
    public Result facilitys(){
        List<FacilityDto> collect = facilityService.findAll().stream()
                .map(f -> new FacilityDto(f.getFcltCd()))
                .collect(Collectors.toList());
        //for사용해도 무방

        return new Result(collect);
    }

    @Data
    @AllArgsConstructor
    static class Result<T> {
        private T data;
    }

    @Data
    @AllArgsConstructor
    static class FacilityDto{
        String fcltCd;
    }
```

그리고 본 예제 프로그램에서는 Member가 Orders를 가지고 있으면선 Orders의 Order또한 Member을 가지고 있어 서로 양방향 연관관계를 가지고 있어 양방항 연관관계의 문제가 생겨 JSON의 문제가 생기게 된다. 그러서 둘 중 하나는  @JsonIgnore 해주어야 무한으로 JSON을 생성하지 않게 된다.

```
    @JsonIgnore//양방형 관계에서 둥중하는 JsonIgnore 해주어야한다.
    @OneToMany(mappedBy = "member")  //mappedBy는 보여지는 거울이라고 명시
    private List<Order> orders = new ArrayList<>();
```

지연 로디 (LAZY)를 피하기 위해서 즉시로딩(EARGER)으로 설정하면 안된다.즉시 로딩 떄문에 연관관계가 필요 없는 경우에도 데이터를 항상 조회해서 성능문제가 발생할 수 있다. 즉 성능 튜닝이 어려워 지기 때문이다.

항상 지연로딩을 기본으로 하고, 성능 최적화가 필요한 경우 패치 조인(fetch join)을 사용해야 한다. <- 본내용은 이후에 추가 글 에서 확인', '2024-03-31 18:12:00', 0, 1, (SELECT id FROM category WHERE name='JAVA/JAVA SPRING' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('오늘은 4학년 마지막 MT 틀리딱딱', '어제 부터 1일 1포스트을 마음먹었다. 하지만 오늘  mt라는 사실을 망각하고 있었다.  부산 경찰청 과 한국 수자원공사를 가고 현재는 양산 베네치아이다. 내일부터 개발관련 포스팅을 찾아 뵙겠습니다', '2024-04-01 17:21:00', 0, 1, (SELECT id FROM category WHERE name='일기' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('BITs - 테크톡', '이번 학기부터  제가 회장으로 있는 동아리 그린비에서 BITs라는 부산 대학들의 IT 연합동아리에 합류하게 되었습니다. BITs는 지금 현재 6개의 동아리가 함께 운영되고 있습니다. 부산외국어대학교 그린비,멋쟁이사자처럼 부산대 APPTIVE, PULSE 부경대 WAP 동아대 DSIS가있습니다. 앞으로 부산지역 개발 커뮤니티성 연합동아리가 되는것이 목표입니다. 그 과정 중 일보인 24년도 BITs 첫 대면 행사를 그린비가 주최하게 되었다. 다른 동아리를 초청하는 행사 진행하는 것이 처음이라 모르는 점이 많았지만 주변에서 많이 도와주셔서 테크톡을 잘 마무리 할 수 있었습니다.

[더보기]()

BITs 노션 : [https://busanitsociety.notion.site/Busan-IT-Student-Society-fd254844f36247a49ca4f1762d03ae15](https://busanitsociety.notion.site/Busan-IT-Student-Society-fd254844f36247a49ca4f1762d03ae15)

[더보기]()

테크톡 기획안 : [https://wind-confidence-a5b.notion.site/a8ff8fb74bb14002b8f4c044f3fd76b4](https://wind-confidence-a5b.notion.site/a8ff8fb74bb14002b8f4c044f3fd76b4)

이번 테크톡은 3개의 동아리 그린비,멋쟁이사자처럼,WAP이 참여 하였다. 총 인원 30명의 행사였고 테크톡과 네트워킹 행사를 함께 진행했으며 개발자를 목표로 하는 사람들이 한곳에 모여 이야기하는 소통의 장이 되어서 너무나 좋았다. 이번 행사를 기획하고 진행하면서 부산외국어대하교 멋쟁이 사자처럼에서 정말 많은 것을 도와주시고 연합동아리에 부경대 WAP와 부산 APPTIVE 운영진분들께서도 조언해주셔서 다시한번 감사인사를 하고 싶습니다. 그린비가 코로나 이후로 많은 것들이 축소되었지만 다시 많은 활동들을 할 수 있게 따라와주는 후배들과 동기들에게도 너무 고맙습니다. 앞으로 더욱 발전하는 그린비가 될 수 있도록 노력하겠습니다. 많은 관심과 응원 부탁드립니다.

개인적인 감상은 크게 두가지이다. 첫번째는 나와 같이 백엔드를 공부하면 서버개발자를 목표로 가진 사람을 만나고 이야기할 수 있어 좋았고 두번쨰는 다들 정말 열심히 하는구나 하고 더욱 더 자극을 받게 되었습니다.', '2024-04-09 01:26:00', 0, 1, (SELECT id FROM category WHERE name='활동' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('지금까지 잘못 알고 있었던 JAVA Construct의 super();', '이야기의 시작은 동아리실에서 함께하는 동기가 나에게 정보처리기사 필기 기출 문제를 보여주게 되면서 시작되었다.

문제는 23년도 3회차 20번 문제인데 내가 가지고 있는 시나공 기출문제집과는 다른 코드의 문제였다. 그 코드는 다음과 같다.

```
//자바로 작성된 아래 코드의 실행 결과를 쓰시오.
class Parent {
    int x = 100;
    Parent() {
        this(500);
    }
    Parent(int x) {
        this.x = x;
    }
    int getX() {
        return x;
    }
}
class Child extends Parent {
    int x = 4000;
    Child() {
        this(5000);
    }
    Child(int x) {
        this.x = x;
    }
}

public class Main {
    public static void main(String[] args) {
        Child obj = new Child();
        System.out.println(obj.getX());
    }
}
```

**문제를 쉽게 풀었다면 이 글이 굉장히 바보같아 보이겠지만 지금와서 보면 내가 봐도 그렇게 보여서 부정하진 않겠다.**

나를 포함한 컴퓨터공학과 동기 4인은 모두 당연하게 답을 100 이라고 생각했다. 하지만 위 코드의 결과값은 500 이 출력된다.

나는 이해가 되지 않았다. 상속의 상위객체의 생성자의 실행코드가 없어 상위 클래스 즉, super클래스에게 상속받은 데이터 멤버가 생략되어 있지만 Child obj 레퍼런스가 인스터스를 생성할 때 2개의 x(부모클래스로 부터 받은 x 를 p.x라고하고 자식 클래스의 x를 c.x라고 지칭하겠다.)가 각각 p.x 는 100이되고 c.x 는 4000이 되고 생성자가 실행되어 c.x만 5000으로 변경되어 obj.getX(); 의 결과는 p.x 100 이 출력될 것 이라 예상하였다. 물론 당연하다고 필자가 바보같아 보일 수 있다. 하지만 나와 같은 동아리이면서 함께 웰체크 프로젝트를 진행하고 있는 이 친구와는 이해를 못하면 그냥 넘어가질 못하는 전형적인 공부 못하는 놈들의 습관이 갑자기 또 발동되어 둘이서 흥분해서 원인을 분석하기 시작했다. 그도 그럴게, (김교수님의 수업을 통해) 자바에 대해선 웬 만큼은 잘 알고 특히 이런 문제에 자신있는 사람들였기 때문이다.

### 첫 번째 논제 : this()를 실행했는데 왜 super()가 실행되는가?

출력 결과가 500 이라는 것은 즉, Parent 클래스의 생성자가 실행되었다는 것이다. 하지만 보다시피 어딜 봐도 super()를 실행하는 코드는 없다.
모두 한참 고민한 결과 첫 번째로, 다음과 같은 설득력 있는 가설로 종합되었다.

> 가설 1.
> 먼저, 모두 알다시피 자식 클래스 객체(인스턴스)에는 부모 클래스 객체의 데이터 멤버가 할당된다. 따라서 Child 객체를 생성 할 때, "Child 객체가 가지는 Parent 클래스의 데이터 멤버를 할당해주기 위해" 상속관계를 확인하고 따라가서 Parent 클래스의 생성자도 호출되는 것이다

> 증명 시도 1)
> 위 가설에 따르면 Child 클래스의 생성자가 먼저 실행되고, 그 다음에 Parent 클래스의 생성자가 실행되어야 한다. 따라서 위 문제의 각 생성자에 출력문을 넣어서 디버깅 해 보았다.
> 하지만
>  
> 예상과는 다르게 Parent 클래스의 생성자부터 실행되었다. Parent 클래스의 생성자가 호출되는 것 조차도 이해할 수 없는데, 호출 순서도 Parent 클래스부터 되니 상당히 황당했다. (후술하겠지만 참고로 사실 이 때의 디버깅 방식은 잘 못 되었었다.)
> 증명 시도 2)
> 그래서 두 번째로, Parent 클래스의 데이터 멤버를 제거해주고 실행해 보았다. 그렇다면 위 가설에 따라 Parent 클래스의 데이터 멤버를 할당해 줄 필요가 없으니 Parent의 생성자는 호출되지 않아야 했지만, 출력 결과는 이 전과 마찬가지로 Parent의 생성자부터 호출되고 있었다.
> -> 따라서 첫 번째 가설은 틀렸다는 것을 알게 되었다.

### 두 번째 논제 : 그렇다면 왜 부모 클래스의 생성자부터 호출되나?

super()가 호출되는 이유는 차치하고서라도, Child 객체를 Instantiation하는 코드를 실행했는데 뜬금없이 Parent 클래스의 생성자부터 호출되는 이유는 또 대체 무엇인가?
여기선 정말 답이 안 보였다. 그러던 중 위 4인 중 한 명인, 김 모 학생의 창의적인 발상이 유력한 가설로 채택되었다.

> ****가설 2.**
> 콜 스택(Call Stack)에 Child 클래스의 생성자, Parent 클래스의 생성자 순서로 호출되어 저장되었다가, Stack 로직에 따라 거꾸로 Parent 클래스의 생성자 함수부터 pop() 되어 실행되었다는 것이다.**

![](https://blog.kakaocdn.net/dna/bOIqb1/btsGI7cwRE9/AAAAAAAAAAAAAAAAAAAAAJo6Q9GA6pezL2KFKc6PNg87yi3LXY4IHohsmfC4YMNN/img.jpg?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=1wsEBGRJDatdA1FgKfTWnEJiB8Y%3D)
콜스택의 가설을 그림으로 표현함(ㄱㅈㅅ)

(김 모 학생이 열심히 설명한 흔적이다. 구두로 함께 설명하여 알아보긴 어렵지만 기념으로 첨부한다.)

모두 감탄하며 해당 의견에 공감하는 뜻을 표했다. 하지만 결국 왜 부모 객체의 생성자가 실행되는지의 의문은 해결 되지 않았다고 생각했다.  한가지 의견은 ㅇㅎㅅ의 의견은 생성자를 무한히 호출하여 메모리 오버플로우를 유도해서 콜 스택을 터뜨려 보자는 것이었다. 하지만 순서를 확인하지 못하는데 그게 무슨 의미가 있냐며 내가 반문하게되었다. 두 번째로는 역시 최후의 수단으로 콜 스택을 직접 까(?)보는 방법을 찾아보려고 했다. 하지만 어떤 방법으로 시도해야하는지 감조차 오지않았다. 그러던 중 나는 위의 문제에서 더 나아가, 여러 단계에 걸쳐 상속받은 경우의 Constructor 실행 순서를 테스트한 결과 최상위 클래스의 Constructor 부터 순차적으로 실행된다는 사실을 확인하였다. 나는 사실 우연에 의한 결과가 아닐까 라고도 생각했지만 분명한 논리적인 이유가 있다는 사실을 확인한 순간이었다.

또한 이럴게 아니라, 작년에 수업내용을 필기한 자료나 보유중인 서적을 확인해보자는 의견이 (놀랍게도) 이제서야 나왔고 ㅇㅎㅅ이 처음 혼자서 자바를 공부할 때 사용했던 책인 ''이것이 자바다''에서 1번 논제와 2번 논제에 대한 해답을 찾게 되었다.

> 1번 논제, 2번 논제에 대한 해답
> 책의 내용을 인용하면 다음과 같다."부모 생성자는 자식 생성자의 맨 첫 줄에 숨겨져 있는 super()에 의해 호출된다."
> - 이것이 자바다 289p

이에 따르면, 위 문제에서 this(5000)가 호출되기 전에 숨겨져 있는 super()가 먼저 실행된다는 것이다.
(미리 말하면, 책의 내용은 이상이 없음에도 불구하고 이 서술은 잘 못 되었다. 이는 세 번째 논제의 이야기를 통해 알 수 있다.)

```
Child(){
	//super();	숨겨져 있던 super()가 먼저 실행됨! (라고 생각했다)
    this(5000);
}
```

덧붙이면, 정확히는 super()는 컴파일 과정에서 자동으로 추가된다고 한다.
이 내용을 적용해 보니 문제의 출력 값도 정답대로 500이 나오고, 지금까지 언급한 모든 문제들의 아귀도 들어맞아 해결되었다고 생각했다. 하지만 여기서 또 문제가 발견되었다. **하지만 위에 코드는 틀렸다.** 그이야기는 아래에서 이어서 하겠다.

### 세 번째 논제 : 그럼 왜 super(); this(); 는 컴파일 오류가 뜨느냐?

![](https://blog.kakaocdn.net/dna/bOWBad/btsGH3PfqDR/AAAAAAAAAAAAAAAAAAAAAFjhvX-rbmS7Bm9d3uymbf0JxaabfjL0cfQWNr7PUKS3/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=RM%2BIwfr2vEOgK5JG0QCPb%2FGpc1s%3D)

현재 문제는 2번의 상황이라고 할 수 있다. 적힌대로 숨겨진 super()가 실행되고 this()가 실행된다면, 3번과 같이 super()를 직접 명시해주어도 똑같은 일 일 것이다. 따라서 이를 증명하고자 실행해 봤더니, 황당하게도 컴파일에러가 발생했다. 아니 2번은 되면서 3번은 왜 컴파일 에러가 뜨는 것인가?

이에 대한 가설은 다음과 같았다.

> **가설 3.**
> super()와 this() 모두 생성자를 호출하는 함수이므로, 숨겨진 super()를 실행하고 this()를 실행하는 것이 아니라, 숨겨진 super() **대신에** this()가 호출 된다는 것이다.

> 증명시도 1)
> 위 가설이 맞다면, 다음 코드를 통해 증명할 수 있다고 생각했다.
> 
> 
> ```
> class aaa {
>    aaa(){
>       System.out.printf("aaa ");
>    }
> }
> class bbb extends aaa {
>    int b;
>    bbb(){			//첫번째로 호출
>       this(10);
>       System.out.printf("bbb ");
>    }
>    bbb(int x){		//두번째로 호출
>       this("input ");
>       b = x;
>       System.out.printf("this ");
>    }
>    bbb(String s){	//세번째로 호출
>       //super();
>       System.out.printf(s + " ");
>    }
> }
> class Test3 {
>    public static void main(String args[])
>    {
>       bbb b = new bbb();
>    }
> }
> ```
> 
> 
> 가설에 따른 이 코드의 로직은
> 먼저 bbb()가 호출되고, 해당 생성자에 숨겨진 super()는 this(10)로 대체되어 두번째 생성자가 호출되고, 두번째 생성자에 숨겨진 super()는 this("input")으로 대체되어 세번째 생성자가 호출되고, 세번째 생성자에 숨겨진 super()가 호출될 것이다. 그리고 super()가 실행되어 aaa를 출력한 후, 돌아가면서 순서대로 print문을 출력할 것이다.
> 실행 결과 aaa input this bbb 가 나옴으로써 해당 가설이 증명되었다. (감격)

> ### 3번 논제에 대한 해답
> 
> 
> 숨겨진 super()를 실행하고 this()를 실행하는 것이 아니라, 숨겨진 super() 대신에 this()가 호출 된다, 즉 3번 가설이 곧 해답이다.

> ## 결론
> 
> 
> ### 1. 모든 Constructor에는 첫 번째 Line에 super()가 숨겨져 있다.
> 
> 
> ### 2. this()를 사용하면 super()와 치환된다.

본 결론에 따라 지금까지 언급한 모든 문제(정처기 문제, 정처기 문제에서의 생성자 호출 순서, 여러번에 걸쳐 상속받은 클래스의 생성자 호출 순서, 마지막 3번 가설)들이 해결되었다. **우리들이 이문제를 틀리게 된 이유를 집어보면 결론에서 this()를 상용하면 super()를 치환하게 된다는 사실만 인지한 생태로 문제를 풀었기 때문이다. **

우리가 평소에 작성하고 사용하는 코드 들은 상속을 받은 객체의 데이터 멤버과 하위 객체의 데이터 멤버를 생성하는 과정에서 대부분의 데이터 멤버를 초기화를 해주었기 때문 더욱 더 인지 하지 못했던 것 같다. this()는 자주 사용하면서도 this()안에 super()를 인지 못했던 이유를 다시 생각해보면 super()를 실행하여도 다시 생성자에서 초기화해 주어서 필자가 그것을 인지 못했던 것 같다.

우리는 하던 공부도 다 때려치고 이걸로 토론하며 원인을 찾아가는 과정도 재밌었다. 일전에도 이렇게 까지는 아니였지만, 함수와 메서드의 차이라던가, 메인 함수가 static 메서드로 선언되는 이유같은 재미있는 주제로 이야기를 자주한 또 이런 형태의 문제를 만나면 또 글을 쓸예정이다. 이글은 우리들이 생각한 과정을 동기인 ㅇㅎㅅ이 글로 정리한 것을 토대로 다시 나의 블로그에 작석한 글임을 알리는 바이다.

본 정처기 문제의 코드를 한 번 리뷰해 보자면, 변수 명을 중복해서 사용한 것도 문제지만 가장 큰 문제는 변수 값의 초기화와 super() 메서드 호출을 상당히 해괴한 방식으로 하고 있다는 것이다. 상위 객체에 대한 초기화 작업을 알기 쉽도록 평범하게 해준다면, 왠만하면 이런 문제를 겪진 않을 것 같다는 이야기를 했다.

![](https://blog.kakaocdn.net/dna/7S77l/btsGIUYHZj9/AAAAAAAAAAAAAAAAAAAAAEKumA0fp6GMsFiGtnwrnnt5u5KVLcUuZUg6kgBleFOT/img.jpg?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=0bHiYpQBkhZO9IaxFSxXfnIxm3M%3D)

---', '2024-04-17 20:42:00', 0, 1, (SELECT id FROM category WHERE name='JAVA' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('JAVA 프로그래밍 언어 플랫폼 내용 정리', '후배가 나에게 자바를 어디까지 공부해야하는지를 나에게 물어보게 되었고 그것을 설명하던 중 나도 정확하게 용어와 내용이 잘 정리되지 않아 과거 정리해준 김태균 교수님 전공수업 내용과 구선생님(구글) 찾아 이 글로 정리하게 되었다.

먼저 내용은 아래와 같다

1. 표준 에디션의 자바 플랫폼 (Java SE)
2. 엔터프라이즈 에디션의 자바 플랫폼 (Java EE)
3. Java ME

## Java SE(Standard Edition)

가장 기본적인 자바 플랫폼을 의미한다. 흔히 자바 언어라고하는 대부분의 패키지가 포함된 에디션이라고 생각하도 좋다

- Java SE의 API는 자바 프로그래밍 언어의 핵심기능들을 제공

- 기본적인 문법
- 기초적인 class
- 네트워킹
- 보안
- 데이터베이스 처리
- 그래픽 사용자 인터페이스 개발
- XML파싱

가상머신, 개발도구, 배포기술, 부가 클래스 라이브러리, 툴킷 등 제공한다.

## Java EE(Enterprise Edition)

Java EE 플랫폼은 Java SE 플랫폼을 기반으로 그 위에 탑재된다. 웹 프로그래밍에 필요한 기능을 다수 포함 프레임워키에서 사용하는 기능들이 관련된 api들이다.

- JSP, Servlet, JDBC, JNDI, JTA등 (JNDI,JTA는 정확하게는 모름)

- 대규모, 다계층, 확장성, 신뢰성, 보안 네트워킹 API등을 제공

## Java ME(Micro Edition)

- Java ME는 모바일 폰과 같은 자바 프로그래밍 언어 기반의 어플리케이션이 보다 조그만 가상 머신으로 동작시킬 수 있는 기능 API제공
- Java EE처럼 Java SE를 기반으로 함
- 작은 장치에서 동작하는 전용 클래스 라이브러리들을 제공
- Java EE서비스의 클라이언트 역할을 하기도 함

ME 는 본격적으로 사용해본 경험은 없다.', '2024-06-08 21:35:00', 0, 1, (SELECT id FROM category WHERE name='JAVA' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('Dailelog 개발 시작', '개인적인 프로젝트로 나만의 블로그 글을 적고 기록하는 서비스를 만들어야 겠다는 생각을 예전부터 하였다. 그래서 조금조금씩 공부하면 모르는 부분을 채워나가며 나와 함께 성장할 서비스를 만들 계획이다. 그 프로젝트의 이름은 ''Dailelog'' 이다. 나의 영어이름인 Daile의 블로그라는 뜻으로 지금현재 목표는 블로그처럼 글을 작성하고 조회하는 사이트를 만들어 나갈 예정이다. 3 Tier Application 만들어 갈 에정이다. 옛날부터 나만의 서비스를 만들어 나가는 게 목표였고 이 프로젝트가 그시작인 셈이다. 많은 관심 부탁한다. 내가 최근에 가지 데브옵스 (클라우스 ,인프라) 개발자가 되기위해 공부하는 과정이라 생각한다. 일단 원래 공부하고 있던 Spring boot를 이용해 백엔드를 구축해 나갈 것이다.  그후 프론트와 배포 공부도 해서 실제 트래픽이 있는 사이트를 만들 것이다.

백엔드 repository

**[https://github.com/BaSak0630/Dailelog](https://github.com/BaSak0630/Dailelog)**', '2024-06-12 00:39:00', 0, 1, (SELECT id FROM category WHERE name='Dailelog' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('application.yml 커스텀 설정값 사용', '나는 Spring 에서 설정파일 형식을 YAML의 확장자인 .yml을 사용한다.

### YAML이란

<aside> 💡 YAML은 사람이 읽을 수 있는 데이터 직렬화 언어로서, 구성 파일 작성에 자주 사용됩니다. YAML을 yet another markup language로 생각하는 사람도 있고, YAML ain’t markup language(재귀 약어)로 생각하는 사람도 있습니다. 후자는 YAML이 문서가 아닌 데이터용임을 강조하는 말입니다.

</aside>

우리는 Spring, DB등 다양한 설정 정보를 application.yml 파일에서 관리한다. 설정을 직접 구성하고 사용할 수 있도록 커스텀이 가능하다. 어떤 식으로 사용할 수 있는 알아보자.

### 기본 - 간단한 커스텀 설정을 만들어 보자

```
daile:
  hello: "world"

```

daile라는 값이 있고 그안에 hello 라는 식별자에 값이 “world”가 들어가 있는 상태이다. 이것을 SpringApplication이 뜰때 설정 작업파일에 인젝션을 시켜주어야 한다.

AppConfig

```
@Data
@ConfigurationProperties(prefix = "daile")
public class AppConfig {
    public String hello;
}

```

daile를 prefix 하는 값을 가지고 동일 식별자와 변수명에 “world” 값이 주입되게 됩니다. 그런데 Spring 이 뜰때 @ConfigurationProperties이 제대로 작동하여 값이 주입될 수 있도록 알려줘합니다.

SpringApplication

```
@EnableConfigurationProperties(AppConfig.class)
@SpringBootApplication
public class DailelogApplication {

    public static void main(String[] args) {
        SpringApplication.run(DailelogApplication.class, args);
    }

}

```

SpringApplication에 위 코드 처럼 @EnableConfigurationProperties(AppConfig.class) 같이 주입시켜주게 명시해주거나 AppConfig 파일에 @Configuration 어노테이션을 달아주어야 한다.

또한 단순 String 뿐 아니라 다양한 형태의 자료형도 사용이 가능하다.

### 활용 - List

```
daile:
  hello: 
    - "a"
    - "b"
    - "c"
    - "d"

```

AppConfig

```
@Data
@ConfigurationProperties(prefix = "daile")
public class AppConfig {
    public List<String> hello;
}

```

### 활용 - Map

```
daile:
  hello:
    name: "daile"
    home: "busan"
    hobby: "programming"

```

AppConfig

```
@Data
@ConfigurationProperties(prefix = "daile")
public class AppConfig {
    public Map<String,String> hello;
}

```

### 활용 - 별도의 클래스

```
daile:
  hello:
    name: "daile"
    home: "busan"
    hobby: "programming"
    age: 25

```

AppConfig

```
@Data
@ConfigurationProperties(prefix = "daile")
public class AppConfig {

    public Hello hello;

    @Data
    public static class Hello {
        public String name;
        public String home;
        public String hobby;
        public Long age;
    }
}

```

이렇게 다양한 활용이 가능하다. 제대로 사용하기 위해서 build.gradle 에 아래 내용을 추가하면

```
annotationProcessor "org.springframework.boot:spring-boot-configuration-processor"

```

bulid.classes.java.main.META-INF 파일에 아래의 json 형태와 spring-configuration-metadata라는 이름으로 새부내용이 작성 된다. 그리고 인텔리제이가 관련 정보를 가지고 있게 된다.

```
{
  "groups": [
    {
      "name": "daile",
      "type": "com.dailelog.config.AppConfig",
      "sourceType": "com.dailelog.config.AppConfig"
    },
    {
      "name": "daile.hello",
      "type": "com.dailelog.config.AppConfig$Hello",
      "sourceType": "com.dailelog.config.AppConfig"
    }
  ],
  "properties": [
    {
      "name": "daile.hello.age",
      "type": "java.lang.Long",
      "sourceType": "com.dailelog.config.AppConfig$Hello"
    },
    {
      "name": "daile.hello.hobby",
      "type": "java.lang.String",
      "sourceType": "com.dailelog.config.AppConfig$Hello"
    },
    {
      "name": "daile.hello.home",
      "type": "java.lang.String",
      "sourceType": "com.dailelog.config.AppConfig$Hello"
    },
    {
      "name": "daile.hello.name",
      "type": "java.lang.String",
      "sourceType": "com.dailelog.config.AppConfig$Hello"
    }
  ],
  "hints": []
}

```

application.yml 커스텀 설정값 사용', '2024-06-12 05:22:00', 0, 1, (SELECT id FROM category WHERE name='JAVA/JAVA SPRING' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('JWT -JSON Web Tokens', '인증 관련 공부를 하던중 JWT 공부의 필요성을 느끼고 찾아보았다.

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

변경하는 방식을 간략하게 설명하면 Binary Data를 6 bit 씩 자른 뒤 6 bit에 해당하는 문자를 아래 Base64 색인표에서 찾아 치환한다. (실제로는 Padding을 더해주는 과정이 추가된다.)', '2024-06-19 21:51:00', 0, 1, (SELECT id FROM category WHERE name='JAVA' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('비밀번호 암호화 -SHA,BCrypt SCrypt, Argon2', '## 해시란?

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
implementation ''org.springframework.security:spring-security-crypto'' //spring security crypto 라이브러리
implementation ''org.bouncycastle:bcprov-jdk15on:1.70'' //암호화 알고리즘을 사용에 필요한 dependencies

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
- 현재까지 알려진 공격에 대해 강력한 보안성을 제공합니다.', '2024-06-20 17:29:00', 0, 1, (SELECT id FROM category WHERE name='JAVA' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('PermissionEvaluator와 권한 인가처리,@PreAuthorize 대해', '### 서론

<aside> 💡 Controller에서 인가처리하는 부분을 공부하면서 @Secured(),@PreAuthorize, @PostAuthorize 3개의 어노테이션을 이용해서 인가처리를 해주면 되다는 것을 알고 이번에 @PreAuthorize에 대해서 집중해서 이야기 해볼 생각이다.

</aside>

### **@PreAuthorize**

```
 		@PreAuthorize("hasRole(''ROLE_ADMIN'')&&hasPermission(#postId,''POST'',''DELETE'')")
    @DeleteMapping("/posts/{postId}")
    public void delete(@PathVariable(name = "postId") Long postId) {
        PostResponse response = postService.get(postId);
        postService.delete(response.getId());
    }

```

위 코드는 자신이 작성한 게시글을 삭제하는 기능에서 post 에 작성자 정보와 삭제 요청 정보에 유저정보의 권한을 확인하고 인가처리를 요청하는 메서드이다.

• @PreAuthorize: 메서드가 실행되기 전에 인증을 거친다.

Secured 애노테이션과는 다르게 함수를 String 형태로 넣어줄 수 있고, and나 or 등 논리 연산자도 넣어줄 수 있다.

**애노테이션 내에서 사용가능한 함수/기능들**

- hasRole([role]) : 현재 사용자의 권한이 파라미터의 권한과 동일한 경우 true
- hasAnyRole([role1,role2 ...]) : 현재 사용자의 권한 파라미터들의 권한 중 일치하는 것이 있는 경우 true
- principal: 사용자를 증명하는 주요객체(User)를 직접 접근할 수 있다.
- authentication : SecurityContext에 있는 authentication 객체에 접근 할 수 있다.
- permitAll : 모든 접근 허용
- denyAll : 모든 접근 비허용
- isAnonymous() : 현재 사용자가 익명(비로그인)인 상태인 경우 true
- isRememberMe() : 현재 사용자가 RememberMe 사용자라면 true
- isAuthenticated() : 현재 사용자가 익명이 아니라면 (로그인 상태라면) true
- isFullyAuthenticated() : 현재 사용자가 익명이거나 RememberMe 사용자가 아니라면 true

### hasPermission

hasPermission은 permission 권한을 확인하는 역활을 하는 메서드로 PermissionEvaluator 이라는 인터페이스의 메서드이다.

아래의 코드는 PermissionEvaluator의 코드이다.

```
public interface PermissionEvaluator extends AopInfrastructureBean {
    boolean hasPermission(Authentication authentication, Object targetDomainObject, Object permission);

    boolean hasPermission(Authentication authentication, Serializable targetId, String targetType, Object permission);
}

```

위에 PermissionEvaluator을 구현하는 별도의 구현체를 만들었다.

### PermissionEvaluator 구현체

```
@Slf4j
@RequiredArgsConstructor
public class DailelogPermissionEvaluator implements PermissionEvaluator {

    private final PostRepository postRepository;
    @Override
    public boolean hasPermission(Authentication authentication, Object targetDomainObject, Object permission) {
        return false;
    }

    @Override
    public boolean hasPermission(Authentication authentication, Serializable targetId, String targetType, Object permission) {
        var principal = (UserPrincipal) authentication.getPrincipal();

        Post post = postRepository.findById((Long) targetId).orElseThrow(PostNotFound::new);

        if(!post.getUserId().equals(principal.getUserId())){
            log.error("[인가 실패] 해당 사용자가 작성한 글이 아닙니다. targetId = {}",targetId);
            return false;
        }
        return true;
    }
}

```

각 파라미터를 이용해서 인증객체에서 Principal를 가져와 나의 비즈니스 로직에 맞는 UserPrincipal로 가져와서

targetId를 통해 타겟 객체를 가져와서 내부에 작성자 아이디와 UserPrincipal의 아이디를 비교 후 그결과에 따라 인가 승인 결과를 boolean으로 돌려준다.', '2024-06-28 02:47:00', 0, 1, (SELECT id FROM category WHERE name='JAVA/JAVA SPRING' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('C_2차원 배열_ 함수 이용(2 Dimensional Array)', '오늘 강의 핵심은 2차원 배열을 사용하고 범용성을 가진 함수 만들어 보고 사용하는 방법을 배우는 것이 목적이었다.

보통 2차원 배열 즉 2Dimensional Array는 표처럼 사용되는 경우가 많다. 근데 이 2차원 배열을 함수 속에서 사용할 때 문제 되는 점이 존재한다. 그것은 함수는 범용성을 가지고 있어야 한다. 그 과정에서 2차원 배열을 함수 속에서 1차원 배열처럼 사용하는 것이다. 우리가 생각하는 2차원 배열은 직사각형의 표라고 생각하는 경우가 보통이다. 하지만 컴퓨터의 메모리는 그렇지 않다. 메모리는 변수를 저장하는 주솟값을 1열로 저장하기 때문에 우리도 함수에서 1열로 주솟값을 받아와 이용할 생각이다. 아래의 코드를 확인해보자.

| #include //void print2DArray(int p[3][4],int row, int col)//formal parameter에 구체적 숫자때문에 범용성이 없다.//void print2DArray(int p[][],int row, int col)   //컴파일 에러가 뜸  //void print2DArray(int p[][4],int row, int col)  //첫번쨰처럼 4인경우에만 사용가능해서 범영성이 떨어진다.void print2DArray(int p[],int row, int col) //여기 *p를 하는 이유는 2차원 배열의 시작 {                                                // 주소가 넘어가기 때문메모리에서는 2차원        int i,j;                                   // 배열을 1열로 주솟값을 저장하기 때문에 함수안에서        for(i = 0; i < row; i++)             // 해석을 1차원으로 해주어야 한다       {                                          //k = i * col +j를 이용해 2차원 배열을 1차원을 환원              for(j = 0; j < col; j++)            {                  printf("%5d",*p);                  p++;                  //printf("%5d", *(p+i*col+j));                  //printf("%5d", p[i*col+j]); 위와 동일함 이걸 제일 많이 씀             }             printf("\n");        }}void calculateSum(int p[],int row,int col){      int i,j;      for(i = 0; i < row; i++)      {             p[i*col + col-1] = 0; //col - 1 인 이유는 마지막 자리이기 때문              for(j = 0; j              {                  p[i*col + col-1] = p[i*col + col-1] + p[i*col+j];              }       }}main(){          int x[3][4] = { {20,30,70,0},                            {40,50,50,0},                            {70,80,80,0},                          } /*                국어  영어  수학 합계          1번  20      30   70   120          2번  40     50   50   140          3번  80     80   80   230*/          int i,j;           calculateSum((int*)x,3,4);/*for(i = 0; i < 3; i++){     x[i][3] = 0;     for(j = 0; j <3; j++)     {          x[i][3] = x[i][3] + x[i][j];     }}*/          print2DArray((int*)x,3,4);//여기서 x는 배열의 첫번쨰 주소를 가지고 있다.           x에 타입캐스팅을 해주어야 한다.          //아래의 반복문을 함수로 만들어줌다./*for(i = 0; i < 3; i++){       for(j = 0; j < 4; j++)     {         printf("%5d", x[i][j]);     }     printf("\n");}*/} |
|---|

함수를 만들 때 함수 안에 숫자를 사용하면 범용성이 떨어져 잘 만들어진 함수가 아니기 때문에 formal parameter중 
int p[3][4]를 바꿔줘야 한다. 그런데 여기서 그냥 int p[][]라고 하면 컴파일 에러가 뜨기 때문에 여기서 1차원 배열로 int p[]라고 적어주면 이제 2차원 배열을 1차원 배열처럼 사용하는 것이다. 이때 필요한 것이 k = i * col + j 이다.

예를 들어 p[2][2]를 1차원 배열로 바꿔주면 p[10]이 되게 된다.

Ex)

p[3][4]

| p[0][0] | p[0][1] | p[0][2] | p[0][3] |
|---|---|---|---|
| p[1][0] | p[1][1] | p[1][2] | p[1][3] |
| p[2][0] | p[2][1] | p[2][2] | p[2][3] |

p[12]

| p[1] | p[2] | p[3] | p[4] | p[5] | p[6] | p[7] | p[8] | p[9] | p[10] |
|---|---|---|---|---|---|---|---|---|---|

| p[11] | p[12] |
|---|---|

위의 그림처럼 메모리에서는 p[12]의 그림처럼 주솟값이 저장되어 이열로 되어있다고 생각하면 된다.

2차원 배열을 이용할 때 이점을 잊지 말도록 하자.', '2022-04-22 16:16:00', 0, 1, (SELECT id FROM category WHERE name='언어/C언어' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('일급 컬렉션(우테코 7기 프리코스 대비 6기 1주차)', '## 일급 컬렉션이란?

일급 컬렉션은 **소트윅스 앤솔로지**의 [객체지향 생활체조 파트의 규칙 8](https://developerfarm.wordpress.com/2012/02/01/object_calisthenics_/)에서 언급이 되었다고 합니다.

> 규칙 8: 일급 콜렉션 사용
> 
> 
> 이 규칙의 적용은 간단하다.
> 
> 
> 콜렉션을 포함한 클래스는 반드시 다른 멤버 변수가 없어야 한다.
> 
> 
> 각 콜렉션은 그 자체로 포장돼 있으므로 이제 콜렉션과 관련된 동작은 근거지가 마련된셈이다.
> 
> 
> 필터가 이 새 클래스의 일부가 됨을 알 수 있다.
> 
> 
> 필터는 또한 스스로 함수 객체가 될 수 있다.
> 
> 
> 또한 새 클래스는 두 그룹을 같이 묶는다든가 그룹의 각 원소에 규칙을 적용하는 등의 동작을 처리할 수 있다.
> 
> 
> 이는 인스턴스 변수에 대한 규칙의 확실한 확장이지만 그 자체를 위해서도 중요하다.
> 
> 
> 콜렉션은 실로 매우 유용한 원시 타입이다.
> 
> 
> 많은 동작이 있지만 후임 프로그래머나 유지보수 담당자에 의미적 의도나 단초는 거의 없다.

## 일급 컬렉션을 왜 사용할까?

일급 컬렉션을 사용하면서 얻는 이점은 다음과 같습니다.

### 1. 비지니스에 종속적인 자료구조

우아한 테크 코스 7기를 대비하기 위해서 지금 현재 6기 1주차 미션을 수행하고 있습니다. BaseBall에서 숫자 객체의 “**숫자의 크기를 3자리 숫자로 해야한다**”, “**서로 다른 숫자로 구성되어야한다.**” 라는 조건을 가지고 있습니다. 자료구조에 위 조건을 충족하는가 에 대하여 유효성을 검증하는 코드가 들어가야 합니다. 이러한 문제는 아래의 코드와 같이 **일급 컬렉션을 만들어 특정 조건으로 만들 수 있는 새로운 자료구조를 생성**하면 해결할 수 있습니다.

Number.java

```
public class Number {
    protected static final int BASE_BALL_NUMBER_SIZE = 3;

    protected final List<Integer> baseBallNumbers;

    public Number(List<Integer> baseBallNumbers) {
        validateSize(baseBallNumbers);
        validateDuplicate(baseBallNumbers);
        this.baseBallNumbers = baseBallNumbers;
    }

    private void validateSize(List<Integer> baseBallNumbers) {
        if (baseBallNumbers.size() != BASE_BALL_NUMBER_SIZE) {
            throw new IllegalArgumentException("3자리 수만 가능합니다.");
        }
    }

    private void validateDuplicate(List<Integer> baseBallNumbers) {
        Set<Integer> duplicateSet = new HashSet<>(baseBallNumbers);
        if (duplicateSet.size() != BASE_BALL_NUMBER_SIZE) {
            throw new IllegalArgumentException("서로 다른 수로 이루어진 3자리수만 가능합니다.");
        }
    }
}

```

일급 컬렉션을 만든 위의 코드를 보면 carList는 생성된 이후 getter, setter가 따로 없어 내부 값의 변경이 불가능 한 것을 확인할 수 있습니다.

### 2. Collection의 불변성을 보장

Java의 final은 불변을 만들어주는 것이 아니라 재할당만을 금지합니다. 그리하여 final List<Car> carList;와 같이 만들어도 carList은 재할당만 불가능 할 뿐이지 add, remove와 같은 메서드로 내용을 변경할 수는 있습니다.

Java에서 final로 만들 수 없는 **불변 객체는 일급 컬렉션과 래퍼 클래스의 방법으로 해결해야합니다.**

그런데 의문점!! 일급 컬렉션은 Getter,setter이 없어서 변경이 불가능 한건 알겠는데 getter이 없으면 일급 컬랙션끼리 비교하는 로직을 쓸대 내부데이터 정보를 어떻게 가지고 오는 것인지 궁금합니다. getter은 상관이 없는 것 같은 데 더 공부해봐야 할것 같습니다.

### 3. 상태와 행위를 한 곳에서 관리

일급 컬렉션은 값과 로직이 함께 존재하여 외부에서의 **중복된 메서드의 생성**과 같은 문제를 해결해줍니다.

일급 컬렉션을 생성하고 해당 메서드들을 일급 컬렉션 내에 만들어두고 외부에서는 호출을 하여 사용하도록 프로그래밍하면 **상태와 행위를 한 곳에서 관리**할 수 있습니다.

### 4. 이름이 있는 컬렉션

1. 해당 객체들을 검색을 할 때 변수명으로만 검색을 할 수 있어 변수명을 모를 시 검색을 하기 어렵다

2.단순히 변수명에 불과하여 의미 부여가 어렵다.

### 활용

ComputerNumber.java

```
public class ComputerNumber extends Number {

    public ComputerNumber(List<Integer> baseBallNumbers) {
        super(baseBallNumbers);
    }

    public Score getScore(PlayerNumber playNumbers) {
        int[] baseBallComputerNumberArr = getBaseBallNumberArr();
        int[] baseBallPlayNumberArr = playNumbers.getBaseBallNumberArr();
        int strike = 0;
        int ball = 0;

        for(int i = 0; i < BASE_BALL_NUMBER_SIZE; i++) {
            Integer num =baseBallComputerNumberArr[i];
            for(int j = 0; j < BASE_BALL_NUMBER_SIZE; j++) {
               if(num == baseBallPlayNumberArr[j]) {
                   if (i == j) {
                       strike++;
                   }
                   if (i != j) {
                       ball++;
                   }
                   break;
               }
            }
        }
        return new Score(strike, ball);
    }
}

```

PlayerNumber.java

```
public class PlayerNumber extends Number {

    public PlayerNumber(List<Integer> baseBallNumbers) {
        super(baseBallNumbers);
    }
}

```', '2024-07-06 00:01:00', 0, 1, (SELECT id FROM category WHERE name='JAVA' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('Dailelog 개발일지 -1.현재 진행 사항', '현재 기능을 크게 로그인,게시글,댓글  3가지가 존재합니다.

1. 로그인 기능

사용자 정보를 이용해 인증된 사용자만 기능을 사용할 수 있도록 하기위한 로그인 기능 , 로그인 완료 시 DB에 JWT를 이용한 세션 정보를 저장하고 확인하는 절차를 수행하도록 개발 했습니다.  현재는 로그인 기능만을 제공하고 있습니다. 추후 회원가입과 아이디,비번 찾기 비밀번호 변경기능을 추가할 예정입니다. 아래에 2가지 기능 말고 추가 기능 개발시 로그인 기능이 필요하다고 생각했습니다.

![](https://blog.kakaocdn.net/dna/NleEY/btsI5d9f57O/AAAAAAAAAAAAAAAAAAAAACLG2a6-gjsHwmlweVo2NR9CxLE6X24tXdyf2b17Gqd-/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=dWN%2BTvrdJZeWuHXpBlcKUmUz3VY%3D)
로그인 화면

![](https://blog.kakaocdn.net/dna/boz5ZJ/btsI5AXsQOt/AAAAAAAAAAAAAAAAAAAAAGbI4CwtBwdlnp2o5BhaT7WhdQRdk_VFn8aKx_r_jLD7/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=zhEe1oM3NgkbU1NXO0PYUwO7%2FgU%3D)
로그인 성공시 메인 화면으로 이동 및 현재 유저 정보 노출

2. 게시글 기능

Dailelog 는 블로그 라는 정체성의 기본인 글작성 기능입니다. 제목과 내용을 입력받아 메인화면에 게시글 목록을 페이징하여 보여지 한다. 블로그 게시글은 메인 admin 계정만 가능하게 개발된 상태입니다.  CRUD 가 모두 가능한 상태입니다.

![](https://blog.kakaocdn.net/dna/bKYmPw/btsI42G2AEG/AAAAAAAAAAAAAAAAAAAAALu8IramyxbByzg_fSG_R6a-H2-mXDU4tP4RH_P9_0bP/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=GrKq2eeRG027QSW1Vc7Q7%2B45hc0%3D)
게시글 작성 화면

현재는 <input> 입니다. 추후에 Tistory처럼 html 작성창으로 변경할 예정입니다.

![](https://blog.kakaocdn.net/dna/PTOaG/btsI5lTRSkw/AAAAAAAAAAAAAAAAAAAAAOvhILMDSAt9xscF5HKiRdCiMV6ithwMbLXDHEKtuzrj/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=Psjc%2B1N55%2BZIq3fWL5kCFdJ3dnA%3D)
작성후 메인 화면에 최신순으로 보여지게 됩니다.

게시글 순서는 최신순으로 보여지게 되고 한 페이지에 3개의 게시글이 보여지도록 페이징을 구현했습니다. 추후 카테고리를 추가하여  카테고리별로 보여지게 개발할 예정입니다.

![](https://blog.kakaocdn.net/dna/ciEHXU/btsI3QnkGwK/AAAAAAAAAAAAAAAAAAAAAMdJoKUlW_WYGJwKcnlg33qe6PYOqR1JRsN70CUIJ0Xu/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=S8ASyE1Ly1R0zeA5pCX9CrVtsAg%3D)

![](https://blog.kakaocdn.net/dna/b3iGRM/btsI5SKsPDg/AAAAAAAAAAAAAAAAAAAAAExlc87tlwkI-socEJwXN1F5mf1b0vFfpRgySQlkn8Nv/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=l4Jn6LhvWRi2LOx%2BwAYyTQ1cjUU%3D)

게시글 상세 화면

![](https://blog.kakaocdn.net/dna/ckL6y7/btsI3KnmHRx/AAAAAAAAAAAAAAAAAAAAADuVH7L2KqbimFb9DYmfl470wdV-hLUayeqzqb48XL0j/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=k9IKXyDq%2BQHyOr%2BSoL5Hiu2Qvm0%3D)

수정화면

![](https://blog.kakaocdn.net/dna/bGeBpB/btsI4oRm6wV/AAAAAAAAAAAAAAAAAAAAAFsTh_IBlnKXTj5B42qH-ovKo9E7Xq19T1ZeMAV5rWLU/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=TWqkbKglD4YFCg%2F40owNRdR74mU%3D)

기존의 글의 제목과 내용이 입력창에 나오게 됩니다.

3.댓글 작성 기능

![](https://blog.kakaocdn.net/dna/uF0VI/btsI5ibSnSi/AAAAAAAAAAAAAAAAAAAAAFLORKJP4JKjwmjt_DrNuVkCUiHtcXTGKl2-1xUIoxer/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=oGl424nxzFUkxK8YH3AXdWWMzcI%3D)

작정자 명과 삭제시에 필요한 비밀번호를 입력하고 댓글 내용을 입력하면 작성이 가능합니다.

![](https://blog.kakaocdn.net/dna/ejwHSj/btsI3ZLaQlv/AAAAAAAAAAAAAAAAAAAAAODsFvre_TvVxMY5_MXlFgKgaD1qZdPXe070nMBcHDIH/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=PDmrOxdEteR%2F4HmJZYxqNoIfG%2Bs%3D)

삭제 버튼 클릭시 다이얼로그가 나타나게 됩니다. 삭제하고자 하는 댓글의 작성했을때 사용한 비밀 번호를 입려하면 삭제가 가능합니다.

현재의 기능은 여기까지 입니다. 추후에 변경 사항을 정리하고 추가 기능를 추가 개발할 예정입니다. 배포도 할 예정입니다. 계속적으로 개발을 해서 나 자신을 대표하는 사이트를 만들어 갈 예정입니다. 많은 관심 부탁드립니다.

---', '2024-08-14 21:17:00', 0, 1, (SELECT id FROM category WHERE name='Dailelog' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('Dailelog 개발일지 - 2. 요구사항 정리', '저번 1편에 글에서 이야기 했듯 추가 수정사항과 요구사항을 정리해볼 생각이다. 크게 2가지로 해야하는 것과 하고 싶은 것들로 정리해보았다.

#### 해야하는것

Oath - 시큐리티 쪽을 더 공부하고 싶음

작성란 컴포넌트 수정 - 에디터 Api들중 한가지골라서 적용할 예정

회원가입 - 사용자 정보가 필요한 서비스를 추가하면 반드시 추가 해야할 것 같음

카테고리 추가 - 게시글 카테고리와 이후 글관리 목적상 필요

#### 하고 싶은것

웹소켓 채팅 - 과거에 만들게 된 Swing 프로젝트에  tcp/ip 채팅을 했을때 웹을 공부하면 하고 싶었음

텐서플로워 ai  - 마지막 학기 전공수업에서 테서플로워를 이용한 ai 실습이 존재하는데 추가로 공부해서 Dailelog에 추가하고 싶음

웹 RTC - 영상미디어관련 웹기술이라서 공부해서 추가할 예정입니다.

많관부', '2024-08-27 00:07:00', 0, 1, (SELECT id FROM category WHERE name='Dailelog' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('스트래티즈 패턴 (strategy pattern)', '참고 서적에서 간단한 오리 시뮬레이터 프로그램을 활용하여 strategy패턴에 대해 설명하고 있습니다.

코드를 보고 동일하게 설명을 하면 책의 내용을 읽는것과 다름이 없어서 필요한 부분과 나 자신이 이해한 내용을 정리할 생각입니다.

### 정의

strategy의 영단어의 의미는 ‘전략’입니다. 이 책에서 strategy 패턴의 정의는 아래와 같습니다.

> 전략 패턴 (Strategy Pattern)은 알고리즘군을 정의하고 캡슐화해 각각의 알고리즘군을 주정해서 쓸 수 있게 해줍니다. 전략 패턴을 사용하면 클라이언트로 부터 알고리즘을 분리해서 독립적을 변경 할 수 있습니다.

### 오리 시뮬레이터 게임 , SimUduck

책에서 예제로 오리게임을 제작한다고 예를 들고 있습니다. 다양한 오리들을 보여주는 프로그램에서 다양한 방식의 개발방식을 보여주고 문제점과 해결방식을 strategy 패턴을 이용해 제시하고 있다. 최초에는 Duck이라는 슈퍼클래스를 상속받는 2개의 자식 클래스 오리를 구현하는 방식을 보여주고 있습니다.

![](https://blog.kakaocdn.net/dna/RyDiI/btsJxTv7p0s/AAAAAAAAAAAAAAAAAAAAAMfP_8x3_Ef6tStRDbtTz0phgYtRYr0aos7TOJozqZvd/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=7kYjrGYxbMWwNc5zzN6%2BHdCoL3M%3D)

이러한 경우 새로운 오리가 늘어날 경우와 새로운 기능추가되는 경우 상속은 코드를 재사용한다는 점에서 상속을 잘 활용했다고 생각하지만 개발은 편할지 모르지만 유지보수에서 불편한 점이 생기게 됩니다. 상위 객체의 특성을 많이 사용하지 않는 클래스가 존재하게 된다면 문제는 더욱 커지게 되고 불필요한 코드가 발생합니다.

### 인터페이스 설계하기

책의 예제에서 상속은 올바른 해결책이 아님을 이야기하고 또 다른 방법을 제시하고 있습니다. 바로 상위객체가 가지고 있던 기능을 인터페이스로 설계하여 이 기능을 사용하는 하위 클래스가 인터페이스를 구현하는 식으로 개발방식 입니다.

![](https://blog.kakaocdn.net/dna/bDhnFz/btsJys5URgF/AAAAAAAAAAAAAAAAAAAAALmZVOyAmIWB-Ip9l7DyFl66ydVFurdL-N0s2-84ZFAh/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=YgY4w%2BAVQbq3MRtTimmp2CSQIqQ%3D)

그림이 많이 이상하지만 이해해주시면 감사하겠습니다. 이야기를 이어서 하자면 위그림이 참고서에서 제시해주는 또다른 방법입니다. 이렇게 인터페이스를 사용해 오버라이드를 줄인 방식이 좋다고 생각하시나요? 정답은 좋지 못한 방법입니다. 책에서도 이방법을 좋지 못한 방법이라고 이야기하고 있습니다. 위 방식은 코드 중복이 생길 뿐만 이 아니라 유지보수 방면에서 최악의 코드가 되어버렸습니다. 예를들어 fly() 함수를 구현할 때 동일 코드를 여러 클래스를 구현줘야하고 중복이 발생합니다. 심지어는 유지보수를 위해 fly() 함수의 변경사항이 발생하면 하나하나 fly()함수를 구현하는 클래스들을 확인하고 수정해줘야 하는 불상사가 발생하게됩니다. 그래서 이러한 문제를 해결하는 방법론이 이 책에서는 strategy 패턴입니다.

### 행동을 디자인하다

책에서는 상위클래서 Duck에서 fly()와 quack()를 분리해서 변화하는 부분과 변화하지 않는 부분으로 나누어 문제를 해결하려 합니다. 동일한 fly() 함수라도 하위객체에 따라 변화합니다. 그러면 저는 이 부분이 객체지향의 특징인 폴리몰피즘이라고 생각합니다. 그래서 분리된 함수를 행동이라고 생각하고 이런한 부분을 디자인하는 방향으로 이야기를 전개하고 있습니다. 여기서 인터페이스 FlyBehavior를 만들고 구현체 FlyWithWings, FlyNoWay를 만들어 내부에서 각가의 fly()함수를 구현해주는 형태를 만들어줍니다. 상위클래스는 이 인터페이스 인스턴스 변수를 추가함으로써 폴리몰피즘을 나타낼 수 있게 만들어줍니다. 그래서 새로운 하위 클래스 생성자에서 구현체를 결정해주면서 행위를 지정해 줄 수 있게 되고 유지보수 시에는 구현체만 수정하면 기존의 코드의 수정을 피할 수 있습니다. 이로서 OCP원칙까지 지킬 수 있게 되었습니다.

![](https://blog.kakaocdn.net/dna/XCZxh/btsJyLc08rJ/AAAAAAAAAAAAAAAAAAAAABcf1ZUruEKI8v5leOcQRIUNbkOI-4zITGnZulBQ6xaI/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=s2%2BYbIqiZ73%2FkdPWIlwVeZIazfo%3D)

### 나름대로 재정의

책과 교수님의 수업 그리고 구선생(구글)의 도움들을 이용해 strategy 패턴을 나 나름대로 재정의 하자면

> Strategy = interface + aggregation + dynamic biding
> Strategy ≠ 전략 → Strategy = 행동양식
> 김태균 교수님 “함수들을 행동양식으로 캡슐화하여 데이터 멤버화 시켜서 객체의 부속품으로 구현하는 방법"

이라고 재정의 해보았습니다.

---', '2024-09-10 20:37:00', 0, 1, (SELECT id FROM category WHERE name='디자인패턴' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('우테코 프리코스 연습 3주차(프리프리코스) - Enum', '이번 주차 미션에 추가된 요구 사항

> Java Enum을 적용한다.

여기서 Enum 타입을 저는 잘 사용하지 않았습니다. 기존에 상수를 사용할 때 자체 클래스를 구현하는 경우 또는 인터페이스 상수를 활용하곤 했습니다. 알고있던 내용 말고 새롭게 알게된 내용 위주로 다시한번 새롭게 공부해서 정리 했습니다.

### Enum

기본적인 열거 타입 선언

```
public enum Week {
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY
}

```

기존에 내가 공부했던 Enum 타입은 ‘열거 상수’ 의 형태로 그저 상수로 사용해왔습니다. Week today = Week.MONDAY;

```
public enum Rank {
    FIRST(6,false, 2000000000),
    SECOND(5,true,30000000),
    THIRD(5,false,1500000),
    FOURTH(4,false,50000),
    FIFTH(3,false,5000),
    NON(0,false,0);

    private final int rank;
    private final boolean bonus;
    private final int reward;

    Rank(int rank,boolean bonus, int reward) {
        this.rank = rank;
        this.bonus = bonus;
        this.reward = reward;
    }

    public int getRank() {
        return rank;
    }

    public boolean isBonus() {
        return bonus;
    }

    public int getReward() {
        return reward;
    }
}

```

위의 코드처럼 한가지 속성 속에 추가 속성을 여러 개 가질 수 있고 생성자에 순서대로 각각의 타입으로 넣어 주면 사용이 가능합니다. 원시타입 뿐 아니라 List 또는 다양한 클래스들을 추가할 수 있습니다.

### 함수형 인터페이스 추가

위에서 언급한 다양한 클래스 뿐만 아니라 Enum 타입을 관해서 찾아보던 중 인자값으로 계산식을 가질 수 있도록 지정할 수 있다는 사실을 알게 되었습니다. (Java 8 업데이트 이후부터 가능해졌다고 합니다.)

데이터 멤버에 private final *BiFunction*<Integer,Boolean, Boolean> function; 이렇게 인터페이스를 넣어주면 아래의 코드 처럼 사용이 가능합니다.

```
public enum Rank {
    FIRST(6,false, 2000000000, (count,bonus) -> count == 6),
    SECOND(5,true,30000000,(count,bonus) -> count == 5 && bonus),
    THIRD(5,false,1500000, (count,bonus) -> count == 5 && !bonus),
    FOURTH(4,false,50000, (count,bonus) -> count == 4),
    FIFTH(3,false,5000, (count,bonus) -> count == 3),
    NON(0,false,0, (count,bonus) -> count <= 2);

    private final int count;
    private final boolean bonus;
    private final int reward;
    private final BiFunction<Integer,Boolean, Boolean> function;

    Rank(int count, boolean bonus, int reward, BiFunction<Integer, Boolean, Boolean> function) {
        this.count = count;
        this.bonus = bonus;
        this.reward = reward;
        this.function = function;
    }

    public int getCount() {
        return count;
    }

    public boolean isBonus() {
        return bonus;
    }

    public int getReward() {
        return reward;
    }

    public Boolean getResult(int count, boolean bonus) {
        return function.apply(count,bonus);
    }
}

```

### 기본 함수형 인터페이스

함수형 인터페이스 Descripter Method

| Predicate | T -> boolean | boolean test(T t) |
|---|---|---|
| Consumer | T -> void | void accept(T t) |
| Supplier | () -> T | T get() |
| Function<T, R> | T -> R | R apply(T t) |
| Runnable | () -> void | void run() |
| Callable | () -> T | V call() |

### 두 개의 인자 Bi 인터페이스

위에 3개의 인터페이스의 인자가 두 개 이상의 타입을 받는 인터페이스

함수형 인터페이스 Descripter Method

| BiPredicate | (T, U) -> boolean | boolean test(T t, U u) |
|---|---|---|
| BiConsumer | (T, U) -> void | void accept(T t, U u) |
| BiFunction | (T, U) -> R | R apply(T t, U u) |

저는 이중에서 BiFunction을 사용했습니다.

## BiFunction

```
public interface BiFuncton<T, U, R> {
	R apply(T t, U u);
}

```

```
import java.util.function.BiFunction;

public class BiFunctionEx {

    public static void main(String[] args) {

        BiFunction<String, String, String> func1 = (s1, s2) -> {
            String s3 = s1 + s2;
            return s3;
        };
        String result = func1.apply("Hello", "World");
        System.out.println(result);

        BiFunction<Integer, Integer, Double> func2 = (a1, a2) -> Double.valueOf(a1 % a2);
        Double sum = func2.apply(10, 100);
        System.out.println(sum);
    }
}

```

### 적용하기

Enum에 속성으로 함수형 인터페이스를 추가해주면 아래의 첫번째코드에서 2번째 코드로 코드수를 많이 줄일 수 있게 된다. 지금은 확인해야하는 matchingCount 가 최대 6이지만 만약 더욱 늘어 나거나 bonus등 조건이 늘어나면 상당히 손이 힘들어 질 것이다.

```
 public Rank getRank(WinningNumber winningNumber, BonusNumber bonusNumber) {
        boolean bonus = false;
        int matchingCount = winningNumber.getMatchingCount(numbers);
        if(matchingCount == 5) {
            bonus = bonusNumber.isBonus(numbers);
        }

        if (matchingCount == 6) {
            return Rank.FIRST;
        }
        if (matchingCount == 5 && bonus) {
            return Rank.SECOND;
        }
        if (matchingCount == 5 && !bonus) {
            return Rank.THIRD;
        }
        if (matchingCount == 4 ) {
            return Rank.FOURTH;
        }
        if (matchingCount == 3 ) {
            return Rank.FIFTH;
        }
        return Rank.NON;
    }

```

```
    public Rank getRank(WinningNumber winningNumber, BonusNumber bonusNumber) {
        boolean bonus = false;
        int matchingCount = winningNumber.getMatchingCount(numbers);
        if(matchingCount == 5) {
            bonus = bonusNumber.isBonus(numbers);
        }
        boolean finalBonus = bonus;

        return Arrays.stream(Rank.values())
                .filter(rank -> rank.getResult(matchingCount, finalBonus))
                .findFirst()
                .orElse(Rank.NON);
    }

```

2번째 코드 블럭에서 사용한 stream은 다음에 정리해 보고자 합니다.', '2024-09-12 19:50:00', 0, 1, (SELECT id FROM category WHERE name='JAVA' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('옵저버 패턴 (Observer Pattern)', '### 옵저버란?

Observer 의 의미는 감시자, 관찰자라는 뜻의 영어단어이고 한국어로는 참관인 정도로 해석할 수있습니다. 그리고 여담으로 영국의 매주 일요일 발행하는 신문이름이 옵저버라고 합니다. ㅋㅋ 디자인 패턴에서 옵저버 패턴(Observer Pattern) 헤드퍼스트 디자인패턴 책에서 정의는 아래와 같습니다.

> 옵저버 패턴은 한 객체의 상태가 바뀌면 그 객체에 의존하는 다른 객체에게 연락이 가고 자동으로 내용이 갱신되는 방식으로 일대다(1:N) 의 의존성을 정의합니다.

정의 만으로는 이해가 어려우니 더욱더 자세하게 알아보자

### 옵저버 패턴 이해하기

옵저버 패턴에는 주제(subject)객체와 옵저버(observer)객체로 이루어져 있다. 주제객체는 상태변화를 감지하는 객체이다 그리고 중요한 데이터를 관리합니다. 옵저버객체는 주제객체로 부터 변경환 데이터를 받아 갱신하고 갱신된 데이터를 이용해 각자의 역할을 수행하는 객체입니다. 책에서 간단한 비유를 들어 설명 하는데 “ 신문사 + 구독자 = 옵저버 패턴 “ 을 비유로 들어서 설명하는 부분이 이해를 위한 가장 좋은 비유라고 생각합니다.

신문사는 주제객체로 구독자는 옵저버객체로 비유를 하고있습니다. 새로운 정보들이 갱신되면 신문사는 구독자들에게 신문을 배부합니다. 매번 새로운 신문을 전달 받고 싶다면 구독자가 아닌 사람이 구독을 하면 구독자가 될 수 있는 것 처럼 옵저버 객체가 아닌 객체가 주제 객체에 등록하면 옵저버객체가 되고 반대의 경우도 마찬가지 입니다.

### 옵저버 패턴은 왜 사용하는가?

기상 스테이션 구축 프로젝트 예제를 이용해서 설명하고 있습니다. 이 예제는 기상 스테이션이 다양한 센서들로 부터 데이터를 계속적으로 받아 디스플레이 장비를 이용해 표시해주는 프로그램을 작성하는 예제입니다.

먼저 WeatherData 클래스를 제시하고 있습니다.

| WeatherData |
|---|
| getTemperature()getHumidity()getPressure()measurementsChanged() |

기상 관측값이 갱신될 때마다 위 3개의 메서드가 호출됩니다.

measurementsChanged() 메서드에서 정보를 업데이트되게 해야합니다.

현재는 각기 다른 의미의 정보를 보여주는 디스플레이가 3가지 존재합니다.

디스플레이는 실행 중 추가및 제거될 수 있습니다.

```
public class WeatherData {
    //인스턴스 변수 선언
    
    public void measurementsChanged(){  
        float temperature = getTemperature();
        float humidity = getHumidity();
        float pressure = getPressure();

        currentConditionsDisplay.update(temperature, humidity, pressure);
        statisticsDisplay.update(temperature, humidity, pressure);
        forecastDisplay.update(temperature, humidity, pressure);
    }
}

```

코드에서 기상 관측값의 갱신을 받아서 3가지의 디스플레이를 업데이트 해주는 코드입니다. 이 코드는 옵저버 패턴이 적용이 되어 있지 않습니다. 그리고 예제에서는 요구사항 변경의 가능성을 미리 이야기 하였습니다.

이 예제에서 강조하는 것은 ‘확장성’입니다. 아직 개발 초기 단계라고 가정해 보죠. 갑자기 새로운 구성의 디스플레이가 필요하게 되거나 기존의 디스플레이를 제거해야한다고 가정하고 만들어야합니다. 그렇게 되면 새로운 디스플레이를 추가하는 경우 코드의 변경점이 너무나 많이 발생하게 됩니다. 구체적인 구현에 맞춰서 코딩을 해서 프로그램을 수정하지 않으면 다른 디스플레이를 추가하거나 제거도 불가능합니다. 책에서는 Coupling(결합도)이 높다고 표현하고 있습니다. 위 코드에 옵저버 패턴을 적용해 여러 문제를 해결해 볼 예정입니다.

### 옵저버 패턴의 구조

![](https://blog.kakaocdn.net/dna/bWB8E0/btsJGH4aQro/AAAAAAAAAAAAAAAAAAAAALuMDDp_NJBBs0XDiRtzpCyxlgp7loCCRELh8h08XX1q/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=ziIdVGd2ZzIpuXLIKcXA1h5Jb8Q%3D)

먼저 subject를 보면 observer를 추가하고 등록하는 함수를 볼수 있고 notifyObservers()는 변경발생 시 옵저버의 update를 이용해 변경점을 전달한다. 그리고 옵저버 패턴에서 코드상으로 중요도가 높은건 subject 쪽이다.

먼저 WetherStation 클래스를 확인해 보겠습니다.

```
public class WeatherStation {
    public static void main(String[] args) {
        WeaterData weaterData = new WeaterData();

        CurrentConditionsDisplay x = new CurrentConditionsDisplay(weaterData);
        //weaterData.registerObserver(x);
        StatisticsDisplay y = new StatisticsDisplay(weaterData);

        //센서가 있다고 가정
        weaterData.setMeasurements(80,65,30.4f);
        weaterData.setMeasurements(82,70,29.2f);
        weaterData.setMeasurements(78,90,29.2f);
    }
}

```

코드를 확인해보면 subject인 WeatherData를 만들어주고 2개의 observer객체를 생성해주는 동시에 observer객체의 생성자에서 WeatherData의 레퍼런스를 넘겨서 등록합니다.

```
public class CurrentConditionsDisplay implements Observer {
    private double temperature;
    private double humidity;
    private Subject weatherData;

    public CurrentConditionsDisplay(WeatherData weatherData) {
        this.weatherData = weatherData;
        weatherData.registerObserver(this);
    }

    @Override
    public void update(double temp, double humidity, double pressure) {
        this.temperature = temp;
        this.humidity = humidity;

        display();
    }

    private void display() {
        System.out.println("Current Conditions: " + temperature + "F degrees and, " + humidity + "% humidity");
    }
}

```

그러면 subject인 WeatherData의 컬랙션 객체에 observer들이 등록되고 관리할 수 있게 됩니다.

```
public class WeatherData implements Subject {
    private ArrayList<Observer> observers;
    private double temperature;
    private double humidity;
    private double pressure;

    public WeatherData() {
        this.observers = new ArrayList<>();
    }

    @Override
    public void registerObserver(Observer observer) {
        observers.add(observer);
    }

    @Override
    public void removeObserver(Observer observer) {
        observers.remove(observer);
    }

    @Override
    public void notifyObservers() {
        for (Observer observer : observers) {
            observer.update(temperature, humidity, pressure);
        }
    }

    private void measurementsChanged() {
        notifyObservers();
    }

    public void setMeasurements(double temp, double humidity, double pressure) {
        this.temperature = temp;
        this.humidity = humidity;
        this.pressure = pressure;

        measurementsChanged();
    }
}

```

옵저버 패턴에서는 컬랙션 객체는 등록,제거,업데이트를 일괄적으로 처리 하기 위해서 필수적이라 볼수 있다. WeatherStation에서 데이터들이 갱신될 경우 WeatherData의 setMeasurements() 메서드를 호출하여 등록된 observer 변경 알림을 update() 메서드를 통해 전달하여 각 observer객체에서 변경된 데이터를 이용해 각자의 역할을 수행합니다.

### 느슨한 결합 (Loose Coupling)

예제에서 옵저버 패턴을 적용하지 않았던 코드를 설명하면서 Coupling(결합도)이 높다고 이야기 했습니다. 결합도는 **모듈 간에 상호 의존하는 정도 또는 두 모듈 사이의 연관 관계를 의미합니다.** 그래서 결합도는 낮을 수록 좋고 프로그램의 유연성이 높다 또는 느슨한 결합이라 표현하기도 합니다. 느슨한 결합은 객체들이 상호작용할 수 있지만, 서로를 잘 모르는 관계를 의미합니다. 옵저버 패턴은 느슨한 결합을 보여주는 훌륭한 예입니다.

- 주제는 옵저버가 특정 인터페이스(Observer 인터페이스)를 구현한다는 사실만 압니다.
- 주제객체는 옵저버의 구상 클래스의 정보를 몰라도 되고 알 필요또한 없습니다. 결국 인터페이스만 인지하고 있다면 여러 구상클래스의 구현정보는 주제객체와 아무런 연관이 없습니다.
- 옵저버는 언제든지 새로 추가할 수 있습니다.
- 주제객체는 컬랙션 객체를 통해 옵저버의 레퍼런스를 일괄적으로 관리하기 때문에 언제든지 추가하고 제거해도 무방합니다. 결국 주제객체는 자신에게 등록된 레퍼런스를 통해 변경된 데이터를 전달하는것이 주목적이기 때문입니다.
- 새로운 형식의 옵저버를 추가할 때도 주제를 변경할 필요가 전혀 없습니다.
- 새로 만들어지는 옵저버가 발생하더라도 주제객체의 코드를 변경하는 일은 발생하지 않는다. 옵저버가 등록되기만 하면 문제가 없습니다.
- 주제와 옵저버는 서로 독립적으로 재사용할 수 있습니다.
- 주제나 옵저버 둘 모두 다른 용도로 활용할 일이 있다고 해도 손쉽게 재사용가능하다. 느슨한 결합으로 유연하기 때문에 가능한 일입니다.
- 주제나 옵저버가 달라져도 서로 영향을 미치지 않습니다.
- 인터페이스의 구현한다는 조건만 만족하면 어떻게 고쳐도 문제는 발생하지 않느다.

### Java 라이브러리의 옵저버

위의 예제는 subject와 observer를 직접 인터페이스 부터 구현체까지 직접 개발하였다. 하지만, 옵저버 패턴도 디자인 패턴이기 때문에 우리들의 수많은 스승 개발자님들이 너무나 대단하기 때문에 우리는 그저 가져다 쓰기만 하면 된다. 자바 라이브러리에서 아래와 같이 클래스들이 존재합니다.

subject interface → observable class

observer interface → observer class

둘다 라이브러리에 인터페이스로 존재한다. 가져다 구현제를 만들어주고 사용하면 된다.

### 옵저버의 push vs pull

Observer interface 함수의 update() 메소드의 특징은 pull 방식으로 작동 됩니다. push 와 pull방식을 설명은 아래와 같습니다.

push 방식 - subject가 모든 데이터를 옵저버에게 밀어주는 방식( 위에 예제처럼 페라미터에 직접적을 넘겨주는 것)

pull 방식 - 옵저버에게 subject의 레퍼런스를 전달하는 방식 (Java 라이브러리 에서 사용하는 방식)

| Modifier and Type | Method | Description |
|---|---|---|
| void | update(Observable o, Object arg) | Deprecated. This method is called whenever the observed object is changed. |

위와 같이 observer의 update() 메서드의 파라미터는 2개입니다. 그 이유는 범용적인 활용을 위해서 pull 방식과 push방식을 모두 사용할 수 있도록 개발 되었습니다. Observable o 는 subject 레퍼런스를 받습니다. object arg 는 subject의 데이터를 통제로 전달 받는데 객체 레퍼런스를 통해 데이터를 밀어넣으면 rtti를 해 풀어서 사용합니다. 개인적으로 생각했을때 push 방식은 묶여있는 데이터를 풀어서 작업을해 손이 더많이 가서 subject 객체 레퍼런스를 받아서 원하는 데이터를 getter를 통해 옵저버 구현체의 맞게 사용할 수 있어서 라이브러리에서 pull방식을 사용하는것 같습니다. 그리고 라이브러리에서 pull 방식을 사용할 떄 arg는 null 값이 넘어서 옵니다.

### 다시 정의 해보기

옵저버 패턴은 데이터의 발생(이벤트)를 사용하는 다수의 처리기(이벤트 처리기)에 전달하기 위한 방법

1. subject가 상태 변화 감지
2. collection 객체를 이용한 observer 관리
3. observer에서 데이터 처리

그리고 자바에서 이벤트 처리기 등록 메커니즘에서 이용되고 있습니다.

---', '2024-09-21 07:53:00', 0, 1, (SELECT id FROM category WHERE name='디자인패턴' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('자바 리플렉션 - reflection', '### 1. 리플렉션이란?

단어 자체는 반사, 반영이라는 의미를 가지고 있습니다. java에서는 아래의 의미를 가지고 있습니다.

> **Runtime 시에 이미 로드된 클래스 내에서 다른 클래스를 동적으로 로드하여 생성자, 필드, 메소드 등 access 할 수 있는 기능입니다.**

C 같은 compile 언어들은 필드명, 메소드명 등의 정보를 주소값으로 만 알 수 있습니다. 그런데 java는 프로그램을 실행하면서 필드명, 메소드 명 등을 직접 알아 낼 수 있는 기능이 reflection입니다.

### 2. 사전 지식

- **정적 바인딩 vs 동적 바인딩**

- **바인딩이란 프로그램에 사용된 구성 요소의 실제 값 또는 프로퍼티를 결정짓는 행위**를 의미합니다.
- 정적 바인딩

- **실행 이전에 값이 확정되고 컴파일 타임에 호출될 함수가 결정**되는 것으로, 함수는 기본적으로 정적 바인딩입니다.컴파일러는 선언되어있는 자료형을 보고 바인딩을 하기 때문에 실제로 가리키는 객체가 무엇이든 **포인터의 자료형을 기반으로 호출의대상을 결정**한다.
- 동적 바인딩

- 실행 이후 값이 확정 되고, 런타임에 호출될 함수가 결정나게 됩니다. virtual 키워드를 통해 동적 바인딩하는 함수를 가상 함수라고 합니다. 가상 함수가 선언 되면 포인터 변수가 실제로 가리키는 객체에 따라 호출의 대상이 결정됩니다.다형성의 원리가 적용될 수 있는 멤버 함수(메서드)로써 동적 바인딩으로 처리되는 메서드를 의미합니다. 동적 바인딩 수행 시 가상 메서드 테이블을 참조하여 매핑합니다.
- **가상 메서드 (Virtual Method)**
- 정적 바인딩이 아닌 동적 바인딩으로 처리되기 때문에 컴파일 시점에 정해지지 않은, 실제로 존재하지 않는, 임시로 존재하는 메서드라는 의미로 가상 메서드라고 지칭합니다.
- Class Class
- 이 클래스의 역할은 어떤 클래스를 컴파일 하고 난 후 메모리 상에 로드를 하게 됩니다. c와 달리 클래스 자체에대한 정보를 자료구조화 시켜서 access 할 수 있게 만들어주는 클래스 입니다.
- Recode Classes그 정보가 바로 Recode Classes입니다. 위에서 이야기한 Class Class의 자료구조 화의 모습이 Parse tree 형태의 구조로 되어 클래스 데이터를가지고 있습니다. 이것을 Recode Classes 또는 Class recode라고 합니다.
- .class 파일이 bytecode로 이루어져 있습니다. 파일 내부에 컴파일 완료된 클래스의 정보가 담겨있습니다.

![](https://blog.kakaocdn.net/dna/cTZqvQ/btsJK8ztJJE/AAAAAAAAAAAAAAAAAAAAAGeMsnTuomDikB9484Mb26bOVEo8xHtW8jpamczy19d0/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=IP6kfrnYZ4sdIgn0PSK6VXV913s%3D)

### 3. 실제 코드 예제

```
package je3.reflect;
import java.lang.reflect.*;

public class ShowClass {
    public static void main(String[] args) throws ClassNotFoundException {
        Class c = Class.forName(args[0]);
        print_class(c);
    }
    public static void print_class(Class c)
    {
        if (c.isInterface()) {
            System.out.print(Modifier.toString(c.getModifiers()) + " " + 
			     typename(c));
        }
        else if (c.getSuperclass() != null) {
            System.out.print(Modifier.toString(c.getModifiers()) + " class " +
			     typename(c) +
			     " extends " + typename(c.getSuperclass()));
	}
        else {
            System.out.print(Modifier.toString(c.getModifiers()) + " class " +
			     typename(c));
	}
        Class[] interfaces = c.getInterfaces();
        if ((interfaces != null)&& (interfaces.length > 0)) {
            if (c.isInterface()) System.out.print(" extends ");
            else System.out.print(" implements ");
            for(int i = 0; i < interfaces.length; i++) {
                if (i > 0) System.out.print(", ");
                System.out.print(typename(interfaces[i]));
            }
        }
	
        System.out.println(" {");
        System.out.println("  // Constructors");
        Constructor[] constructors = c.getDeclaredConstructors();
        for(int i = 0; i < constructors.length; i++)
            print_method_or_constructor(constructors[i]);
	
        System.out.println("  // Fields");
        Field[] fields = c.getDeclaredFields();
        for(int i = 0; i < fields.length; i++)
            print_field(fields[i]);
	
        System.out.println("  // Methods");
        Method[] methods = c.getDeclaredMethods();
        for(int i = 0; i < methods.length; i++)
            print_method_or_constructor(methods[i]);
	
        System.out.println("}");
    }

    public static String typename(Class t) {
        String brackets = "";
        while(t.isArray()) {
            brackets += "[]";
            t = t.getComponentType();
        }
	    String name = t.getName();
	    int pos = name.lastIndexOf(''.'');
	    if (pos != -1) name = name.substring(pos+1);
	    return name + brackets;
    }
    

    public static String modifiers(int m) {
        if (m == 0) return "";
        else return Modifier.toString(m) + " ";
    }
    

    public static void print_field(Field f) {
        System.out.println("  " + modifiers(f.getModifiers()) +
			   typename(f.getType()) + " " + f.getName() + ";");
    }

    public static void print_method_or_constructor(Member member) {
        Class returntype=null, parameters[], exceptions[];
        if (member instanceof Method) {
            Method m = (Method) member;
            returntype = m.getReturnType();
            parameters = m.getParameterTypes();
            exceptions = m.getExceptionTypes();
	        System.out.print("  " + modifiers(member.getModifiers()) +
			     typename(returntype) + " " + member.getName() +
			     "(");
        } else {
            Constructor c = (Constructor) member;
            parameters = c.getParameterTypes();
            exceptions = c.getExceptionTypes();
	        System.out.print("  " + modifiers(member.getModifiers()) +
			     typename(c.getDeclaringClass()) + "(");
        }
	
        for(int i = 0; i < parameters.length; i++) {
            if (i > 0) System.out.print(", ");
            System.out.print(typename(parameters[i]));
        }
        System.out.print(")");
        if (exceptions.length > 0) System.out.print(" throws ");
        for(int i = 0; i < exceptions.length; i++) {
            if (i > 0) System.out.print(", ");
            System.out.print(typename(exceptions[i]));
        }
        System.out.println(";");
    }
}

```

![](https://blog.kakaocdn.net/dna/FzTn6/btsJJIWBbue/AAAAAAAAAAAAAAAAAAAAANxeCD6WLYs05rZcONQ5fORYfJRDMp8FYKQerw7OB1d4/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=G7BUJ4Uncfz2JhWs7%2FJSbMbODLI%3D)

모든 객체에는 getClass()가 존재하고 객체 레퍼런스를 얻어와서 그것을 통해 리플렉션으로 클래스의 다양한 정보를 알아볼 수 있습니다.

단순히 정보를 알아내는 것 뿐 아니라 getMethods() 함수를 통해서 method가 컴파일된 결과값을 가지고 올수 있습니다. 그리고 아래의 코드처럼 활용할 수 있습니다.

```
Class c = Class.forname("main");
Method[] methods = c.getMethods();

methods[0].invoke(obj,agrs);

```

![](https://blog.kakaocdn.net/dna/4a6kw/btsJLajNYra/AAAAAAAAAAAAAAAAAAAAABnxebM_fyYXp_EQwuJg0Cm9t0aLACwcExZg74_Aa8Bf/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=1m8NYwHOAwth6EPC9lRXwonm7DI%3D)

```
car.move(30,50);

```

```
methods[0].invoke(car,args); // args = 30,50

```

### 4. 리플렉션의 활용 사례

- commend 패턴에서 활용
- java.beans
- java.rmi
- 스프링 프레임워크에서 빈(Bean)의 생성과 의존성 주입, 어노테이션 기반의 설정 처리 등 (직접적으로 리플렉션 API를 사용하지 않아도 내부적으로 활용)

위 글은 동아리 테크톡에서 Reflection을 주제로 연사를 준비하던 중 예전 공부하였던 내용을 정리하기 위해 작성한 글입니다. JAVA EXAMPLES IN A NUTSHELL 책과 전공수업, java api document 참고하여 공부하였습니다.

---', '2024-09-24 21:04:00', 0, 1, (SELECT id FROM category WHERE name='JAVA' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('몰입의 경험', '#### 오늘은 블로그의 주인인 저 김동혁이란 사람의 이야기를 해볼 생각입니다. 블로그를 처음 개설하지 벌써 3년이 되었습니다. 글을 꾸준히 정기적으로 올리진 못하지만 공부했던 것들을 정리하기 위해 올리고 있습니다. 지금은 우아한테크코스에 합류하기 위해 자소서를 작성하다. 오랜 시간 몰입했던 경험과 도전에 대한 문항을 작성하기 위해 고민을 하다. 진솔하게 저의 이야기를 하기위해 이글을 작성하게 되었습니다.

우선 제가 태어나서 처음으로 목표를 가지고 몰입했던 경험을 이야기 해보고자 합니다. 저는 고등학교 2학년 때부터 게임 기획자라는 목표를 세웠습니다. 처음에는 부산의 마이스터고등학교에 합격했지만, 부모님의 반대로 인문계 고등학교에 진학하게 되었습니다. 창작에 대한 재능이 있다고 믿었기에 부모님의 반대에 불만이 컸고, 인문계 고등학교 생활은 저와 맞지 않아 점차 무력감을 느꼈습니다. 이로 인해 성적이 떨어졌고, 부모님과의 갈등도 심해졌습니다.

그때 저를 도와준 사람은 누나였습니다. 누나는 "좋아하는 것과 잘하는 것을 아는 것 자체가 축복"이라며, 부모님을 설득하려면 구체적인 목표와 이유가 필요하다고 조언해주었습니다. 이 말을 듣고, 저는 게임 기획자라는 꿈을 더욱 구체화하고 부모님을 설득하기 위해 독학을 시작했습니다. 하지만 게임 기획에 대한 자료는 쉽게 구할 수 없었습니다. 부산에서 열리는 게임 관련 특강에 참여하고, 인터넷을 통해 정보를 모으며 독학으로 공부했습니다.

이론적인 공부만으로는 한계가 있었고, 실질적인 기획 능력을 기를 방법이 필요했습니다. 그러던 중 게임 기획 학원을 발견하게 되었고, 학원에 다니는 것이 제 목표를 이루는 데 중요한 발판이 될 것이라 생각했습니다. 부모님께 학원에 대해 말씀드렸지만, 게임을 여전히 놀이나 취미로 여겨 학원 수강을 허락하지 않았습니다. 그때 저는 누나의 조언을 떠올렸고, 단순히 "하고 싶다"는 말로는 부족하다는 것을 깨달았습니다. 그래서 그동안 배운 내용을 바탕으로 게임 기획서를 작성하고 부모님께 제시했습니다.

부모님께서는 마침내 조건부로 학원에 다니는 것을 허락해주셨습니다. 학원에서 성과를 내지 못하면 꿈을 포기해야 한다는 조건이었고, 저는 이 기회를 놓치지 않기 위해 최선을 다했습니다. 목표를 이루기 위해서는 어머니를 납득시켜야 했지만, 저는 공모전에서 입상하는 것을 제 목표로 설정했습니다.

6개월간의 독학과 7개월간의 학원 수강을 통해 기획에 대한 지식을 쌓고, 구체화할 수 있었습니다. 학원에서는 게임 개발 전반을 배우며 기획서를 작성하는 법을 익혔고, 문서화 능력을 기르는 데 큰 도움을 받았습니다. 이러한 배움을 바탕으로 청강문화산업대학교 공모전에 도전했습니다. 이 공모전은 게임과 애니메이션 분야에서 권위 있는 대회로, 참가자들의 경쟁이 치열했습니다.

목표를 이루기 위해 수많은 밤을 새며 기획서를 수정하고 보완했습니다. 기획서를 작성하는 과정은 어렵고, 반복적인 수정과 피드백을 거쳐야 했지만, 그 과정을 통해 더 나은 기획서를 작성할 수 있었습니다. 마침내, 공모전에서 입상하는 성과를 이루게 되었습니다.

이 경험을 통해 저는 문서화의 중요성과 설득의 힘을 배웠습니다. 게임 기획이라는 창의적인 아이디어를 구체적으로 문서로 표현하고, 이를 통해 타인에게 내 생각을 전달하는 방법을 익혔습니다. 특히 부모님을 설득하는 과정에서 구체적인 근거와 명확한 논리가 설득의 핵심이라는 것을 깨달았습니다. 결과적으로 부모님께서는 제 꿈을 인정해주시고 지지를 보내주셨습니다. 이 경험은 제게 단순한 학습 이상의 의미를 가졌습니다. 목표를 설정하고 이를 실현하기 위해 끊임없이 노력한 끝에 이룬 성과는 저에게 자신감을 주었고, 앞으로의 도전에서도 중요한 동기가 될 것입니다.

저는 이 경험을 통해 끈기, 설득력, 그리고 문제 해결 능력을 배웠습니다. 이 과정은 제가 성장할 수 있는 귀중한 기회였으며, 제 꿈을 향해 한 발 더 나아갈 수 있도록 해주었습니다.

아래의 사진은 당시 입상한 기획서의 일부내용,아이디어 노트 와 다른 컨샙기획 자료입니다.

  
![](https://blog.kakaocdn.net/dna/cNSr2z/btsJYXjC0qX/AAAAAAAAAAAAAAAAAAAAAMXF11Cj_al3H9luLmebSyMu77el4fmRpmk5Wo44ug23/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=jQOFd0z1owZ04SOOzqUfQgt7SPs%3D)

![](https://blog.kakaocdn.net/dna/buoJll/btsJY2LX2RU/AAAAAAAAAAAAAAAAAAAAAAdaMCywBfEWt9N13qnq6Ms8yssOHiWqswztGbVrIp0m/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=46OyGYc%2Bq%2BNdogiayZQtfMd3LmA%3D)

  당시 아이디어 노트

  
![](https://blog.kakaocdn.net/dna/xb0Mv/btsJW27Mf1h/AAAAAAAAAAAAAAAAAAAAAABIvr0LWszS11MbxRGuBs55GiNwB4TcfR155pi57106/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=Ih7ws4PmGqufS6A9tA6Bi8%2BJh6w%3D)

![](https://blog.kakaocdn.net/dna/cT8isK/btsJX62qSLI/AAAAAAAAAAAAAAAAAAAAAIcqwJR2s0Aku8vhp2oH3Oj6RNGbur2sK6qfARpP1Soc/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=UDqvmvbm6%2FgadpfAN2aACn2%2BeCw%3D)

지금 보면 조금 부끄럽지만 저 당시 너무 재미있고 행복했던 기억으로 남아있습니다. 위의 사진 외에도 item 테이블과 전투 벨런스 기획서 역기획서,컨셉기획서 등 다양한 기획서들이 있습니다. 과거의 제가 해왔던 것들을 보고 있으니 더욱더 기록을 중요하게 생각하게 되었습니다. 그래서 앞으로는 블로그에 회고록도 추가로 올릴 예정입니다. 많은 관심 부탁드립니다. 앞으로 계속 발전하는 사람이 되겠습니다.

![](https://blog.kakaocdn.net/dna/KgVjT/btsJZRKNoU7/AAAAAAAAAAAAAAAAAAAAACaapTxdOyNVSbGusBhnnt5tcLk4G8aNEh59-qt-qgT7/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=V3uaDNy1JlubvAMBLnbzY45mqWg%3D)

---', '2024-10-07 22:48:00', 0, 1, (SELECT id FROM category WHERE name='일기' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('우테코 프리코스 - 1 주차 시작', '오늘은 이번에 진행하고 있는 우아한 테크 코스의 합류하기 위해 프리코스 1주차에 대한 이야기 할 생각입니다. 제가 기다리고 기다리던 프리코스에 참여하게 되었는데 앞으로 4주동안 매주 1개의 회고록을 글로 작성할 예정입니다. 진행하면서 들었던 생각과 고민사항과 잘했다고 생각한 점과 부족한점 등 다양한 생각을 기록으로 남겨 볼 생각입니다.

특히, 저의 의도에 집중하고자 합니다. "왜"라는 의문을 던지고 어떤의도를 가지고 했는지를 말이죠. 미션과 코드에 대해서는 제출을 완료하고 난 이후에 회고록으로 전달하겠습니다. 이번 여정에서 많은 것들을 얻을 수 있기를 기대하며 다음에 더 좋은 이야기로 만나겠습니다.', '2024-10-17 11:58:00', 0, 1, (SELECT id FROM category WHERE name='활동' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('우테코 7기 프리코스 1주차 회고', '이글은 10월 22일 화요일 11시에 작석하는 글입니다. 저는 방금 전공인 ai프로그래밍 수업 중간고사 시험을 치고 이글을 작성하고 있습니다. 지금 프리코스가 시작되고 1주일이 지났습니다. 저의 1주차 결과는 예제 테스트 2개중 2개다 통과하였습니다.

![](https://blog.kakaocdn.net/dna/bmndFa/btsKfp718sE/AAAAAAAAAAAAAAAAAAAAAD6-m4fK5o92QWhfbSYf-kvbNZJ-tL2aEndNtrKWLDyK/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=xvstssGrmFfyqhhwG2f8uPkoB3M%3D)

코드나 요구사항에 대해서 글로 작성할 수 있는지 여부를 몰라서 프리코스를 진행할 때 제가 작성한 README.md와 1주차를 진행하면서 들었던 생각과 고민했던 사항들 그리고 그러한 고민 중 어떤 방식을 사용했는지에 대한 이야기를 할 생각입니다.

README.md

```
## 기능 구현 목록
- [ ] 시작 문구 출력 기능
- [ ] 커스텀 문자열 입력 시 구분자 추가 기능
- [ ] 사용자로 부터 문자열 입력받기
- [ ] 사용자로 부터 받은 문자열 숫자와 구분자로 나누는 기능
- [ ] 숫자들의 합산 기능
- [ ] 결과 출력하기 

## 예외 사항 처리 목록
- [ ] 입력 문자열에 구분자와 숫자를 제외한 다른 캐릭터가 존재하는 경우

```

프리코스 1주차 미션에서 구현해야할 기능 목록을 정리하고 추후 github에 커밋을 할때 기능 단위로 커밋을 하라는 요구사항이 있었습니다.저도 평소에 기능단위로 커밋을 하지만 평소에 제가하는 기능의 단위보다 더 작게 잡아서 실수를 줄이기 위해 노력했습니다.

#### 고민사항

1.커스텀 구분자 기능에 구분자를 한개가 아닌 여러가지를 추가할 수 있게 해야하는지 고민했습니다

```
덧셈할 문자열을 입력해 주세요.
//+_\\n1+4+_6_5
결과 : 16

```

처음에는 여러가지 캐릭터를 받을 수 있게 만들었습니다. 하지만 만약 ab를 커스텀 구분자로 하는 경우 a와 b를 각각 커스텀 구분자로 등록하기 때문에 문자열을 1개의 구분자로 받는것이 기능적으로 더 적합하다는 생각을 해서 현재는 // \n 사이에 오는 문자열 각각을 다 구분자로 등록되게 할지 아니면 사이에문자열 전체를 한개의 구분자로 받을지 고민됩니다. 결국 “//”와 “\n” 사이에 문자열 전체를 한개의 구분자로 만들었습니다.

```
//ab\\n1ab2
결과 : 3

```

```
//ab\\n1a2
Exception in thread "main" java.lang.IllegalArgumentException: [ERROR] 구분자와 숫자만 입력해주세요

```

2.커스텀 구분자 기능에 숫자도 구분자로 사용이 가능 하게 해야하는 것인지 고민했습니다.

```
덧셈할 문자열을 입력해 주세요.
//1\\n21315
결과 : 10

```

가능하게 만들었습니다.

3.양수에 소수를 포함해야하는가?

양수란?

> 양의 부호가 붙은 수로 0보다 큰수다. 앞에 부호(+)를 생략할 수 있다. - 위키백과

처음에는 양수를 보고 당연하기 input가 음수인지만을 상정하고 프로그래밍 했습니다. 하지만 소수 또한 양수에 포함되기 때문에 양수인 소수를 포함하기로 결정했습니다.

4. 리팩토링이란 정확히 무엇인 단순히 코드를 까끔하게 하는 것인가 어디까지 해야하는지?

> 리팩터링(refactoring)은 소프트웨어 공학에서 ''**결과의 변경 없이 코드의 구조를 재조정함**''을 뜻한다. 주로 가독성을 높이고 유지보수를 편하게 한다. 버그를 없애거나 새로운 기능을 추가하는 행위는 아니다. - 위키백과

이 고민은 계속해서 고민하고 답을 찾아내고 싶습니다.

5.합산기능은 Numbers 클래스 에서 담당하는데 생성자에서 처리해줄지 아니면 별도에 메서드로 구현할지 고민하였습니다.

결론은 별도에 합을 구하는 메서드를 구현했습니다. 이 상황이 취향의 문제인지 아니면 권장하는 방식 존재하는 궁금해졌습니다.

#### 문제발생

“|”, “*”, “^” 등의 특수문자는 \\를 붙여야 split() 함수의 인자로 적용가능하다

```
    public List<Integer> getNumberList(String readString) {
        List<Integer> numberList = new ArrayList<>();
        String numberString = readString;
        if(hasCustomSeparator(readString)){
            addCustomSeparator(readString);
            numberString = getNumberString(readString);
        }
        String[] split = numberString.split(symbols);
        try{
            for(String s : split){
                int i = Integer.parseInt(s);
                numberList.add(i);
            }
        }catch (Exception e){
            throw new IllegalArgumentException("[ERROR] 구분자와 숫자만 입력해주세요");
        }
        return numberList;
    }

```

```
public Numbers getNumberList(String readString) {
        String numberString = readString;
        if(hasCustomSeparator(readString)){
            addCustomSeparator(readString);
            numberString = getNumberString(readString);
        }
        List<Integer> numberList = split(numberString);
        return new Numbers(numberList);
    }

    private List<Integer> split(String numberString) {
        List<Integer> numberList = new ArrayList<>();
        String[] symbolArray = symbols.split("");
        String replaceString = numberString;
        for (String symbol : symbolArray) {
            replaceString = replaceString.replace(symbol, COMMA);
        }
        String[] numberArray = replaceString.split(COMMA);
        try{
            for(String s : numberArray){
                int i = Integer.parseInt(s);
                numberList.add(i);
            }
        }catch (Exception e){
            throw new IllegalArgumentException("[ERROR] 구분자와 숫자만 입력해주세요");
        }
        return numberList;
    }

```

하지만 결국 커스텀 구분자로 구분하는 것은 다른 방식으로 코드를 수정했습니다.

#### test

테스트의 목적은 기능이 제데로 작동하는 지와 예외처리가 잘되는지 확인 하는 작업이라고 생각합니다.

고민 1 privat 함수를 테스트 할경우 어떻게 해야하는가?

객체 내부에서 만 사용하는 함수를 테스트 하게 되면 문제가 발생할거 같다는 생각을 하게 되었습니다.

```
  if(hasCustomSeparator(readString)){
            symbols = addCustomSeparator(readString);
            numberString = getNumberString(readString);
        }

```

위 코드에서 hasCustomSeparator의 결과에 따라 addCustomSeparator를 실해하는 데 처음에 테스트 하기 위해

public 로 수정했었다 지금은 다시 private 로 수정했습나다. 커스텀 구분자가 존재하는 여부를 확인하고 있다면 추가하는 방식으로

구성했기 때문에 addCustomSeparator를 public로 만들면 오류가 발행할 확률이 크기 때문에 수정했는데 그럼 어떻게 테스트를 작성해야하는 의문이 들게 되었습니다.

제가 한 것들이 맞는지 검증하고 아직 스스로 답을 내리지 못한 고민사항들도 계속해서 답을 찾아 나갈 예정입니다.

과제 진행 소감

1주차를 진행하면서 의도와 왜라는 질문을 계속할려고 노력했습니다. 주어진 요구사항들의 구현하면서 왜 이방법을 선택했는지 어떤 방법들을 생각했는지를 고민하면서 저의 부족한점을 인지할 수 있었습니다. 특히 평소에 왜라는 질문에 "그냥"이라고 대답했던 저의 과거가 부끄러워 졌습니다. 기능을 수행하는 것 뿐아니라 여러 관점에서 개선점이 존재 할수 있다는 점이 재미를 느낄 수 있었습니다. 남은 프리코스를 진행 하면서 더욱 성장하고 싶다는 생각을 했고 우아한 테크 코스에서 다른 사람들과 이러한 고민을 같이 하면서 성장하고 싶습니다.

제가 작성한 코드가 궁금하시면 아래의 레포지토리 링크를 통해 확인해주세요

[https://github.com/BaSak0630/java-calculator-7](https://github.com/BaSak0630/java-calculator-7)

[
 

GitHub - BaSak0630/java-calculator-7

Contribute to BaSak0630/java-calculator-7 development by creating an account on GitHub.

github.com

](https://github.com/BaSak0630/java-calculator-7)

---', '2024-10-22 11:46:00', 0, 1, (SELECT id FROM category WHERE name='활동' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('C_string_strlen', '오늘은 문자열 함수 중 srtlen()를 공부하고 직접 strlen를 구현해 보았다.

| #include <stdio.h> #include <string.h> int my_strlen(char *s) {      int n;      for(n = 0; *s != ''\0''; s++)      {          n++;      }       return n; } main() {        char x[10];//= {''k'',''i'',''m'',''\0''};        int n;        int i;              /*        x[0] = ''k''; //''''를 사용하는 이유는 문자 상수 이기 떄문에 실제로는 아스키 코드 값이라고 생각하면 됨        x[1] = ''i'';        x[2] = ''m'';        x[3] = ''\0'';// \0은 나머지 문자열 자리에 NULL 캐릭터 값을 넣는 역활을 한다.        */        //사용하지 않는다면 쓰레기 값이 들어가게 된다.        for(i = 0; i <5; i ++)        {              scanf("%s",x);              //n = strlen(x); //문자열의 크기를 나타내는 함수 논리적 크기만 포함 \0은 포함하지 않는다.              n = my_strlen(x);              printf("length of %s is %d\n",x,n);        } } |
|---|

char x[10] = "kim"; 에서 문자열 상수"kim"은 4bety이다.여기서 3bety가 아닌 이유는 \0이 생략 되어 있기 때문이다. 이와 같은 예로 ''a''와 "a" 는 서로 다르다. ''a''는 아스키 코드 값이고 "a"는 문자열을 의미한다.

\0은 문자열 속에서 뒤에 빈 공간에 NULL을 넣는다.

strlen()를 이해 했듯이 앞으로 나오는 함수들도 이해하려고 노력할것이다.', '2022-04-25 19:02:00', 0, 1, (SELECT id FROM category WHERE name='언어/C언어' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('우테코 프리코스 1주차 나의 코드리뷰', '### 프리코스 1주차가 끝나고 사람들과 코드리뷰를 나누었습니다.

제가 놓친 부분이나 몰랐던 부분을 타인에 시선에서 객관적으로 받아 들일 수 있는 좋은 기회 였습니다.

### static으로 정의한 이유

질문 코드

```
public class Calculator {

    private OutputView outputView;
    private InputView inputView;
    private Separator separator;

```

코멘트

```
추가로 취향(?)이지만 메서드 파라미터로 받으신 필드 값이 의도적으로 변경될 여지가 없다면 
final키워드로 묶어보는게 어떨까요? 다른 개발자가 이 코드를 봤을때 final이 붙어 있으면 필드 변경에 
좀 더 신중할 수 있을거 같습니다! (항상 소통의 문제로 의도치 않은 문제들이 발생하더라구요...!)

```

나의 리플

```
''다른 개발자가 이 코드를 봤을때 final이 붙어 있으면 필드 변경에 좀 더 신중할 수 있을거 같습니다!''
라는 말에 동의 합니다. 변경의 여지가 없음을 나타내주는 것이 좋을 것 같습니다. 

```

### BigDecimal

질문 코드

```
    public void printResult(Numbers numbers) {
        Double sum = numbers.getSum();
        if(sum%1 == 0) {
            String result = String.format("%.0f", sum);

```

코멘트 - [**bowook**](https://github.com/bowook)

```
코드에 대한 분석을 보니, 양의 실수를 처리하기 위해 Double 타입을 선택한 점이 인상적입니다.
특히 문제의 요구사항을 충실히 반영하려는 노력이 보이는 코드인 것 같아요!
Double 타입을 사용할 경우 근삿값이 나올 수 있다는 점에서 %.0f 형식을 활용하여 이를 처리하려고 한 시도가 눈에 띄네요!

다만, Double 타입은 오차가 발생할 수 있는 특성이 있기 때문에 정확한 계산이 필요한 경우에는 BigDecimal 타입을 사용하는 방법을 고려해 볼 수 있습니다. 이를 통해 오차를 최소화할 수 있는 장점이 있으니, 해당 기능도 알아보면 좋겠습니다!

```

나의 리플

```
BigDecimal 타입은 생각도 안해보았습니다. 존재 자체는 알고 있는데 사용해본적이 없어서 익숙하지 않습니다.
부동 소수점에 대한 내용을 조금만 알고 있어서 조금 더 공부해보고 나중에 코드에 적용해보겠습니다. 감사합니다.

```

### overflow

질문 코드

```
 		public Double getSum() {
        Double sum = 0.0;
        for (Double number : numbers) {
            sum += number;
        }
        return sum;
    }

```

코멘트 - [**gyuoo**](https://github.com/gyuoo)

```
overflow에 대한 고려가 되어있지 않은 것으로 확인되는데, 맞을까요?

```

나의 리플

```
overflow에 대해 간과했던것 같습니다. 알려주셔서 감사합니다. 

```

### 예외처리

질문 코드

```
    private String getNumberString(String readString) {
        int subStringInt = readString.indexOf(CUSTOM_SEPARATOR_END) + CUSTOM_SEPARATOR_END.length();
        String substring = readString.substring(subStringInt);
        return substring;
    }

```

코멘트 - [**gyuoo**](https://github.com/gyuoo)

```
커스텀 구분자가 중간에 있는 경우도 고려된 것 같네요!
readString.indexOf(CUSTOM_SEPARATOR_END)가 -1인 경우나
\\\\n1:2:3과 같은 입력도 예외 처리를 했다면 더 좋았을 것 같습니다.

```

나의 리플

```
getNumberString메서드가 호출되기 이전에 hasCustomSeparator 이라는 메서드를 통해서 readString.indexOf(CUSTOM_SEPARATOR_END) 가 -1인 경우의 예외처리를 하고 있습니다.
마찬가지로 \\n1:2:3 입력의 경우에도 hasCustomSeparator 에서 예외처리를 하고 있습니다.

```

### 리펙토링1

질문 코드

```
        if(readString.contains(CUSTOM_SEPARATOR_START) && readString.contains(CUSTOM_SEPARATOR_END)){
            return true;
        }
        return false;

```

코멘트 - [**gyuoo**](https://github.com/gyuoo)

```
return readString.contains(CUSTOM_SEPARATOR_START) && readString.contains(CUSTOM_SEPARATOR_END) 
은 어떤가요?

```

나의 리플

```
제가 놓친것 같습니다. 알려주셔서 감사합니다. ㅎㅎ

```

### 빈 값 0으로 출력하기

질문 코드

```
        if(s.isEmpty()) {
            throw new IllegalArgumentException("[ERROR]덧셈할 문자열을 입력해 주세요");
        }

```

코멘트 - [**gyuoo**](https://github.com/gyuoo)

```
요구사항에 빈 값이 입력되는 경우 0을 출력해야 하는 것으로 알고 있습니다!

```

나의 리플

```
알려주셔서 감사합니다. 이걸 놓쳤었네요 ㅠㅠ

```

### symbolArray

질문 코드

```
    private List<Double> split(String numberString) {
        List<Double> numberList;
        String[] symbolArray = symbols.split(CUSTOM_SEPARATOR_CENTER_REGEX);

```

코멘트 - [**sunkong25**](https://github.com/sunkong25)

```
symbols로 문자열을 합쳤다가 symbolArray로 나눠서 다시 저장하신 것 같은데 왜 이런 방법을 
사용했는지 궁금합니다!

```

나의 리플

```
구분자를 추가할 때 특수 문자나 숫자 등 문제가 발생할수 있는 문자들을 전부 '',''로 치환해서 
split을 해주면 문제가 발생하지 않을 것 같아서 다시 배열에 저장하였습니다.

```', '2024-10-25 16:55:00', 0, 1, (SELECT id FROM category WHERE name='활동' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('우테코 7기 프리코스 2주차 회고', '이글은 10월 29일 화요일 작성하는 글입니다. 이번 주도 테스트 2개를 통과하였습니다. 하지만 저 스스로에게 아쉬움이 많은 한주 였습니다.

![](https://blog.kakaocdn.net/dna/HJ0sc/btsKm97aIq8/AAAAAAAAAAAAAAAAAAAAAAiP2SXXzbgBg2Zwy6GO8RVet05_gMFGuM6RI1TGEAy9/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=90cqkW%2FGSGMkc8rEeiie2utXIKg%3D)

먼저 이번주에 제가 고민했던 것들에 대해서 이야기 해볼 생각입니다.

### 고민사항

1. 경주에 참가하는 자동차 수와 시도 횟수 최대 값을 따로 설정 해줘야하는가?

"**기능 요구 사항에 기재되지 않은 내용은 스스로 판단하여 구현한다."**

라는 내용이 있어 최대 값을 설정 해주기 하였습니다.

********2. InputView에서 readLine의 역할에 대한 고민

```
public String readLine() {
	String readLine = Console.readLine();
    String trim = readLine.trim();
    if(trim.isEmpty()) {
    	throw new IllegalArgumentException("[ERROR] 경주할 자동차 이름을 입력하세요.(이름은 쉼표(,) 기준으로 구분)");
    }
    return trim;
}
```

```
    public String readLine() {
        String readLine = Console.readLine();
        return readLine.trim();
    }

    public String readCarNames(){
        String readLine = readLine();
        if(readLine.isEmpty()) {
            throw new IllegalArgumentException("[ERROR] 경주할 자동차 이름을 입력하세요.(이름은 쉼표(,) 기준으로 구분)");
        }
        return readLine;
    }

```

경주할 자동차 이름을 받을 때와 시도횟수를 입력받을 때 따로 예외 처리를 하기 위해 readLine의미에 맞게 단순히 한줄을 입력 받게만 변경해주었습니다.  별도에 readCarNames를 추가 추후에 시도횟수를 입력받고 예외처리를 별도 해주었습니다.

3. pobi,woni,jun 이 아닌 pobi,,jun 처럼 사이에 공백이 있으면 어떻게 처리 할것인가?

잘못된 입력으로 생각하고 Exception 처리 하였습니다.

4.  파일 디렉토리를 정리해야 하는가?

```
 racingcar
    ├── Application.java
    ├── controller
    │   └── RacingCarController.java
    ├── domain
    │   ├── Car.java
    │   ├── NumberOfAttempts.java
    │   ├── RacingCars.java
    │   └── RandomNumber.java
    ├── dto
    │   ├── CarDTO.java
    │   └── NumberOfAttemptsDTO.java
    ├── service
    │   └── RacingCarService.java
    └── view
        ├── InputView.java
        └── OutputView.java

```

정리 하니깐 보기 편해졌습니다.

5. Car 객체의 랜덤 무브 테스트는 어떻게 진행하는가?

car 객체 내부 메소드에 random 값을 호출하였지만 자동차 객체에 랜덤 값을 결정하는 것은 car의 역할이 아닌것 같아서 별도 분리하게 되었습니다. 하지만 여전히 랜덤에 대한 테스트는 좀더 찾아봐야 할거 같습니다.

결국 car에서 랜덤값을 결정하여 이동하는 것이 아닌 책임을 분리하기 위해서 별도의 NumberOfAttempts 객체를 만들었습니다. 그런데 결국 테스트 하는 방법을 못찾아서 커뮤니티에서 다른 분들의 코드를 보고 공부할 예정입니다.

6.input 과 output 를 static member function 으로 해야하는가 객체 일반 member function으로 해야하는가?

저는 일반 멤버 펑션을 선택하고 컨트롤러에서 RacingCarService 에서 중간 결과를 출력을 데이터 멤버인 OutputView를 레퍼런스를 넘기는 방식으로 OutputView객체에 바운드 시켜서 사용하는 것을 선택했습니다.

```
    private void play(RacingCarService racingCarService) {
        outputView.printResultMessage();
        racingCarService.play(outputView);
    }
```

```
 public void play(OutputView outputView) {
        NumberOfAttemptsDTO numberOfAttemptsDTO = numberOfAttempts.getNumberOfAttemptsDTO();
        int number = numberOfAttemptsDTO.getNumber();
        for (int i = 0; i < number; i++) {
            racingCars.move();
            String states = racingCars.getStates();
            outputView.printRacingCarsState(states);
        }
    }
```

outputView의 레퍼런스를 넘겨줘도 되는건지 궁금합니다.

---', '2024-10-29 21:50:00', 0, 1, (SELECT id FROM category WHERE name='카테고리 없음' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('우테코 프리코스 3,4주차', '## 3주차 학습

이번 주 미션 내용은 로또 프로그래밍입니다.

### 학습 목표

- 클래스 생성 및 객체 협력을 통한 기능 구현
- 단위 테스트를 통한 정확성 확보
- 2주 차 공통 피드백 반영

### 추가 요구사항

- 함수/메서드 길이 15라인 이내로 제한
- 단일 책임 원칙 준수
- Java Enum 활용
- UI 로직 제외한 기능에 대한 단위 테스트 작성

### 주요 고민사항

- 도메인과 모델의 차이 이해
- 테스트 시 무한루프 방지

- Consol.readLine 에서 inputStream이 테스트 시 계속 열려있어 오류 발행하는 사항을 인지 함
- 전체 구조 설계

- MVC 패턴을 사용할려고 했는데 각 객체들의 역할에 대한 명칭이 고민됨
- 생성자 주입 방식
- 오류 발생 시 재입력 처리

### 발견된 문제점

- 당첨 번호 범위 검증 누락
- 요구사항 중 정렬 기능 미구현
- UnsupportedOperationException 발생

### [README.md](http://README.md) 작성 가이드

프로젝트 개요와 주요 기능을 소개하는 README.md를 마크다운 문법을 활용하여 상세히 작성할 것

- 1일 회고

- 29일

- 도메인과 모델의 차이에 대해 고민했습니다. 도메인은 비즈니스 로직을 담당하고, 모델은 데이터 구조를 표현한다는 점을 이해했습니다.
- 30일

- 테스트 시 무한루프를 방지하기 위해 최대 반복 횟수를 설정하는 방법을 고려했습니다.
- 31일

- 전체 구조 설계에 집중했습니다. 각 클래스의 역할과 책임을 명확히 정의하고 상호작용을 고려했습니다.
- 1일

- 생성자 주입 방식에 대해 학습했습니다. 의존성 주입을 통해 객체 간의 결합도를 낮추는 방법을 적용해보았습니다.
- 2일

- 오류 발생 시 재입력 처리 로직을 구현했습니다. 사용자 경험을 개선하기 위해 적절한 오류 메시지와 함께 재시도 기회를 제공했습니다.
- 3일

- 당첨 번호 범위 검증 누락 문제를 발견하고 수정했습니다. 입력값 유효성 검사를 강화했습니다.
- 4일

- 요구사항 중 정렬 기능을 구현했습니다. Collections.sort()를 활용하여 효율적으로 구현했습니다.

## 4주차 학습

4주차는 개인적인 사정으로 앞에 주차와 달리 기록을 놓친 점이 저 자신에게 아쉬웠던 주였습니다. 4주차 미션은 편의점 이였습니다. 개인적으로 시간이 없어 코딩을 하고 리팩토링을 했는 처음부터 함수의 역할 단위를 생각하지 않고 개발해서 리팩토링 과정에서 너무나 힘들었습니다. 그래서 지키지 못한 부분도 존재 했던거 같습니다. 그래서 너무나 아쉬웠습니다.

프리코스를 통해 목표로 삼았던 “다른 사람들과의 코드 리뷰 경험”과 “코드의 의도를 기록하는 습관 만들기”를 약 80% 달성했다고 느낍니다. 이 목표를 달성할 수 있었던 이유는, 동일한 목표를 가지고 다양한 관점을 가진 사람들과 코드 리뷰를 하면서 서로의 코드 스타일과 접근 방식을 비교하고, 저 자신의 코드 또한 되돌아보는 기회를 얻었기 때문입니다. 다른 사람들이 제 코드에 대해 피드백을 주었을 때 제가 놓쳤던 부분을 발견할 수 있었고, 이는 제 코드를 더욱 발전시키는 데 큰 도움이 되었습니다.

또한, 코드의 의도를 기록하는 습관을 위해 어떤 생각으로 문제를 해결했는지와 고민했던 여러 방법들을 글로 남겼습니다. 이 기록 덕분에 구현 과정에서 제가 어떤 선택을 했고, 왜 그렇게 선택했는지 더 명확히 인지하게 되었으며, 선택하지 않은 대안들도 기록해 두어 향후 코드를 개선하거나 리뷰할 때 참고할 수 있게 되었습니다. 4주차 미션에서는 구현에 집중하느라 기록을 놓친 점이 아쉬웠지만, 그 외의 주차에서는 기록을 지속해 목표를 대부분 달성할 수 있었습니다.

프리코스를 통해 배운 또 다른 중요한 교훈은 **개발 과정의 흐름을 놓치지 않는 방법**입니다. 기록하는 습관을 통해 다양한 문제 상황 속에서도 현재 제가 집중해야 할 핵심 문제를 쉽게 파악할 수 있었으며, 이를 통해 복잡한 문제들 속에서도 더 효율적으로 해결책을 찾아가는 능력이 향상되었습니다. 그리고 의식적으로 어떤 부분을 놓치고 있는지 인지하고 의식적으로 코딩할 수 있었습니다.

이러한 기록과 코드 리뷰 경험은 앞으로 개발 과정에서 중요한 자산이 될 것이라 확신합니다. 기록을 통해 문제 해결의 논리적 흐름을 명확히 하고, 다른 사람과의 코드 리뷰에서 다양한 시각과 피드백을 얻는 습관은 개발자로서 지속적인 성장에 크게 기여할 것입니다.', '2024-11-15 09:15:00', 0, 1, (SELECT id FROM category WHERE name='활동' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('데코레이터 패턴 (Decorator Pattern)', '### 데코레이터 패턴(Decorator Pattern)이란?

> 데코레이터는 장식하다, 꾸미다라는 뜻의 decorate에 er(or)을 붙인 말인데 **장식하는 도구** 정도로 설명할 수 있습니다.

> **데코레이터 패턴**(Decorator pattern)으로 객체에 추가 요소를 동적으로 더할 수 있습니다. 데코레이터를 사용하면 서브클래스를 만들 떄보다 훨씬 유연하게 기능을 확장할 수 있습니다.

### 예제 개념 - 커피 전문점

책에서는 예제를 커피전문점에서 커피를 주문을 예로 데코레이터 패턴을 설명하고 있습니다. 기본 아메리카노를 주문할 때 여러가지 옵션을 추가 함으로써 가격과 요소를 추가하는 등의 변화를 주는 프로그램을 제시하고 있습니다. 고객은 커피를 주문할 때 우유나 두유,모카등 추가하는 경우 추가된 요소에 따른 가격등 여러가지 정보가 기본 커피에 적용되는 시스템을 구현 해야할 때 여러 고려 사항들이 존재합니다.

하드코딩으로 데이터 멤버에 요소들을 구성하고 getter/setter 메서드를 이용해 구현하는 방법은 중간에 추가사항이 방생하는 경우 문제가 발생할 여지가 너무나 많습니다. 그리고 추상클래스를 만들어 상속을 받아 만드는 방법 또한 시스템 확장시 상위 클래스 수정시 하의 클래스의 문제가 발생할 가능성이 증가 합니다. 이 두방식 모두 다형성을 표현하는데 부족합니다.

### OCP - Open Closed Principle

갑자기 왜 갑자기 SOLID원칙 이야기를 하는지 궁금할 수 있습니다. 그이유는 위에서 언급한 방법들이 OCP를 지키지 않은 구현 방법을 제시 했기 때문입니다. 데코레이터 패턴은 OCP 원칙을 지키는 대표적인 방법입니다. 그래서 OCP에 대해서 언급하고 넘어 가도록 하겠습니다.

OCP를 한 문장으로 정의 하면 **“클래스는 확장에는 열려 있어야하지만 변경에는 닫혀 있어야한다.”** 입니다. 처음 듣고 순간 모순된 말이라고 생각 했었습니다. 우리의 목표는 코드를 건드리지 않고 새로운 행동을 추가하는 것입니다. 저의 블로그의 앞에 글 중 옵저버 패턴에 대한 내용에서 subject 객체에 코드를 수정하지 않고도 얼마든지 옵저버를 추가할 수 있었습니다. 객체지향 디자인 기법을 보면 행동을 확장할 수 있는 방법도 존재합니다.

하지만 모든 부분에 OCP를 준수해야하는 것은 아닙니다. 책에서는 새로운 단계의 추상화가 필요한 경우 종종 있는데, 추상화를 하다 보면 코드가 복잡해 진다고 합니다. 그래서 우리는 디자인한 것 중에서 가장 바뀔 가능성이 높은 부분을 중점적으로 살펴보고 OCP를 적용하는 방법이 가장 좋다고 합니다.

### 데코레이터 패턴 살펴보기

그럼 이제 데코레이터 패턴에 대해서 이야기 해볼 생각입니다. **장식** 이라는 의미를 가지고 있는데 개념적으로 접근해 볼것입니다.

1. 기본 에스프레소 객체를 가져온다.
2. 우유 객체로 장식한다. (라떼가 된다)
3. 휘핑 객체로 장식한다.
4. cost() 메서드를 호출한다. 이때 첨가물의 가격을 계산하는 일은 해당 객체에게 위임한다.

여기서 **장식**의 개념이 데코레이터 객체의 ‘래핑’이라고 생각하면 편할 것입니다. 데커레이터 객체로 기본 객체를 감싸서 기능을 강화시키는 것이다. 그럼 어떻게 깜싸는 행위를 할 수 있는지 보면 데코레이터 객체는 기본 객체 즉 슈퍼 클레스를 상속받아서 구현해 주는 것입니다. 기본객체의 레퍼런스를 테코레이터 객체에 생성자의 파라미터로 넘겨서 데코레이터 객체의 인스턴스로 유지하는 방식으로 감싸는 것입니다. 그리고 슈퍼클레스를 상속 받았기 때문에 데코레이터 객체를 다시 래핑할 수 있습니다.

![](https://blog.kakaocdn.net/dna/6ueD7/btsKNwUCG1y/AAAAAAAAAAAAAAAAAAAAAPi-TXJ56UgzNUrN73MOvRH76B1gG3lBtMpMlG-fyedK/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=806%2BVQV64GjKBWi99m5E6Hsks%2BQ%3D)

이 UML은 책을 참고하여 인텔리제이로 만들었습니다. 위 UML을 통해서 더 이야기 해보겠습니다. 여기서 기본 객체가 바로 Component입니다. 이 컴포넌트 객체를 상속 받은 Decorator 객체를 사용해서 Component의 기능을 강화할 수 있습니다. 기능을 강화하기 위해서 Decortator 객체의 생성자에 Component객체를 파라미터로 넘기면 인스턴스로 유지하여 인스터스를 활용해서 여러 메소드를 강화할 수 있습니다. 여기서 모두가 Component객체를 상속받은 자식 객체이기 때문에 여러번 Decorator객체로 강화 시키는 것이 가능합니다.

Decorator.java

```
public class Decorator extends Component {
    private final Component component;

    public Decorator(Component component) {
        this.component = component;
    }

    public void methodA() {
        component.methodA();
    }

    public void methodB() {
        component.methodB();
    }
}

```

ConcreteDecoratorA.java

```
public class ConcreteDecoratorA extends Decorator {
    public ConcreteDecoratorA(Component component) {
        super(component);
    }

    @Override
    public void methodA() {
        super.methodA();
        //추가
    }

    @Override
    public void methodB() {
        super.methodB();
    }

    public void newBehavior() {

    }
}

```

### 실사용 예제 - [java.io](http://java.io)

우리는 데코레이터 패턴을 자주 사용하고 있습니다. 백준 알고리즘을 풀어 본 사람들은 java의 i/o stream 을 사용하여 터미널 또는 파일을 통해서 입력을 받아 들이게 되는데 아래의 코드를 보면 더욱 잘 이해 될것입니다.

```
public class Main {
    public static void main(String[] args) {
        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));
    }
}

```

더욱 이해가 쉽게 풀어서 보면 아래의 코드와 같은 역할을 하는데 코드를 보며 설명이 이어 가겠습니다.

```
InputStream in = System.in;
InputStreamReader inputStreamReader = new InputStreamReader(in);
BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

```

InputStreamReader, BufferedReader는 Reader 라는 추상 클래스 상속 받은 Decorator 객체 입니다.

InputStreamReader.java

```
public class InputStreamReader extends Reader {

    private final StreamDecoder sd;

    /**
     * Creates an InputStreamReader that uses the default charset.
     *
     * @param  in   An InputStream
     */
    public InputStreamReader(InputStream in) {
        super(in);
        try {
            sd = StreamDecoder.forInputStreamReader(in, this, (String)null); // ## check lock object
        } catch (UnsupportedEncodingException e) {
            // The default encoding should always be available
            throw new Error(e);
        }
    }

```

sd 가 여기서 기본 객체의 InputStream을 Reader을 상속 받은 StreamDecoder 객체로 변환하여 유지하고 있습니다. 기존 InputStream은 byte 단위로 데이터를 처리하는 InputStreamReader로 랩핑을 함으로써 char 단위로 읽어 들이고 BufferedReader로 랩핑해서 입력받은 데이터를 line단위로 읽어 들이는 등 기능을 강화해서 사용하고 있습니다.

BufferedReader.java

```
public class BufferedReader extends Reader {

    private Reader in; //인스턴스 유지

    private char cb[];
    
    ...
    public BufferedReader(Reader in, int sz) {
        super(in);
        if (sz <= 0)
            throw new IllegalArgumentException("Buffer size <= 0");
        this.in = in;
        cb = new char[sz];
        nextChar = nChars = 0;
    }

```

### 단점

지금까지는 이점과 사용하는 이유에 대해서 이야기 했습니다. 하지만 데코레이터 패턴의 단점 또한 존재합니다.

1. 많은 클래스가 생성됩니다.

결국 계속 새로운 객체를 생성해서 그 객체를 다시 파라미터로 넘겨 새로운 객체를 만들기 때문에 메모리를 낭비하게 됩니다. 데코레이터를 많이 사용하면 시스템이 복잡해질 수 있으며, 코드를 추적하기 어려워질 수 있습니다.

2. 객체 생성 순서가 중요합니다.

강화하면 새로운 객체가 만들어지게 되는데 여러번 랩핑하는 경우 순서를 달리 하는경우 특정 테코레이터로 강화해야 하는 경우가 발생할 수 있습니다. 위에 BufferedReader 의 경우도 마찬가지 입니다. 구성 요소 간의 의존성이 증가하여 버그가 발생할 가능성이 높아질 수 있습니다.

3. 객체의 깊은 복사가 어렵습니다.

결국 객체는 강화된 객체를 인스턴스로 가지고 있지만 강화 이전의 객체 정보 접근에 제한이 존재합니다.

### 한문장 정리

**특정 객체의 기능에 추가 기능을 랩핑을 함으로써 그 객체의 기능을 강화시키는 방법**

### 마무리

오늘은 우테코, 싸피 등 여러 상황들로 인해 디자인 패턴 관련글 업로드를 미루고 있었습니다. 이후 계속해서 공부한 내용을 글로 정리해서 올리겠습니다. 감사합니다.

---', '2024-11-19 13:53:00', 0, 1, (SELECT id FROM category WHERE name='디자인패턴' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('팩토리 패턴 (Factory Pattern)', '## 팩토리 메소드 패턴이란?

> 팩토리 메소드 패턴 (Factory Method Pattern) 에서는 객체를 생성할 때 필요한 인터페이스를 만듭니다. 어떤 클래스의 인스턴스를 만들지는 서브클래스에서 결정합니다. 팩토리 메소드 패턴을 사용하면 클래스 인스턴스 만드는 일을 서브클래스에게 맡기게 됩니다.

위에 내용은 **헤드 퍼스트 디자인패턴**에서 팩토리 메소드 패턴을 정의입니다. 책의 내용을 토대로 팩토리 메소드를 공부하면서 알게된 내용을 이야기 해보겠습니다.

## Simple Factory

팩토리 패턴을 본격적으로 알아보기 전에 ‘간단한 팩토리’의 대해서 이야기 해보려고 합니다.

> 객체 생성을 전담하는 create…() 함수를 하나의 클래스에 모아놓는 방법 - simple factory

Simple Factory 디자인 패턴은 아니지만 프로그래밍에서 자수 쓰이는 관용구와 관습에 가깝습니다. java 라이브러리에 **Class BorderFactory**가 존재합니다. 확인해보면 메소드들이 create….()로 앞에 create가 키워드가 붙은 메소드들이 경계선등의 라인객체를 생성합니다. 이제 진짜 팩토리 패턴 2가지에 대해서 이야기 해보겠습니다.

## 생성

‘new’ 연산자를 우리는 객체를 생성할때 정말 자주 사용합니다. 우리는 추상클래스 또는 인터페이스를 구현하는 구상 클래스 만들때의 코드는 아래와 같이 구상객체를 인스터시에이션(Instantiation)합니다.

```
Duck duck = new MallardDuck();

```

그런데 여러 구상 클래스가 존재하는 경우를 아래의 코드처럼 작성하게 됩니다.

```
Duck duck;
if(picnic){
	duck = new MallardDuck(();
} else if(hunting){
	duck = new DecoyDuck();
} else if(inBathTub) {
	duck = new RubberDuck();
}

```

하지만 이렇게 특정 조건을 이용해서 어떤 구상클래스를 생성할 지를 if문을 이용하게 되면 구상 클래스의 수가 늘어나는 경우 매번 수정을 해야합니다. 전에 다른 디지안 패턴 글에서 언급했던 OCP에 어긋나게 되고 즉, 변경에 닫혀있는 코드가 되게 됩니다. 이러한 문제를 팩토리 패턴을 이용해서 해결할 수 있습니다.

피자가게를 예를 들어 설명하겠습니다.

```
    Pizza orderPizza(String orderType) {
        Pizza pizza = null;
        
        if(orderType.equalsIgnoreCase("cheese")) {
            pizza = new CheesePizza();
        }else if(orderType.equalsIgnoreCase("pepperoni")) {
            pizza = new PepperoniPizza();
        }else if(orderType.equalsIgnoreCase("clam")) {
            pizza = new ClamPizza();
        }
        
        pizza.prepare();
        pizza.bake();
        pizza.cut();
        pizza.boxing();
        return pizza;
    }

```

위 코드에도 if문을 통해서 어떤 피자를 원하는지 조건에 따라 인스턴시에이션 해주게 됩니다. 그런데 마찬가지로 피자의 종류가 늘어나는 경우 결국 코드를 계속해서 요구사항의 변경에 따라 수정하게 됩니다. 그래서 객체 생성 부분을 별도로 분리하여 캡슐화 하여 새로운 객체를 만들어 주고 이 객체를 팩토리라고 명명하게 됩니다.

```
public class SimplePizzaFactory {
    public Pizza createPizza(String type) {
        Pizza pizza = null;
        if(type.equalsIgnoreCase("cheese")) {
            pizza = new CheesePizza();
        }else if(type.equalsIgnoreCase("pepperoni")) {
            pizza = new PepperoniPizza();
        }else if(type.equalsIgnoreCase("clam")) {
            pizza = new ClamPizza();
        }
        return pizza;
    }
}

```

위에서 언급한 Simple Factory라고 생각하면 됩니다. 책에서는 일반 멤버 함수로 만들었지만 위에 경우 클래스에 데이터 멤버가 존재하지 않기 때문에 static 멤버 함수로 구현하여도 무방하다고 생각합니다.

```
public class PizzaStore {
	SimplePizzaFactory factory;
 
	public PizzaStore(SimplePizzaFactory factory) { 
		this.factory = factory;
	}
 
	public Pizza orderPizza(String type) {
		Pizza pizza;
 
		pizza = factory.createPizza(type);
 
		pizza.prepare();
		pizza.bake();
		pizza.cut();
		pizza.box();

		return pizza;
	}
}

```

그래서 PizzaStore의 코드는 조건문을 없애고 위와같은 코드로 바꿀수 있습니다.

## Factory Method Pattern

위에 피자 예제는 pizza factory와 store가 한개씩 존재하는 상태입니다. 여기서 예제를 여러지점들이 존재하고 각 지점마다 그 지역의 특성과 입맛을 반영한 다양한 스타일의 피자(뉴욕,시카고,이탈리아 등)를 만들어야 한다고 가정해 보겠습니다. 위에서 사용한 SimplePizzaFactory를 사용하지 않고 서로다른 팩토리를 만든 다음 PizzaStore에서 원하는 팩토리를 사용하도록하는 방법을 살펴 보겠습니다.

```
NYPizzaFactory nyFactory = new NYPizzaFactory();
PizzaStore nyStore = new PizzaStore(nyFactory);
nyStore.orderPizza("Veggie");

ChicagoPizzaFactory chicagoFactory = new ChicagoPizzaFactory();
PizzaStore chicagoStore = new PizzaStore(chicagoFactory);
nyStore.orderPizza("Veggie");

```

하지만 여기서 Factory들도 구상클래스이기 때문에 결국 Store 객체가 Factory 객체를 많이 언급하는게 좋지는 못하다고 판단합니다. 그래서 새로운 아이디어는 Factory객체는 내부에 멤버함수만 존재하기 때문에 별도의 클래스로 유지하는 것 보다는 멤버 함수를 분리시켜 Store객체에 만들어 주고 Factory를 삭제하자는 것입니다. 하지만 이것도 문제점이 존재합니다. PizzaStore는 추상클래스로 존재해야합니다.

```
public abstract class PizzaStore { 
	public Pizza orderPizza(String type) {
		Pizza pizza;
 
		pizza = createPizza(type);
 
		pizza.prepare();
		pizza.bake();
		pizza.cut();
		pizza.box();

		return pizza;
	}
	abstract createPizza(String type);
}

```

PizzaStore에서 우리가 집중해야하는 부분은 createPizza()함수를 추상함수로 만들어 줌으로써 각 지점(뉴욕,시카고,이탈리아 등)에 맞는 서브클래스를 만들어 주면 여러 Factory를 만들어 줄 필요가 없어지게 됩니다.

이 createPizza()함수가 팩토리 메소드 패턴의 핵심이라고 볼수 있습니다.

![](https://blog.kakaocdn.net/dna/bLk0Yd/btsLDYPtc75/AAAAAAAAAAAAAAAAAAAAAP_KEQFIEljcu-FSPyJhCJ0RhUyb26tlAUXacOUnSFo3/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=Bx04TrFUeInIwvnShDgQSteFCpY%3D)

위에 그림을 보면 조금 더 이해가 쉽게 될것입니다. 서브클래스에서 createPizza를 구현하게 되고 저부분의 코드는 위에 SimplePizzaFactory의 createPizza 함수처럼 들어온 파라미터 따라 조건문을 통해 pizza객체를 정해주게 됩니다. 그리고 orderPizza내부에서 createPizza 함수가 호출될 때 Dynamic binding으로 각 서브클래스의 overriding된 함수가 호출되게 됩니다.

### Factory Method Pattern 한문장 설명

> 객체 생성을 전담하는 함수를 부모클래스에 추상함수로 정의하고 그 함수를 하위클래스에서 override 하여 다양한 객체 생성을 실행하도록 하는 패턴

팩토리 메소드 패턴에서 2가지의 목적이 존재합니다.

1. 객체생성을 전담하는 함수를 만들자
2. 구상클래스가 상위클래스를 직접적인 언급하지 않고 간접적으로 언급 상호의존정의 낮추는 것

핵심은 **“사용하는 서브클래스에 따라 생산되는 객체 인스턴스가 결정 됩니다.”**

## 의존성 역전 원칙(Dependency Inversion Principle)

```
public class DependentPizzaStore {
 
	public Pizza createPizza(String style, String type) {
		Pizza pizza = null;
		if (style.equals("NY")) {
			if (type.equals("cheese")) {
				pizza = new NYStyleCheesePizza();
			} else if (type.equals("veggie")) {
				pizza = new NYStyleVeggiePizza();
			} else if (type.equals("clam")) {
				pizza = new NYStyleClamPizza();
			} else if (type.equals("pepperoni")) {
				pizza = new NYStylePepperoniPizza();
			}
		} else if (style.equals("Chicago")) {
			if (type.equals("cheese")) {
				pizza = new ChicagoStyleCheesePizza();
			} else if (type.equals("veggie")) {
				pizza = new ChicagoStyleVeggiePizza();
			} else if (type.equals("clam")) {
				pizza = new ChicagoStyleClamPizza();
			} else if (type.equals("pepperoni")) {
				pizza = new ChicagoStylePepperoniPizza();
			}
		} else {
			System.out.println("Error: invalid type of pizza");
			return null;
		}
		pizza.prepare();
		pizza.bake();
		pizza.cut();
		pizza.box();
		return pizza;
	}
}

```

위 코드는 우리가 팩토리 메소드 패턴을 사용하지 않았을 때 코드입니다.

## Abstract Factory Pattern

> 객체의 부속품에 해당하는 원재료(**Ingredient)**의 다양성을 반영하기 위해 원재료를 제공하는 팩토리 객체를 인터페이스로 정의하고 팩토리 인터페이스를 구현하는 다양한 팩토리 클래스를 정의 하는 방법

이 패턴은 다양성에 초점을 맞추어진 패턴입니다.

![](https://blog.kakaocdn.net/dna/zPgyj/btsLCGP1iwf/AAAAAAAAAAAAAAAAAAAAAEZXK40JSSkgV4zwFQZwIH3s3Ja7zQmW-URYeC2ouD-U/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=FFK7He%2BfxFXeAtYh6zV7CjCoRA8%3D)

## 한문장 정리

> 객체 생성을 전담하는 코드를 특정 함수에 집중시키는 패턴

---', '2025-01-03 20:03:00', 0, 1, (SELECT id FROM category WHERE name='디자인패턴' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('2025/01/03 근황올림픽', '너무 오랜만에 글을 작성하는 것 같습니다. 마지막으로 작성한 글이 테코레이터 패턴에 대한 글이었네요. 그동안 글쓰기가 뜸했던 이유는 우아한 테크코스 관련 일을 마무리하고 휴식을 취했기 때문입니다. 하지만 더 이상 쉬면 안 되겠다는 생각이 들어, 다시 공부 의지를 다짐하며 이렇게 글을 작성하게 되었습니다.

우선, 기쁜 소식과 나쁜 소식이 있습니다. 기쁜 소식은 제가 우아한 테크코스 1차에 합격했다는 점입니다. 12월 9일에 1차 합격 이메일을 받게 되었습니다.

그리고 12월 14일, 잠실에서 진행되는 최종 코딩 테스트에 참가할 기회를 얻게 되었습니다.

![](https://blog.kakaocdn.net/dna/k0sqX/btsLEsiuFX5/AAAAAAAAAAAAAAAAAAAAAJQINhBdRqnp1ITu-qmLzpxgl227aUxdFtVXM1PoCGQs/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=t4pWM8ABifHf3%2Bt7hbxsAIsaEu0%3D)

문제는 이 준비 기간이 제 마지막 대학 기말고사 기간과 겹쳤다는 점입니다. 또한, 1차 결과 발표까지 한 달 가까이 기다리는 시간이 길게 느껴져서 그 기다림도 꽤 힘들었습니다. 그 사이에 전공 과제로 간단한 AI 딥러닝 분류기를 만들어보긴 했지만, 정작 최종 코딩 테스트 준비는 제대로 하지 못했던 것 같아요. 지금 생각하니 단순 핑계 같아 마음이 무겁습니다. 😥

최종 테스트를 준비하기 위해 목요일에는 경기도에 있는 친구 집에서 머물렀습니다. 하지만 여기서 나쁜 소식이 시작됩니다. 테스트 당일, 친구 집에서 시험 장소까지 약 1시간 10분이 걸렸고, 이를 감안해 일찍 출발하여 11시 10분에 미리 도착했습니다. 입실 시간이 12시 정각이어서 주변을 산책하며 긴장을 풀어보려 했습니다. 하지만 막상 12시가 되어 입실하니 긴장감이 더욱 커지기 시작하더군요. 심지어 신분증 검사를 포비님께서 직접 해주셔서 더더욱 떨렸습니다. 😱

자리에 앉아 대기하는 동안에도 마음을 가라앉히기가 쉽지 않았습니다. 아래는 그날의 기념으로 찍은 사진입니다

  
![](https://blog.kakaocdn.net/dna/eupqvI/btsLBWZOHEm/AAAAAAAAAAAAAAAAAAAAAMRN1k52pU85dCqLYgw0m-XPflotKBdmTyB4SKT44OxF/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=lCzdkIXD2vtL2O7n8WeS%2FZk21AE%3D)

![](https://blog.kakaocdn.net/dna/usfOv/btsLCmRNMwe/AAAAAAAAAAAAAAAAAAAAABb-FfD_12p5NMX8UCNAEQSDxkmcVBBYKzWCiRQY-2y4/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=jhxHixz5%2Be8HOvuTtfkSFjPG7oE%3D)

그렇게 5시간 동안 내리 코딩을 했습니다. 하지만 결과는 1/5... 처참했습니다. 요구사항조차 전부 완성하지 못한 상태에서 끝났습니다. 하... 시험이 끝난 뒤에는 저 자신이 너무 싫어졌습니다. 완전히 기억나진 않지만, 마지막 소감으로 “기회를 주셔서 감사합니다”라고 적었던 것 같습니다. 그 순간만큼은 정말로 그렇게 느꼈거든요.

결과는 최종 탈락 ㅠㅠ

![](https://blog.kakaocdn.net/dna/rmSFR/btsLC0AIH9R/AAAAAAAAAAAAAAAAAAAAACjG5whyYlIFpj9QuIJnwOS-pENI2YBqLiEfZLWq8wRm/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=xzqSQf6sT8%2BHoak4cnJFNeKnwUs%3D)

처음 메일 받고 너무 슬펐습니다. 하지만 안된걸 어쩌겠습니까!! 제가 목표하는 개발자가 되기 위한 여러가지 길중 하나가 막힌것 뿐이라는 생각으로 더 힘내서 도전하기로 마음 먹었습니다. 계속해서 노력할 것입니다. 파이팅

---', '2025-01-03 20:13:00', 0, 1, (SELECT id FROM category WHERE name='일기' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('커맨드 패턴(Command Pattern)', '# 커맨드 패턴이란

> 커맨드 패턴을 사용하면 요청 내역을 객체로 캡슐화해서 객체를 서로 다른 요청 내역에 따라 매개변수화할 수 있습니다. 이러면 요청을 큐에 저장하거나 로그로 기록하거나 작업 취소 기능을 사용할 수 있습니다.

# 만능 리모컨

여기 재미있는 리모컨이 있다고 가정해 보겠습니다. 이 리모컨에는 프로그래밍이 가능한 7개의 슬롯이 있고 각 슬롯에 원하는 제춤을 연결한 다음 옆에있는 버튼으로 조각할 수 있습니다. 그리고 7개의 슬롯마다 각각 ‘ON’ 버튼과 ‘OFF’ 버튼이 존재합니다. 그리고 마지막으로 ‘UNDO’ 버튼이 존재합니다. 우리는 이 리모컨을 여러 다양한 기기를 제어할 수 있는 만능리모컨으로 만들 예정입니다.

![](https://blog.kakaocdn.net/dna/dWFGy9/btsMAVZa0Vh/AAAAAAAAAAAAAAAAAAAAAM6NuJ9BCQADZhEHmVL8pwWBgSBVuYCj9aCYoaDFOg3n/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=DzwJbKhH7jraiz1vzTcJDbfZMOs%3D)

위에 다이얼로그는 리모컨으로 제어해야하는 객체입니다. 클래스가 많은데 공통적인 인터페이스가 있는 것 같진 않습니다. 더 큰 문제는 앞으로 이러한 클래스가 더 추가될 수 있다는 것입니다. 우리는 만능 리모컨을 만들기 위해서 커맨드 패턴을 적용해 보겠습니다. 그럼 커맨드 패턴에 대해서 더 알아보겠습니다.

# 커맨드 패턴 소개

책에서는 커맨드 패턴의 예제로 식당에서 고객과 웨이터 그리고 주문과 주방장 상이의 관계를 다시 살펴보면 커맨드 패턴 속 각 객체 사이의 관계를 쉽게 이해할 수 있을 겁니다. 객체들이 어떤 식으로 분리되는지 감을 잡을 수 있습니다.

**음식 주문 과정**

1. 고객이 종업원에게 주문을 합니다.
2. 종업원은 주문을 받아서 카운터에 전달하고 “주문 들어왔어요!!” 라고 합니다.
3. 주방장은 주문대로 음식을 준비합니다.

**객체와 메소드 과정**

1. 고객.createOrder();
2. 종업원.takeOrder();
3. 종업원.orderUp();
4. 주방장.makeBurger(), makeShake()
5. 결과 return

위에 과정이 이해되지 않을 수 있습니다. 이해를 돕기 위해서 커맨드 패턴을 적용해서 추가로 설명해보겠습니다.

### 1. 리시버

실제 동작이 정의된 리시버를 구현한다.

### 2. 커맨드

인보커(리모컨)에 탑재하기 위한 명령어 클래스를 만든다.

명령어 클래스는 리시버에 존재하는 기능을 활용하여 구현한다. 명령어의 일관성을 위해 Command 인터페이스를 구현하는 형태로 작성한다.

### 3. 인보커

setCommand 메소드를 통해서 인보커에 명령어를 할당받을 수 있도록한다.

명령어 클래스의 명령을 수행 할 수있는 메소드를 구현한다.

### 4. 클라이언트

명령어 인스턴스를 생성하며, 생성자로 리시버를 주입한다.

리시버가 주입된 명령어를 인보커에 주입한다.

인보커는 명령을 수행하면 주입된 커맨드의 메소드를 실행한다.

커맨드의 메소드는 리시버의 메소드를 호출한다.

그럼 앞서 말한 리모컨 예제를 직접 코드로 구현하면서 이야기를 이어가 보겠습니다.

# 커맨드 객체 만들고 사용하기

가장 먼저 커맨드 객체는 모두 같은 인터페이스를 구현해야 합니다. 위에 식당예제에서 종업원의 orderUp()의 메서드는 일반적으로 execute()라는 메서드명을 자주 사용합니다.

```
public interface Command {
	public void execute();
}

```

다음으로는 조명을 켜고 끄는 행위를 하는 커맨드 클래스를 구현해 보겠습니다. 리모컨 예제 속 제공된 Light 클래스의 메서드 2개를 사용하는 커맨드 객체의 코드는 아래와 같습니다.

![](https://blog.kakaocdn.net/dna/dJAbeN/btsMCtGU3Ko/AAAAAAAAAAAAAAAAAAAAANUPAywpZzjRwO483B1GTTYqcVJtq43v8CVa4X0e4dbE/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=dKrQcVSnxpYXQpt25ed3iQlULhg%3D)

```
public class LightOnCommand implements Command {
	Light light;

	public LightOnCommand(Light light) {
		this.light = light;
	}

	public void execute() {
		light.on();
	}
}

```

```
public class LightOffCommand implements Command {
	Light light;
 
	public LightOffCommand(Light light) {
		this.light = light;
	}
 
	public void execute() {
		light.off();
	}
}

```

코드를 확인해보면 커맨드 객체를 구현하였기 떄문에 Command 인터페이스를 구현하고 있고 생성자에 파라미터를 통해 이 커맨드 객체를 제어할 특정 조명 객체의 레퍼런스를 전달 받게 됩니다 . 이 레퍼런스를 데이터 멤버로 저장해서 execute() 메소드가 호출되면 light객체가 바로 그 요청의 리시버가 됩니다.

# 커맨드 객체 만들고 사용하기

제어할 기기를 연결할 슬롯과 버튼이 각각 하나씩 밖에 없는 리모컨에 커맨드 객체를 사용해 봅시다.

```
public class SimpleRemoteControl {
	Command slot;
 
	public SimpleRemoteControl() {}
 
	public void setCommand(Command command) {
		slot = command;
	}
 
	public void buttonWasPressed() {
		slot.execute();
	}
}

```

커맨드를 저장할 스롯1개가 있고 기기 1개를 제어 할 수 있습니다. setCommand(newCommand) 메소드를 이용해 제어할 기기를 변경할 수 있습니다. SimpleRemoteControl 객체는 인보커 객체 입니다. 그리고 책에서 가단한 테스트 코드도 제공하고 있습니다.

```
public class RemoteControlTest {
	public static void main(String[] args) {
		SimpleRemoteControl remote = new SimpleRemoteControl();
		Light light = new Light();
		LightOnCommand lightOn = new LightOnCommand(light);
 
		remote.setCommand(lightOn);
		remote.buttonWasPressed();
    }
	
}

```

# 커맨드 패턴 활용하기

```
public class RemoteLoader {
 
	public static void main(String[] args) {
		RemoteControl remoteControl = new RemoteControl();
 
		Light livingRoomLight = new Light("Living Room");
		Light kitchenLight = new Light("Kitchen");
		CeilingFan ceilingFan= new CeilingFan("Living Room");
		GarageDoor garageDoor = new GarageDoor("Garage");
		Stereo stereo = new Stereo("Living Room");
  
		LightOnCommand livingRoomLightOn = 
				new LightOnCommand(livingRoomLight);
		LightOffCommand livingRoomLightOff = 
				new LightOffCommand(livingRoomLight);
		LightOnCommand kitchenLightOn = 
				new LightOnCommand(kitchenLight);
		LightOffCommand kitchenLightOff = 
				new LightOffCommand(kitchenLight);
  
		CeilingFanOnCommand ceilingFanOn = 
				new CeilingFanOnCommand(ceilingFan);
		CeilingFanOffCommand ceilingFanOff = 
				new CeilingFanOffCommand(ceilingFan);
 
		GarageDoorUpCommand garageDoorUp =
				new GarageDoorUpCommand(garageDoor);
		GarageDoorDownCommand garageDoorDown =
				new GarageDoorDownCommand(garageDoor);
 
		StereoOnWithCDCommand stereoOnWithCD =
				new StereoOnWithCDCommand(stereo);
		StereoOffCommand  stereoOff =
				new StereoOffCommand(stereo);
 
		remoteControl.setCommand(0, livingRoomLightOn, livingRoomLightOff);
		remoteControl.setCommand(1, kitchenLightOn, kitchenLightOff);
		remoteControl.setCommand(2, ceilingFanOn, ceilingFanOff);
		remoteControl.setCommand(3, stereoOnWithCD, stereoOff);
  
		System.out.println(remoteControl);
 
		remoteControl.onButtonWasPushed(0);
		remoteControl.offButtonWasPushed(0);
		remoteControl.onButtonWasPushed(1);
		remoteControl.offButtonWasPushed(1);
		remoteControl.onButtonWasPushed(2);
		remoteControl.offButtonWasPushed(2);
		remoteControl.onButtonWasPushed(3);
		remoteControl.offButtonWasPushed(3);
	}
}

```

위 코드 처럼 main에서 사용할 수 있습니다. 아래는 실행 결과 입니다.

```
------ Remote Control -------
[slot 0] LightOnCommand           LightOffCommand
[slot 1] LightOnCommand           LightOffCommand
[slot 2] CeilingFanOnCommand      CeilingFanOffCommand
[slot 3] StereoOnWithCDCommand    StereoOffCommand
[slot 4] NoCommand                NoCommand
[slot 5] NoCommand                NoCommand
[slot 6] NoCommand                NoCommand

Living Room light is on
Living Room light is off
Kitchen light is on
Kitchen light is off
Living Room ceiling fan is on high
Living Room ceiling fan is off
Living Room stereo is on
Living Room stereo is set for CD input
Living Room stereo volume set to 11
Living Room stereo is off

```

### NoCommand 객체

위 실행 결과를 확인하면 4~6번 슬롯에 null이 아닌 NoCommand 라고 표시된 것을 확인할 수 있습니다. 여기서 NoCommand 는 일종의 널 객체(null object)입니다. 널 객체는 리턴 시 리턴하는 객체가 딱히 존재하지 않지만 null로 처리하지 않고 싶을때 활용하기 좋은 방법입니다. 다른 커맨드 객체와 동일하게 Command 인터페이스를 구현되어 execute() 메소드가 호출되어도 문제가 발생할지 않습니다

특정 슬롯을 쓰려고 할 떄마다 거기에 뭔가가 로딩되어 있는지 확인 하려면 좀 번거로워지게 됩니다. 로딩 현황을 파악하려면 아래의 코드처럼 해야합니다.

```
public void OnButtonWasPushed(int slot){
	  if (onCommands[slot] != null){
			  onCommands[slot].excute();
		}
}

```

그래서 일을 줄이려고 아무것도 하지 않는 커맨드 클래스를 구현하죠.

```
public class NoCommand implements Command {
	public void execute() { }
}

```

아래의 코드 처럼 생성자에서 기본 커맨드를 NoCommand 객체로 초기화 해서 나중에 사용하고 싶은 커맨드 객체를 세팅해주면 null을 따로 처리할 필요가 없어지게 됩니다.

```
Command noCommand = new NoCommand();
		for (int i = 0; i < 7; i++) {
			onCommands[i] = noCommand;
			offCommands[i] = noCommand;
		}

```

# 한마디 정리

> 행위를 매개변수화 할수 있다

---', '2025-03-04 21:11:00', 0, 1, (SELECT id FROM category WHERE name='디자인패턴' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('C_포인터 사용 목적', '| #include #define NULL (0) main(){     int a,b;     int *ap;     int *bp;     printf("sizeof(int*) = %d\n",sizeof(int*));     printf("%d %d %d %d\n",&a,&b,&ap,&bp);     ap = &a; //&는 a의 주소를 나타냄,주솟값은 정수가 아니다.     bp = &b;     //ap =0; 은 아무것도 안가르킨다는 뜻 -> ap = NULL; 그냥 숫자 0을 쓰면 가독성 떨어져서 NULL쓴다     a = 10;     b = 20;     *ap = 100;     *bp =*bp+200;     printf("a = %d, b = %d\n",a,b);     bp = bp +3; //int 단위로 4byte를 3번 더해 bp는 a의 주솟값을 가리키게 된다. 포인터의 연산 덧셉은 역방향이다.b->a     *bp =1000;       // ap = 3930293;는 기본적으로 포인터에 물리적으로 수를 넣거나 연사을 하지마라     printf("a = %d, b = %d\n",a,b);     ap = ap-3; //포인터의 뺄셈은 정방향 a->b     *ap =1000;     printf("a = %d, b = %d\n",a,b);} |
|---|

포인터의 사용 목적 
1.Call by  reference
2.배열과 혼용하기 위해서 
3.Dymamic allocation(동적 할당)
4.사물들 끼리의 관계를 표현하기 위해서
자바과 c#에서는 1.2의 이유로는 사용하지 않는다. 3.4의 목적은 c#과 자바에서 reterence로 대신 사용된다. 4번의 목적은 date structure에서 중요하게 사용되기 때문에 나중에 조금더 자세히 알아볼 예정이다.

&a의 &는 a의 주소를 나타냄,주솟값은 정수가 아니다. addness of a 라고 부른다.

포인터 연산  bp = bp +3;  에서 폰인터 int형 일때 4byte를 3번 더해 bp는 a의 주솟값을 가리키게 된다. 포인터의 연산 덧셉은 역방향이다.b->a

EX)

| bp |  |  | ap |  |  | b |  |  | a |
|---|---|---|---|---|---|---|---|---|---|
| 1922096 |  |  | 19922084 |  |  | 19922072 |  |  | 1992060 |

위 그림에서 한칸 4byte이고 아래 숫자가 주소값이라고 했을때 비주얼해서는 프로그램의 안전을 위해 8byte의 공간을 확보하고 메모리에 저장을 시키다. 여기서 1한칸에 4byte이기 때문에 +3 을 하면 bp가 가르키는 주소는 a의 주솟값이 되기 때문에 bp의 값을 변화시키면 a의 값이 변하게 된다. 이러한 방법으로 포인터를 연산하면 지금 작성중인 프로그램 뿐 아니라 다른 운영체제나 프로 그램의 영향을 줄수 있어 예측가능한 상확이 아니라면 사용을 자제 해야 한다. 그리고 절대 포인터 값 자체의 물리적은 수를 넣거나 연산하는 행위는 절대 하지 말자.', '2022-04-26 17:19:00', 0, 1, (SELECT id FROM category WHERE name='언어/C언어' LIMIT 1));
INSERT INTO post (title, content, reg_date, view_count, account_id, category_id) VALUES ('C_string_strcpy', '| #include <stdio.h>#include <string.h>void my_strcpy(char *to,char *from){     while(*to++ = *from++);}main(){     //char *x = "kim";     char *x = "Kim taegyun";     char y[4]; // 이렇게 되면 기억 장소가 확보 되어 있어야 다른 변수의 기억장소에 영향을 주는 것을 막을 수 있다.     //충분히 넉넉하게 용량을 확보 해야 한다.     //char *y = "Lee";// x,y 둘다 기억장소를 가르키고 있을때     //x의 "Kim"을 y의 "Lee"는 static area에 옮길때 상수풀에 있어 수정을 할수 없기 때문에 런타임 에러가 뜬다.     //char *y; // <= 쓰레기 값 우리가 접근이 안되서 런타임에러     /*     char *x = "kim";     char y[10];     */     my_strcpy(y,x);     //strcpy(y,x);     printf("y = %s\n",y);     //strcpy 사용시 주의할점     //} |
|---|

strcpy함수는 문자열을 복사할 때 사용되는 함수이다. strcpy함수를 사용할 때 주의 할점은 크게 3가지 정도가 존재한다. 첫번째는 문자열을 복사해서 값을 수정할때 수정되는 값이 저장되는 공간을 확보하지 않는 경우 Ex) char *y; 의 경우 y가 가르키는 곳의 쓰레기 값이 들어가 있어 런타임 에러가 발생하게 된다.

두번째는 y의 이미 다른 문자열이 초기화되어 있다면 메모리 static area에 상수풀에 있어 수정할 수 없기 때문이 이또한 런타임 에러가 발생하게 된다. 그리고 마지막 세번째는 저장되는 y의 충분한 장소가 확보되어 있지 않으면 당장은 실행 될수 도 있지만 다른 변수의 주솟값에 영향을 주어 아주 특이한 값변화가 일어나 통제가 힘들기 때문에 충분한 공간을 확보해야 한ㄷ.', '2022-04-27 15:51:00', 0, 1, (SELECT id FROM category WHERE name='언어/C언어' LIMIT 1));

-- Done: 74 posts
