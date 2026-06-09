# SSAIREN (싸이렌)

> 실시간 보이스피싱 탐지 AI 앱

<br>

## 프로젝트 소개

SSAIREN은 노인을 대상으로 한 보이스피싱을 실시간으로 탐지하고 자동으로 대응하는 Android 앱입니다.  
통화 중 마이크 음성을 5초 단위로 AI 서버에 전송해 위험도를 분석하며, 위험도가 임계값(0.8)을 초과하면 보호자에게 즉시 FCM 알림을 발송합니다.

<br>

## 기술 스택

- **Framework** : Flutter 3.x
- **언어** : Dart
- **통신** : REST API (Dio), WebSocket
- **알림** : Firebase Cloud Messaging (FCM)

<br>

## 화면 구성

```
앱 실행
├── 홈 (통화기록 목록)
├── 통화 중 모니터링  ← 위험도 % 실시간 표시
│   └── 트리거 확인  ← [네] / [아니요]
│       └── 툴 실행 결과  ← 체크리스트 순서대로 완료
├── 보호자 알림 화면  ← FCM 수신 시 진입 (보호자 폰)
└── 설정  ← 보호자 지정
```

<br>

## 앱 흐름

```
내 폰: 통화 중 마이크 → 5초 청크 → POST /analyze
                                        ↓
                              risk >= 0.8 감지
                                        ↓
                         [네] 버튼 → POST /trigger
                                        ↓
                    서버 → 보호자 FCM 토큰으로 푸시 발송
                                        ↓
보호자 폰: FCM 수신 → 알림 클릭 → 위치 확인 + 안심 메시지 전송
```

<br>

## 로컬 실행

```bash
flutter pub get
flutter run
```

### 환경 변수

프로젝트 루트에 `.env` 파일 생성:

```
API_BASE_URL=http://서버IP:8080
WS_URL=ws://서버IP:8080/ws/trigger
```

### Firebase 설정

1. Firebase 콘솔에서 Android 앱 등록
2. `google-services.json` 을 `android/app/` 에 추가 (⚠️ Git 커밋 금지)

<br>

## 디렉토리 구조

```
Frontend/
├── lib/
│   ├── screens/              # 화면 UI
│   │   ├── monitoring/       # 통화 중 위험도 모니터링, 트리거 확인, 결과
│   │   ├── guardian/         # 보호자 알림 수신 화면
│   │   └── settings/         # 보호자 지정 설정
│   ├── services/             # 비즈니스 로직 (API, WebSocket, FCM, 오디오)
│   ├── models/               # 서버 응답 데이터 모델
│   └── main.dart             # 앱 진입점
│
├── android/                  # Android 네이티브 설정 (권한, 아이콘 등)
├── test/                     # 테스트 코드
├── pubspec.yaml              # 패키지 의존성 관리
└── README.md
```

