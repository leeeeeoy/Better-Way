# 상품 수익 분석기 (MVP)

## 1. 프로젝트 목적

이 프로젝트는 한국 이커머스 판매자를 위한 웹 기반 수익 분석 도구이다.

MVP의 목표는 단 하나다.

> 상품 1개의 정보를 입력하면 플랫폼 수수료와 부가세까지 반영한 실제 순이익을 즉시 보여준다.

이 프로젝트는:
- 회계 프로그램이 아니다
- 종합 세무 솔루션이 아니다
- 관리자용 대시보드가 아니다

이 프로젝트는 판매자의 “상품 판매 여부 판단”을 돕는 의사결정 도구다.

핵심 가치:
- 정확성
- 투명성
- 속도
- 단순함

---

## 2. MVP 범위

### 포함 기능

- 단일 상품 수익 계산
- 프론트엔드 실시간 계산
- 일반과세자만 지원
- 모든 금액은 부가세 포함 금액 기준 입력
- 건당 순이익 계산
- 마진율 계산
- 월 예상 순이익 계산
- 계산 근거(Breakdown) 표시

### 제외 기능

- 로그인
- 여러 상품 저장/관리
- 엑셀 업로드/다운로드
- 종합소득세 계산
- 간이과세 지원
- 부가세 환급 계산
- 복잡한 세무 분기 처리
- SEO 최적화

MVP는 반드시 최소 기능으로 유지한다.

---

## 3. 기술 스택

### Frontend
- Flutter Web
- go_router
- flutter_riverpod (v3 이상)
- freezed

### Backend
- Cloudflare Workers
- Cloudflare D1 (SQLite)

설계 철학:
- 프론트에서 실시간 계산
- Worker에서 동일 로직으로 재계산하여 검증
- 서버는 향후 확장 대비 구조로 유지

---

## 4. 프로젝트 구조

lib/
 ├─ router/
 │   └─ app_router.dart
 ├─ features/
 │   └─ home/
 │       ├─ home_screen.dart
 │       ├─ sections/
 │       │    ├─ selling_section.dart
 │       │    ├─ cost_section.dart
 │       │    ├─ fee_section.dart
 │       │    └─ result_section.dart
 │       ├─ state/analysis_state.dart
 │       ├─ controller/analysis_controller.dart
 │       └─ calculator/profit_calculator.dart

원칙:
- 계산 로직은 UI와 완전히 분리
- ProfitCalculator는 순수 비즈니스 로직만 담당
- Riverpod Provider는 상태 및 파생 계산 담당
- UI는 선언형 구조 유지

---

## 5. 계산 로직 정의 (일반과세자 기준)

모든 금액은 부가세 포함 금액이다.

### 입력 변수

P   : 판매가  
D   : 할인율 (0~1)  
C   : 매입가  
S   : 배송비  
PK  : 포장비  
A   : 건당 광고비  
F_p : 플랫폼 수수료율 (0~1)  
F_pg: 결제 수수료율 (0~1)  
Q   : 월 판매 수량  

---

### 1단계: 실제 판매가

P_real = P × (1 - D)

---

### 2단계: 수수료 계산

F_total = F_p + F_pg  
Fee = P_real × F_total  

---

### 3단계: 부가세 계산

Output_VAT = P_real × (10 / 110)  
Input_VAT  = C × (10 / 110)  

VAT = max(Output_VAT - Input_VAT, 0)

※ MVP에서는 매입가에 대한 매입세액만 반영한다.

---

### 4단계: 세전 영업이익

Gross_Profit =
P_real
- Fee
- C
- S
- PK
- A

---

### 5단계: 최종 순이익

Net_Profit = Gross_Profit - VAT

---

### 6단계: 마진율

Margin = Net_Profit / P_real

---

### 7단계: 월 예상 순이익

Monthly_Profit = Net_Profit × Q

---

## 6. 상태 관리 전략 (Riverpod 3 기준)

- AnalysisState는 freezed로 정의
- 모든 입력값은 상태로 관리
- 계산은 별도의 파생 Provider에서 수행
- UI에서 수동 calculate() 호출하지 않음
- 입력이 변경되면 자동 재계산

예시 구조:

final profitResultProvider = Provider((ref) {
  final state = ref.watch(analysisProvider);
  return ProfitCalculator.calculate(...);
});

이 구조를 통해 완전한 반응형 계산을 유지한다.

---

## 7. UX 원칙

- 계산 버튼 없이 실시간 반영
- 핵심 결과(순이익)를 가장 강조
- 계산 근거를 반드시 표시하여 신뢰 확보
- 기본값 프리셋 제공
- 퍼센트는 사용자 입력 10 → 내부 0.1 저장
- UI는 섹션 단위로 분리
- 과도한 기능 추가 금지

---

## 8. 백엔드 설계 철학

프론트:
- 빠른 계산
- 즉각적인 피드백

Worker:
- 동일 계산 로직으로 재검증
- 향후 공유 링크 및 저장 기능 확장 가능 구조 유지

서버는 MVP에서 최소 기능만 구현한다.

---

## 9. 개발 제약 조건

- 과도한 추상화 금지
- 과도한 기능 확장 금지
- 세무 범위 확대 금지
- 계산 로직은 반드시 테스트 가능하게 유지
- UI는 모듈화 구조 유지

---

## 10. 제품 방향성

이 제품은 판매자의 의사결정을 돕는 도구다.

다음 조건을 만족해야 한다:

- 숫자가 명확하다
- 계산 근거가 보인다
- 결과가 신뢰된다
- 빠르게 판단할 수 있다

이 제품은:
- 장난감 계산기처럼 보이면 안 된다
- 회계 프로그램처럼 복잡하면 안 된다
- 기능이 과하게 많아지면 안 된다

단순함은 기술적 한계가 아니라 의도적인 제품 전략이다.
