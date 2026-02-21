# Better Way - 상품 수익 분석기

Flutter Web와 Cloudflare Workers를 활용한 상품 수익률 분석 도구입니다. 판매가, 매입가 등 다양한 비용을 입력하여 순이익, 마진율, 월 예상 이익을 계산해줍니다.

## 🚀 기능

- **수익 계산**: 판매가, 매입가를 기반으로 순이익 계산
- **마진율 분석**: 실제 수익률 시각화
- **월 예상 이익**: 판매 수량에 따른 월간 예상 수익 계산
- **부가세 자동 계산**: 부가세(10%)를 고려한 정확한 수익 계산
- **플랫폼 수수료**: 결제 수수료, 플랫폼 수수료 등 반영

## 🛠️ 기술 스택

### Frontend
- **Flutter**: Web 애플리케이션 개발
- **Riverpod**: 상태 관리
- **Go Router**: 라우팅 관리
- **Google Fonts**: 폰트 관리

### Backend
- **Cloudflare Workers**: 서버리스 API
- **Cloudflare D1**: SQLite 데이터베이스
- **TypeScript**: 백엔드 개발 언어

## 📁 프로젝트 구조

```
better_way/
├── lib/
│   ├── feature/
│   │   └── home/
│   │       ├── controller/     # Riverpod 컨트롤러
│   │       ├── state/          # 상태 관리
│   │       ├── util/           # 수익 계산 유틸리티
│   │       └── home_screen.dart # 메인 화면
│   ├── router/                # 라우팅 설정
│   └── app.dart               # 앱 진입점
├── server/                    # Cloudflare Workers 백엔드
│   ├── src/
│   ├── wrangler.jsonc        # Cloudflare 설정
│   └── package.json
└── web/                      # Flutter Web 빌드 출력
```

## 🚦 시작하기

### 사전 요구사항
- Flutter SDK (>= 3.11.0)
- Node.js (>= 18.0.0)
- Cloudflare 계정

### 설치 및 실행

1. **Flutter 의존성 설치**
```bash
flutter pub get
```

2. **로컬 개발 서버 실행**
```bash
flutter run -d chrome
```

3. **백엔드 개발 서버 실행**
```bash
cd server
npm install
npm run dev
```

### 빌드 및 배포

1. **Flutter Web 빌드**
```bash
flutter build web
```

2. **Cloudflare Workers 배포**
```bash
cd server
npm run deploy
```

## 💡 사용법

1. 판매가를 입력합니다
2. 매입가를 입력합니다
3. '순이익 계산하기' 버튼을 클릭합니다
4. 계산된 순이익, 마진율, 월 예상 이익을 확인합니다

## 🧮 수익 계산 로직

```dart
// 실제 판매가 (할인 적용)
final pReal = sellingPrice * (1 - discountRate);

// 총 수수료 (플랫폼 + 결제)
final fee = pReal * (platformFeeRate + paymentFeeRate);

// 부가세 계산
final vat = (outputVat - inputVat).clamp(0, double.infinity);

// 순이익 계산
final netProfit = pReal - fee - costPrice - shippingCost - packagingCost - adCost - vat;
```

## 🔧 개발 환경 설정

### VS Code 확장 프로그램 추천
- Flutter
- Dart
- Cloudflare Workers
- TypeScript

### 코드 생성
```bash
# Freezed/JSON 직렬화 코드 생성
flutter pub run build_runner build
```

## 📊 데이터베이스

Cloudflare D1 (SQLite)를 사용하여 데이터를 저장합니다.

```sql
-- 테이블 스키마 예시
CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  selling_price REAL NOT NULL,
  cost_price REAL NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## 🤝 기여하기

1. 이 저장소를 포크합니다
2. 기능 브랜치를 생성합니다 (`git checkout -b feature/AmazingFeature`)
3. 변경사항을 커밋합니다 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 푸시합니다 (`git push origin feature/AmazingFeature`)
5. Pull Request를 생성합니다

## 📝 라이선스

이 프로젝트는 MIT 라이선스 하에 운영됩니다.

## 📞 문의

프로젝트에 대한 문의사항이 있으시면 이슈를 생성해주세요.

---

**Better Way** - 더 나은 방법으로 수익을 분석하세요 🚀
