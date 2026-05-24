---
title: "Dailelog 개발일지 -1.현재 진행 사항"
date: "2024. 8. 14. 21:17"
category: "Dailelog"
url: "https://basakreview.tistory.com/61"
---
현재 기능을 크게 로그인,게시글,댓글  3가지가 존재합니다.

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

---

## 📷 이미지 목록

- 이미지 1: https://blog.kakaocdn.net/dna/NleEY/btsI5d9f57O/AAAAAAAAAAAAAAAAAAAAACLG2a6-gjsHwmlweVo2NR9CxLE6X24tXdyf2b17Gqd-/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=dWN%2BTvrdJZeWuHXpBlcKUmUz3VY%3D
- 이미지 2: https://blog.kakaocdn.net/dna/boz5ZJ/btsI5AXsQOt/AAAAAAAAAAAAAAAAAAAAAGbI4CwtBwdlnp2o5BhaT7WhdQRdk_VFn8aKx_r_jLD7/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=zhEe1oM3NgkbU1NXO0PYUwO7%2FgU%3D
- 이미지 3: https://blog.kakaocdn.net/dna/bKYmPw/btsI42G2AEG/AAAAAAAAAAAAAAAAAAAAALu8IramyxbByzg_fSG_R6a-H2-mXDU4tP4RH_P9_0bP/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=GrKq2eeRG027QSW1Vc7Q7%2B45hc0%3D
- 이미지 4: https://blog.kakaocdn.net/dna/PTOaG/btsI5lTRSkw/AAAAAAAAAAAAAAAAAAAAAOvhILMDSAt9xscF5HKiRdCiMV6ithwMbLXDHEKtuzrj/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=Psjc%2B1N55%2BZIq3fWL5kCFdJ3dnA%3D
- 이미지 5: https://blog.kakaocdn.net/dna/ciEHXU/btsI3QnkGwK/AAAAAAAAAAAAAAAAAAAAAMdJoKUlW_WYGJwKcnlg33qe6PYOqR1JRsN70CUIJ0Xu/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=S8ASyE1Ly1R0zeA5pCX9CrVtsAg%3D
- 이미지 6: https://blog.kakaocdn.net/dna/b3iGRM/btsI5SKsPDg/AAAAAAAAAAAAAAAAAAAAAExlc87tlwkI-socEJwXN1F5mf1b0vFfpRgySQlkn8Nv/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=l4Jn6LhvWRi2LOx%2BwAYyTQ1cjUU%3D
- 이미지 7: https://blog.kakaocdn.net/dna/ckL6y7/btsI3KnmHRx/AAAAAAAAAAAAAAAAAAAAADuVH7L2KqbimFb9DYmfl470wdV-hLUayeqzqb48XL0j/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=k9IKXyDq%2BQHyOr%2BSoL5Hiu2Qvm0%3D
- 이미지 8: https://blog.kakaocdn.net/dna/bGeBpB/btsI4oRm6wV/AAAAAAAAAAAAAAAAAAAAAFsTh_IBlnKXTj5B42qH-ovKo9E7Xq19T1ZeMAV5rWLU/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=TWqkbKglD4YFCg%2F40owNRdR74mU%3D
- 이미지 9: https://blog.kakaocdn.net/dna/uF0VI/btsI5ibSnSi/AAAAAAAAAAAAAAAAAAAAAFLORKJP4JKjwmjt_DrNuVkCUiHtcXTGKl2-1xUIoxer/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=oGl424nxzFUkxK8YH3AXdWWMzcI%3D
- 이미지 10: https://blog.kakaocdn.net/dna/ejwHSj/btsI3ZLaQlv/AAAAAAAAAAAAAAAAAAAAAODsFvre_TvVxMY5_MXlFgKgaD1qZdPXe070nMBcHDIH/img.png?credential=yqXZFxpELC7KVnFOS48ylbz2pIh7yKj8&expires=1780239599&allow_ip=&allow_referer=&signature=PDmrOxdEteR%2F4HmJZYxqNoIfG%2Bs%3D