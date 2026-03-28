package org.sinabro.fintree;

import lombok.RequiredArgsConstructor;
import org.sinabro.fintree.domain.Difficulty;
import org.sinabro.fintree.domain.Quiz;
import org.sinabro.fintree.domain.QuizOption;
import org.sinabro.fintree.domain.SkillNode;
import org.sinabro.fintree.repository.SkillNodeRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * FinTree 스킬 트리 초기 데이터 시딩
 * 공통 3단계 → 7개 분기 (각 4노드) → 마스터 3노드
 */
@Order(10)
@Component
@RequiredArgsConstructor
public class FinTreeDataSeeder implements CommandLineRunner {

    private final SkillNodeRepository repo;

    @Override
    @Transactional
    public void run(String... args) {
        if (repo.count() > 0) return;

        // ───────── 공통 3단계 ─────────
        SkillNode common1 = node("금융 기초", "돈의 가치와 금융의 역할을 이해합니다.", commonContent("금융 기초",
                "금융은 돈이 필요한 곳과 돈이 남는 곳을 이어주는 시스템입니다.\n\n" +
                "## 화폐의 기능\n- **교환의 매개**: 물물교환의 불편함을 해결\n- **가치 척도**: 상품·서비스의 가치를 숫자로 표현\n- **가치 저장**: 미래에 사용하기 위해 저장\n\n" +
                "## 금융의 역할\n금융기관(은행, 증권사 등)은 **저축자의 돈**을 모아 **투자자·차입자**에게 공급합니다.\n\n" +
                "## 이자율이란?\n이자율은 돈을 빌리는 **비용**이자 저축의 **보상**입니다.\n예시: 100만 원을 연 5% 금리로 저축 → 1년 후 105만 원"),
                Difficulty.BEGINNER, 10, 0, List.of());

        SkillNode common2 = node("경제 기초", "물가, 금리, 경기 사이클의 상호 관계를 파악합니다.", commonContent("경제 기초",
                "## 물가와 인플레이션\n물가가 오르면 같은 돈으로 살 수 있는 것이 줄어듭니다. 이를 **인플레이션**이라고 합니다.\n\n" +
                "## 금리와 경기\n- 금리 인상 → 대출 비용 증가 → 소비·투자 감소 → 물가 안정\n- 금리 인하 → 대출 비용 감소 → 소비·투자 증가 → 경기 부양\n\n" +
                "## 경기 사이클\n경기는 **확장 → 정점 → 수축 → 저점** 을 반복합니다.\n각 단계에서 유리한 자산이 다릅니다."),
                Difficulty.BEGINNER, 12, 1, List.of(common1));

        SkillNode common3 = node("금융 상품 기초", "예금·적금·펀드·주식·보험을 비교하고 차이점을 설명합니다.", commonContent("금융 상품 기초",
                "## 금융 상품의 분류\n| 상품 | 수익 | 위험 | 유동성 |\n|------|------|------|--------|\n| 예금·적금 | 낮음 | 낮음 | 중 |\n| 채권 | 중 | 낮음 | 중 |\n| 펀드 | 중 | 중 | 높음 |\n| 주식 | 높음 | 높음 | 높음 |\n| 보험 | 보장 | - | 낮음 |\n\n" +
                "## 위험·수익 상충관계\n수익이 높은 상품일수록 위험도 높습니다. 자신의 **투자 성향**과 **투자 기간**에 맞게 선택해야 합니다."),
                Difficulty.BEGINNER, 15, 2, List.of(common2));

        repo.saveAll(List.of(common1, common2, common3));
        repo.flush();

        // ───────── 7개 분기 ─────────
        // 분기 0: 보험
        SkillNode ins1 = node("보험 기초", "보험의 기본 원리와 필수 보장을 이해합니다.",
                branchContent("보험 기초", "보험은 **위험 분산**의 도구입니다.\n\n" +
                "## 보험의 원리\n많은 사람이 소액을 납입해 큰 사고를 당한 일부에게 보험금을 지급합니다.\n\n" +
                "## 필수 보험 3종\n1. **실손보험**: 실제 병원비를 보전\n2. **종신/정기보험**: 사망 시 유가족 보호\n3. **운전자보험**: 교통사고 법적 비용 보장"),
                Difficulty.BEGINNER, 12, 10, List.of(common3));

        SkillNode ins2 = node("보험 설계", "내 상황에 맞는 보험 포트폴리오를 구성합니다.",
                branchContent("보험 설계", "## 생애 주기별 필요 보험\n" +
                "- 20대: 실손 + 운전자\n- 30대 기혼: + 정기보험(사망), 어린이보험\n- 40~50대: 암·중증 질환 특약 보강\n\n" +
                "## 보험료 절감 팁\n- 순수 보장형 vs 저축형 — 보장만 필요하면 순수 보장형이 저렴\n- 갱신형 vs 비갱신형 — 장기 보유 시 비갱신형 유리"),
                Difficulty.INTERMEDIATE, 15, 10, List.of(ins1));

        SkillNode ins3 = node("보험금 청구", "사고 발생 시 보험금 청구 절차를 정확히 따릅니다.",
                branchContent("보험금 청구", "## 청구 절차\n1. 사고 발생 → 증거 확보(사진, 진단서)\n2. 보험사 사고 접수(콜센터/앱)\n3. 서류 제출(진단서, 영수증 등)\n4. 심사 → 보험금 지급\n\n" +
                "## 자주 놓치는 항목\n- 비급여 진료도 실손 청구 가능\n- 교통사고 치료비는 운전자보험 우선"),
                Difficulty.INTERMEDIATE, 12, 10, List.of(ins2));

        SkillNode ins4 = node("보험 고급 전략", "변액보험과 법인 보험을 활용한 세금 절감 전략",
                branchContent("보험 고급 전략", "## 변액보험\n보험료 일부를 펀드에 투자해 수익을 추구합니다.\n- 투자 위험은 계약자 부담\n- 비과세 혜택 있음(10년 이상 유지 시)\n\n" +
                "## 법인 보험 활용\n법인이 임원 보험료를 납입하면 손금 처리 가능(조건부)"),
                Difficulty.ADVANCED, 20, 10, List.of(ins3));

        // 분기 1: 주식/ETF
        SkillNode stk1 = node("주식 기초", "주식의 개념과 주가 움직임의 원리를 이해합니다.",
                branchContent("주식 기초", "## 주식이란?\n기업의 **소유권 일부**를 나타내는 증서입니다.\n\n" +
                "## 주가 결정 요인\n- 기업 실적(EPS)\n- 금리 환경\n- 시장 심리(PER 밸류에이션)\n\n" +
                "## 기본 지표\n- **PER**: 주가 / 주당순이익 — 낮을수록 저평가\n- **PBR**: 주가 / 주당순자산 — 1 미만이면 청산가치 이하"),
                Difficulty.BEGINNER, 15, 11, List.of(common3));

        SkillNode stk2 = node("ETF 투자", "ETF의 구조와 장단점을 이해하고 포트폴리오를 구성합니다.",
                branchContent("ETF 투자", "## ETF란?\n**상장지수펀드** — 주식처럼 거래되는 펀드입니다.\n\n" +
                "## 장점\n- 분산투자 (단일 ETF로 수십~수천 종목)\n- 낮은 비용(운용보수 0.01~0.5%)\n- 실시간 매매 가능\n\n" +
                "## 주요 ETF 유형\n- 시장 전체: KODEX 200, SPY(S&P 500)\n- 섹터: 반도체, 2차전지\n- 채권, 원자재, 리츠"),
                Difficulty.INTERMEDIATE, 18, 11, List.of(stk1));

        SkillNode stk3 = node("종목 분석", "재무제표를 읽고 저평가 주식을 발굴하는 방법",
                branchContent("종목 분석", "## 재무제표 3대장\n- **손익계산서**: 매출·영업이익·순이익\n- **재무상태표**: 자산·부채·자본\n- **현금흐름표**: 영업·투자·재무 현금흐름\n\n" +
                "## 밸류에이션 방법\n- DCF(현금흐름할인법)\n- 상대평가(업종 평균 PER 비교)"),
                Difficulty.INTERMEDIATE, 20, 11, List.of(stk2));

        SkillNode stk4 = node("투자 전략", "모멘텀·가치투자·퀀트 전략을 비교하고 적용합니다.",
                branchContent("투자 전략", "## 가치 투자\n내재가치보다 싼 주식을 사서 장기 보유 (버핏 방식)\n\n" +
                "## 모멘텀 투자\n최근 상승세가 강한 종목에 올라타기\n\n" +
                "## 퀀트 투자\n재무 데이터 기반 알고리즘으로 종목 선정"),
                Difficulty.ADVANCED, 20, 11, List.of(stk3));

        // 분기 2: 연금
        SkillNode pen1 = node("국민연금", "국민연금의 구조와 수령액 예측 방법을 이해합니다.",
                branchContent("국민연금", "## 국민연금이란?\n국가가 운영하는 **의무 가입** 공적 연금입니다.\n\n" +
                "## 수령액 계산\n수령액 ∝ 납입 기간 × (개인 소득 + 전체 가입자 평균 소득)\n\n" +
                "## 임의 계속 가입\n60세 이후에도 납입을 연장해 수령액을 늘릴 수 있습니다."),
                Difficulty.BEGINNER, 12, 12, List.of(common3));

        SkillNode pen2 = node("퇴직연금", "DB·DC·IRP 유형별 특징과 선택 기준을 파악합니다.",
                branchContent("퇴직연금", "## 유형 비교\n| 유형 | 수익 책임 | 특징 |\n|------|-----------|------|\n| DB | 회사 | 퇴직 전 3개월 평균 급여 × 근속 |\n| DC | 본인 | 직접 운용, 중간 정산 가능 |\n| IRP | 본인 | 세액공제 최대 900만 원 |\n\n" +
                "## IRP 세액공제\n연 900만 원 납입 시 최대 148.5만 원 환급"),
                Difficulty.INTERMEDIATE, 15, 12, List.of(pen1));

        SkillNode pen3 = node("연금저축", "연금저축펀드로 세액공제 + 복리 수익을 극대화합니다.",
                branchContent("연금저축", "## 연금저축 펀드 vs 보험\n- **펀드**: 원금 손실 가능, 수익 높음\n- **보험**: 원금 보장, 수익 낮음\n\n" +
                "## 절세 전략\n1. 연금저축(600만) + IRP(300만) = 세액공제 900만 원\n2. 55세 이후 연금 수령 시 저율 과세(3.3~5.5%)\n3. 분리과세 선택 가능"),
                Difficulty.INTERMEDIATE, 15, 12, List.of(pen2));

        SkillNode pen4 = node("연금 포트폴리오", "생애 주기 투자(TDF)와 자산 배분 전략으로 노후를 설계합니다.",
                branchContent("연금 포트폴리오", "## TDF(Target Date Fund)\n은퇴 목표 시점에 가까워질수록 위험 자산 비중 자동 조정\n\n" +
                "## 자산 배분 원칙\n- 젊을수록 주식 비중 높게 (100 - 나이 = 주식 %)\n- 은퇴 후 채권·배당주 비중 높이기"),
                Difficulty.ADVANCED, 20, 12, List.of(pen3));

        // 분기 3: 부동산
        SkillNode re1 = node("부동산 기초", "전세·월세·매매의 차이와 부동산 시장의 작동 원리",
                branchContent("부동산 기초", "## 거주 형태 비교\n| 형태 | 장점 | 단점 |\n|------|------|------|\n| 자가 | 자산 축적 | 높은 초기 비용 |\n| 전세 | 목돈 보전 | 역전세 위험 |\n| 월세 | 낮은 초기비용 | 매달 지출 |\n\n" +
                "## 부동산 가격 결정 요인\n- 수요(인구, 소득)\n- 공급(신규 입주 물량)\n- 금리(대출 비용)\n- 정책(규제, 세금)"),
                Difficulty.BEGINNER, 12, 13, List.of(common3));

        SkillNode re2 = node("아파트 매매", "청약 전략과 실거주 매매 시 고려사항",
                branchContent("아파트 매매", "## 청약 가점제\n청약 가점 = 무주택 기간 + 부양가족 수 + 청약 통장 납입 기간\n\n" +
                "## 매매 시 체크리스트\n1. 등기부등본 — 근저당·가압류 확인\n2. 실거래가 조회(국토부 실거래가 공개 시스템)\n3. 향후 입주 물량 확인"),
                Difficulty.INTERMEDIATE, 15, 13, List.of(re1));

        SkillNode re3 = node("부동산 투자", "갭 투자·월세 수익률 계산과 레버리지 활용",
                branchContent("부동산 투자", "## 갭 투자\n(매매가 - 전세가) 만큼의 자금으로 매매\n- 장점: 소액으로 자산 취득\n- 위험: 전세가 하락 시 역전세\n\n" +
                "## 수익률 계산\n월세 수익률 = (연 월세 수입 / 투자금) × 100"),
                Difficulty.INTERMEDIATE, 18, 13, List.of(re2));

        SkillNode re4 = node("리츠·부동산 펀드", "리츠로 소액 부동산 투자와 배당 수익을 실현합니다.",
                branchContent("리츠·부동산 펀드", "## 리츠(REITs)란?\n부동산을 소유한 회사의 주식을 매수해 배당 수령\n- 소액 투자 가능\n- 유동성 높음(주식 시장 거래)\n\n" +
                "## 국내 주요 리츠\n- 맥쿼리인프라, 롯데리츠, SK리츠\n- 배당수익률 4~7% 수준"),
                Difficulty.ADVANCED, 18, 13, List.of(re3));

        // 분기 4: 세금
        SkillNode tax1 = node("세금 기초", "소득세·부가세·지방세의 구조를 이해합니다.",
                branchContent("세금 기초", "## 세금의 분류\n- **직접세**: 소득세, 법인세, 상속세 (납세자 = 담세자)\n- **간접세**: 부가세, 개별소비세 (납세자 ≠ 담세자)\n\n" +
                "## 소득세 세율(2024)\n| 과세표준 | 세율 |\n|----------|------|\n| ~1,400만 | 6% |\n| ~5,000만 | 15% |\n| ~8,800만 | 24% |\n| ~1.5억 | 35% |"),
                Difficulty.BEGINNER, 12, 14, List.of(common3));

        SkillNode tax2 = node("연말정산", "근로소득자의 소득공제·세액공제를 최대한 활용합니다.",
                branchContent("연말정산", "## 핵심 공제 항목\n- 인적공제: 부양가족 1인당 150만 원\n- 연금저축·IRP: 최대 148.5만 원 환급\n- 신용카드: (총급여 25% 초과 사용분) × 15%\n- 의료비: (총급여 3% 초과 지출) × 15%\n\n" +
                "## 13월의 월급 만들기\n체크카드(30%) > 현금영수증(30%) > 신용카드(15%)"),
                Difficulty.INTERMEDIATE, 15, 14, List.of(tax1));

        SkillNode tax3 = node("투자 세금", "주식·펀드·부동산 양도소득세를 계산합니다.",
                branchContent("투자 세금", "## 국내 주식 세금\n- 매매 차익: 비과세(2024 기준)\n- 배당소득: 15.4% 원천징수\n\n" +
                "## 해외 주식 세금\n- 양도차익: 250만 원 공제 후 22% 신고\n\n" +
                "## 부동산 양도세\n- 비과세: 1세대 1주택, 2년 이상 보유\n- 다주택: 중과세율 적용 가능"),
                Difficulty.INTERMEDIATE, 18, 14, List.of(tax2));

        SkillNode tax4 = node("절세 전략", "종합소득세·상속세·증여세 절감 전략을 수립합니다.",
                branchContent("절세 전략", "## 금융소득 종합과세\n이자·배당 합산 연 2,000만 원 초과 시 다른 소득과 합산 과세\n\n" +
                "## 절세 포인트\n1. ISA 계좌: 비과세 200만 원 + 분리과세\n2. 해외펀드: 손익 통산\n3. 증여 활용: 10년 단위 공제 한도(성인 자녀 5,000만)"),
                Difficulty.ADVANCED, 20, 14, List.of(tax3));

        // 분기 5: 신용
        SkillNode cre1 = node("신용점수 기초", "신용점수 결정 요인과 관리 방법을 이해합니다.",
                branchContent("신용점수 기초", "## 신용점수란?\n금융 거래 이력을 바탕으로 대출 상환 능력을 수치화한 지표입니다.\n\n" +
                "## 점수에 영향을 주는 요인\n1. 상환 이력 (가장 중요)\n2. 부채 수준\n3. 신용 기간\n4. 신규 신용 조회 횟수"),
                Difficulty.BEGINNER, 10, 15, List.of(common3));

        SkillNode cre2 = node("대출 활용", "주택담보·신용·마이너스 통장의 금리 비교와 선택 기준",
                branchContent("대출 활용", "## 대출 종류 비교\n| 종류 | 금리 | 한도 | 담보 |\n|------|------|------|------|\n| 주담대 | 낮음 | 높음 | 부동산 |\n| 신용대출 | 중 | 중 | 없음 |\n| 마통 | 중 | 중 | 없음 |\n\n" +
                "## DSR(총부채원리금상환비율)\n연 소득 대비 모든 대출 원리금이 일정 비율 이하여야 합니다."),
                Difficulty.INTERMEDIATE, 15, 15, List.of(cre1));

        SkillNode cre3 = node("신용 회복", "연체 및 신용 불량 탈출 전략",
                branchContent("신용 회복", "## 연체 발생 시 대응\n1. 즉시 연체 해소 (1회 연체도 점수 하락)\n2. 금융기관과 상환 유예 협의\n3. 신용회복위원회 채무조정 신청\n\n" +
                "## 회복 기간\n- 단기 연체: 1~2년 후 정상화\n- 장기 연체: 5~10년 경과 후 삭제"),
                Difficulty.INTERMEDIATE, 12, 15, List.of(cre2));

        SkillNode cre4 = node("신용 고급 활용", "카드 혜택 최적화와 대안 신용 평가 활용",
                branchContent("신용 고급 활용", "## 카드 혜택 최대화\n- 주력 카드 1~2개 집중 사용\n- 전월 실적 기준 맞추기\n- 항공 마일리지 vs 할인 카드 — 라이프스타일에 맞게\n\n" +
                "## 대안 신용 평가\n통신비·공과금 납부 이력도 일부 신용평가에 반영됩니다."),
                Difficulty.ADVANCED, 15, 15, List.of(cre3));

        // 분기 6: 암호화폐
        SkillNode cry1 = node("블록체인 기초", "블록체인의 구조와 암호화폐의 탄생 배경을 이해합니다.",
                branchContent("블록체인 기초", "## 블록체인이란?\n데이터를 **블록**에 담아 **체인**처럼 연결한 분산 장부입니다.\n\n" +
                "## 특징\n- **탈중앙화**: 중앙 서버 없이 참여자 모두가 장부 보유\n- **불변성**: 한 번 기록된 데이터는 수정 불가\n- **투명성**: 모든 거래 내역 공개\n\n" +
                "## 비트코인의 탄생\n2009년 사토시 나카모토가 중앙 기관 없이 개인 간 거래 가능한 전자화폐를 구현"),
                Difficulty.BEGINNER, 12, 16, List.of(common3));

        SkillNode cry2 = node("암호화폐 투자", "비트코인·이더리움·알트코인의 차이와 투자 방법",
                branchContent("암호화폐 투자", "## 주요 코인\n- **비트코인(BTC)**: 디지털 금, 발행 한도 2,100만 개\n- **이더리움(ETH)**: 스마트 컨트랙트 플랫폼\n- **알트코인**: BTC를 제외한 모든 코인\n\n" +
                "## 투자 전략\n- **달러 코스트 애버리징(DCA)**: 정기 분할 매수\n- 전체 포트폴리오의 5~10% 이내 권장"),
                Difficulty.INTERMEDIATE, 15, 16, List.of(cry1));

        SkillNode cry3 = node("디파이·NFT", "탈중앙화 금융과 NFT의 구조와 활용 사례",
                branchContent("디파이·NFT", "## DeFi(탈중앙화 금융)\n중간 금융기관 없이 스마트 컨트랙트로 대출·이자 지급\n- **예치(Staking)**: 코인 보관 시 이자 수익\n- **유동성 공급(LP)**: 거래소에 유동성 제공 후 수수료 수취\n\n" +
                "## NFT\n디지털 자산의 소유권을 블록체인에 기록한 토큰"),
                Difficulty.INTERMEDIATE, 15, 16, List.of(cry2));

        SkillNode cry4 = node("코인 세금·규제", "국내외 암호화폐 세금 체계와 규제 흐름",
                branchContent("코인 세금·규제", "## 국내 세금(2025 시행 예정)\n- 연 250만 원 기본 공제\n- 초과 수익에 22% 세율\n\n" +
                "## 규제 동향\n- 가상자산 이용자 보호법 시행\n- 거래소 VASP 등록 의무화\n\n" +
                "## 리스크 관리\n- 거래소 해킹·파산 대비: 콜드 월렛 보관\n- 스캠 코인 구분: 백서·팀·유스케이스 확인"),
                Difficulty.ADVANCED, 18, 16, List.of(cry3));

        List<SkillNode> branches = List.of(
                ins1, ins2, ins3, ins4,
                stk1, stk2, stk3, stk4,
                pen1, pen2, pen3, pen4,
                re1, re2, re3, re4,
                tax1, tax2, tax3, tax4,
                cre1, cre2, cre3, cre4,
                cry1, cry2, cry3, cry4
        );
        repo.saveAll(branches);
        repo.flush();

        // ───────── 마스터 3노드 (7개 분기 모두 완료 후 해금) ─────────
        SkillNode master1 = node("자산 배분 마스터", "7개 분야를 통합한 포트폴리오를 설계합니다.",
                branchContent("자산 배분 마스터", "## 포트폴리오 이론\n- **현대 포트폴리오 이론(MPT)**: 분산 투자로 리스크 최소화\n- **효율적 프론티어**: 동일 리스크 대비 최대 수익 포트폴리오\n\n" +
                "## 자산 배분 예시(30대 공격형)\n- 국내 주식 30%\n- 해외 ETF 30%\n- 채권 15%\n- 부동산(리츠) 10%\n- 연금 10%\n- 암호화폐 5%"),
                Difficulty.ADVANCED, 25, 100,
                List.of(ins4, stk4, pen4, re4, tax4, cre4, cry4));

        SkillNode master2 = node("재무 계획 수립", "생애 목표 기반 장기 재무 계획을 완성합니다.",
                branchContent("재무 계획 수립", "## 재무 목표 설정\n1. 단기(1~3년): 비상자금 6개월치 마련\n2. 중기(3~10년): 주택 구매 자금\n3. 장기(10년+): 노후 자금 10억+\n\n" +
                "## 72법칙\n72 ÷ 연이율 = 원금이 2배 되는 년수\n예: 연 6% 수익 → 12년 후 2배"),
                Difficulty.ADVANCED, 25, 101,
                List.of(master1));

        SkillNode master3 = node("FinTree 마스터", "금융 전반의 지식을 통합해 재무 독립을 달성합니다.",
                branchContent("FinTree 마스터", "## 재무 독립(FIRE)이란?\n**Financial Independence, Retire Early**\n— 투자 수익으로 생활비를 충당해 근로 소득 없이 생활 가능한 상태\n\n" +
                "## 4% 룰\n은퇴 자산의 연 4%를 인출하면 30년 이상 고갈되지 않는다는 경험 법칙\n\n" +
                "## 다음 단계\n지식을 가족과 공유하고, 금융 교육을 지역사회에 전파하세요. 🎉"),
                Difficulty.ADVANCED, 30, 102,
                List.of(master2));

        repo.saveAll(List.of(master1, master2, master3));
        repo.flush();

        // ───────── 퀴즈 추가 ─────────
        addQuizzes(common1, common2, common3,
                ins1, stk1, pen1, re1, tax1, cre1, cry1);
    }

