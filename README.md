# SSAIREN — Frontend (Flutter)

<br>

## 디렉토리 구조

```
Frontend/
├── lib/
│   ├── main.dart                        # 앱 진입점 + 전체 라우트 등록
│   ├── core/
│   │   ├── constants/app_sizes.dart     # 반응형 스케일 (w / h / sp)
│   │       
│   └── screens/
│       ├── splash/
│       ├── onboarding/
│       ├── home/
│       ├── calling/
│       └── result/
│
├── assets/
│   ├── main_logo.png                    # SSAIREN 메인 로고
│   ├── main_title.png                   # SSAIREN 워드마크
│   ├── widget_logo_blue.png             # 활성 소형 로고
│   ├── widget_logo_gray.png             # 비활성 소형 로고
│   └── logo_check.png                   # 완료 로고
│
├── android/                             # Android 네이티브 설정
├── pubspec.yaml                         
└── README.md
```

<br>

## 화면 구성 및 라우트

| # | 화면 | 라우트 |
|---|------|--------|
| 1 | 스플래시 | `/` |
| 2 | 온보딩 — 마이크 권한 | `/onboarding/1` |
| 3 | 온보딩 — 연락처 권한 | `/onboarding/2` |
| 4 | 온보딩 — 가족 등록 | `/onboarding/3` |
| 5 | 온보딩 — 위치 권한 | `/onboarding/4` |
| 6 | 온보딩 완료 | `/onboarding/done` |
| 7 | 홈 — 싸이렌 탭 | `/home` |
| 8 | 홈 — 통화기록 탭 | `/history` |
| 9 | 홈 — 연락처 탭 | `/contacts` |
| 10 | 홈 — 다이얼 탭 | `/dial` |
| 11 | 통화 중 모니터링 | `/calling` |
| 12 | 위험 감지 알림 | overlay |
| 13 | 대응 확인 창 — 기관사칭 | overlay |
| 14 | 경찰 공유 화면 | `/result/share` |
| 15 | 신고 접수 완료 | `/result/done` |
| 16 | 대응 확인 창 — 납치협박 | overlay |
| 17 | 납치협박 실시간 대응 | `/calling/harmful` |
| 18 | 납치협박 대응 완료 | `/result/harmful-done` |

<br>

## 앱 흐름

```
[최초 실행]
스플래시 → 마이크 권한 → 연락처 권한 → 가족 등록 → 위치 권한 → 온보딩 완료 → 홈

[시나리오 1 — 기관사칭]
다이얼 탭 → /calling (5초 루프 POST /analyze)
  └─ risk ≥ 0.8 → 대응 확인 창 — 기관사칭 (overlay)
        ├─ [네] → POST /trigger → /result/share → /result/done → 홈
        └─ [아니요] → 통화 계속

[시나리오 2 — 납치협박]
다이얼 탭 → /calling
  └─ risk ≥ 0.8 & 납치/협박 → 대응 확인 창 — 납치협박 (overlay)
        ├─ [확인] → /calling/harmful (KakaoMap + GPS 실시간)
        │           └─ 전화 끊기 → /result/harmful-done → 홈
        └─ [취소] → 통화 계속
```

<br>

## 서버 연동

```
POST /analyze      5초 오디오 청크 분석 → { risk: float, transcript: string, type: string }
POST /trigger      위험 트리거 확정 → 보호자 FCM 푸시 발송
WS   /ws/trigger   실시간 위험도 스트림 수신
```

<br>

## 기술 스택

| 항목 | 내용 |
|------|------|
| **Framework** | Flutter 3.44.1 |
| **Language** | Dart 3.12.1 |
| **Target** | Android (Galaxy S26 Ultra 기준, 412 × 917 dp) |
| **HTTP** | Dio 5.x |
| **WebSocket** | web_socket_channel 3.x |
| **오디오 녹음** | record 6.0.0 (pubspec_overrides.yaml 고정) |
| **알림** | Firebase Cloud Messaging (FCM) |
| **위치** | geolocator 13.x |
| **권한** | permission_handler 11.x |
| **로컬 저장** | shared_preferences 2.x |