    // ──────────── 헬퍼 ────────────

    private SkillNode node(String title, String description, String content,
                           Difficulty difficulty, int minutes, int order,
                           List<SkillNode> prerequisites) {
        SkillNode n = SkillNode.builder()
                .title(title)
                .description(description)
                .content(content)
                .difficulty(difficulty)
                .estimatedMinutes(minutes)
                .orderIndex(order)
                .build();
        prerequisites.forEach(n::addPrerequisite);
        return n;
    }

    private String commonContent(String title, String body) {
        return "# " + title + "\n\n" + body;
    }

    private String branchContent(String title, String body) {
        return "# " + title + "\n\n" + body;
    }

    /** 퀴즈 추가 (각 노드에 2문제씩) */
    private void addQuizzes(SkillNode c1, SkillNode c2, SkillNode c3,
                            SkillNode i1, SkillNode s1, SkillNode p1,
                            SkillNode r1, SkillNode t1, SkillNode cr1,
                            SkillNode cy1) {

        // 금융 기초 퀴즈
        addQuiz(c1, "이자율이란 무엇을 의미하나요?",
                new String[]{"돈을 빌리는 비용이자 저축의 보상", "물가 상승률", "세금 비율", "환율 변동폭"},
                0);
        addQuiz(c1, "화폐의 3가지 기능에 해당하지 않는 것은?",
                new String[]{"투자 수단", "교환의 매개", "가치 척도", "가치 저장"},
                0);

        // 경제 기초 퀴즈
        addQuiz(c2, "금리를 인상하면 일반적으로 어떤 효과가 나타나나요?",
                new String[]{"소비·투자 감소, 물가 안정", "소비·투자 증가, 경기 부양", "물가 상승, 고용 감소", "환율 하락, 수출 증가"},
                0);
        addQuiz(c2, "경기 사이클의 순서로 올바른 것은?",
                new String[]{"확장 → 정점 → 수축 → 저점", "저점 → 수축 → 확장 → 정점", "정점 → 확장 → 저점 → 수축", "수축 → 정점 → 확장 → 저점"},
                0);

        // 금융 상품 기초 퀴즈
        addQuiz(c3, "수익이 높은 금융 상품의 특징은?",
                new String[]{"위험도도 높다", "유동성이 낮다", "원금이 보장된다", "세금 혜택이 있다"},
                0);
        addQuiz(c3, "주식과 예금을 비교할 때 주식의 특징은?",
                new String[]{"높은 수익 가능성과 높은 위험", "낮은 수익과 낮은 위험", "원금 보장과 낮은 유동성", "이자율이 고정된 안전 자산"},
                0);

        // 보험 기초 퀴즈
        addQuiz(i1, "보험의 기본 원리는 무엇인가요?",
                new String[]{"위험 분산 — 다수가 소액 납입해 소수의 큰 손실을 보전", "은행에 저축해 이자를 받는 것", "주식을 매수해 시세차익을 얻는 것", "부동산을 임대해 수익을 얻는 것"},
                0);
        addQuiz(i1, "일상에서 가장 먼저 가입을 권장하는 필수 보험은?",
                new String[]{"실손보험", "변액보험", "저축성 보험", "법인 보험"},
                0);

        // 주식 기초 퀴즈
        addQuiz(s1, "PER(주가수익비율)이 낮다는 것은 무엇을 의미하나요?",
                new String[]{"상대적으로 저평가되어 있을 가능성", "회사 부채가 많음", "배당이 높음", "주가가 빠르게 상승하는 중"},
                0);
        addQuiz(s1, "주가에 영향을 미치는 요인이 아닌 것은?",
                new String[]{"대표이사 키(신장)", "기업 실적(EPS)", "금리 환경", "시장 심리"},
                0);

        // 국민연금 퀴즈
        addQuiz(p1, "국민연금의 수령액은 주로 무엇에 의해 결정되나요?",
                new String[]{"납입 기간과 소득 수준", "가입자 나이와 성별", "거주 지역과 직업", "가족 수와 재산"},
                0);
        addQuiz(p1, "60세 이후에도 국민연금을 계속 납입해 수령액을 늘리는 것을 무엇이라 하나요?",
                new String[]{"임의 계속 가입", "연금 분할 청구", "추후 납부", "반환 일시금 청구"},
                0);

        // 부동산 기초 퀴즈
        addQuiz(r1, "전세 거주의 장점은 무엇인가요?",
                new String[]{"목돈을 보전하면서 이자비용 없이 거주 가능", "소액으로 시작 가능", "매달 지출이 없음", "자산으로 인정받아 대출이 유리"},
                0);
        addQuiz(r1, "부동산 가격을 결정하는 요인이 아닌 것은?",
                new String[]{"인근 맛집 수", "금리 수준", "신규 입주 물량", "지역 인구"},
                0);

        // 세금 기초 퀴즈
        addQuiz(t1, "직접세와 간접세의 가장 큰 차이점은?",
                new String[]{"납세자와 담세자가 동일한지 여부", "세금 금액의 크기", "납부 주기", "세금을 거두는 기관"},
                0);
        addQuiz(t1, "소득세에서 과세표준이 높아질수록 세율이 어떻게 되나요?",
                new String[]{"높아진다 (누진세)", "낮아진다 (역진세)", "동일하다 (비례세)", "두 배가 된다"},
                0);

        // 신용점수 기초 퀴즈
        addQuiz(cr1, "신용점수에 가장 큰 영향을 주는 요소는?",
                new String[]{"상환 이력", "연소득 수준", "거주 지역", "나이"},
                0);
        addQuiz(cr1, "신용점수를 올리기 위한 올바른 방법은?",
                new String[]{"카드 대금을 연체 없이 꾸준히 납부", "대출을 최대한 많이 받기", "신용카드를 여러 장 동시에 발급", "은행 계좌를 자주 변경"},
                0);

        // 블록체인 기초 퀴즈
        addQuiz(cy1, "블록체인의 핵심 특징이 아닌 것은?",
                new String[]{"중앙 기관의 강력한 통제", "탈중앙화", "불변성", "투명성"},
                0);
        addQuiz(cy1, "비트코인의 최대 발행 한도는?",
                new String[]{"2,100만 개", "1억 개", "21억 개", "제한 없음"},
                0);

        repo.flush();
    }

    private void addQuiz(SkillNode node, String question, String[] options, int correctIdx) {
        Quiz quiz = Quiz.builder().skillNode(node).question(question).build();
        for (int i = 0; i < options.length; i++) {
            quiz.addOption(QuizOption.builder().text(options[i]).correct(i == correctIdx).build());
        }
        node.getQuizzes().add(quiz);
    }
}
