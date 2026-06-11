# SSAIREN Flutter 파일 구조 안내

이 문서는 팀원이 각자 맡은 화면을 구현할 때 어떤 폴더와 파일을 수정하면 되는지 정리한 공유용 안내입니다.

## 전체 구조

```txt
lib/
  main.dart
  app.dart

  core/
    router/
    theme/
    widgets/

  features/
    splash/
    onboarding/
    home/
    dial/
    recents/
    contacts/
    calling/
    result/
    harmful/

  models/
  services/
```

## 진입점

### `lib/main.dart`

Flutter 앱의 시작점입니다.

```dart
void main() {
  runApp(const SsairenApp());
}
```

보통 팀원이 직접 수정할 일은 거의 없습니다.

### `lib/app.dart`

앱 전체 설정을 담당합니다.

- 앱 이름
- 테마
- 초기 라우트
- 라우터 연결

현재 앱은 `RoutePaths.splash`에서 시작합니다.

## `core/`

앱 전체에서 공통으로 사용하는 코드가 들어갑니다.

```txt
core/
  router/
    route_paths.dart
    app_router.dart

  theme/
    app_colors.dart
    app_theme.dart
    app_spacing.dart

  widgets/
    app_bottom_nav.dart
    primary_button.dart
    placeholder_screen.dart
    risk_badge.dart
    risk_gauge.dart
```

### `core/router`

화면 이동 경로를 관리합니다.

- `route_paths.dart`: 라우트 문자열 상수
- `app_router.dart`: 라우트와 실제 화면 위젯 연결

새 화면을 추가하면 이 두 파일에 경로를 등록합니다.

### `core/theme`

색상, 여백, 테마를 관리합니다.

- `app_colors.dart`: 공통 색상 토큰
- `app_spacing.dart`: 공통 간격
- `app_theme.dart`: Material 테마

화면별로 임의 색상을 만들기보다 여기 색상을 먼저 확인해서 사용합니다.

### `core/widgets`

여러 화면에서 같이 쓰는 공통 위젯입니다.

- `PrimaryButton`: 파란색 주요 버튼
- `AppBottomNav`: 키패드/최근기록/연락처/싸이렌 하단 탭
- `RiskBadge`, `RiskGauge`: 보이스피싱 위험도 표시

## `features/`

실제 화면 단위 코드가 들어갑니다. 각자 맡은 화면은 여기서 작업하면 됩니다.

```txt
features/
  splash/
    presentation/

  onboarding/
    presentation/
    widgets/

  home/
    presentation/
    widgets/

  dial/
    presentation/
    widgets/

  recents/
    presentation/

  contacts/
    presentation/

  calling/
    presentation/
    widgets/

  result/
    presentation/

  harmful/
    presentation/
    widgets/
```

## 화면별 담당 위치

| 화면 | 작업 위치 |
|---|---|
| 스플래시 | `features/splash/presentation/splash_screen.dart` |
| 온보딩 마이크 | `features/onboarding/presentation/onboarding_mic_screen.dart` |
| 온보딩 연락처 | `features/onboarding/presentation/onboarding_contacts_screen.dart` |
| 온보딩 가족 등록 | `features/onboarding/presentation/onboarding_family_screen.dart` |
| 온보딩 위치 | `features/onboarding/presentation/onboarding_location_screen.dart` |
| 온보딩 완료 | `features/onboarding/presentation/onboarding_done_screen.dart` |
| 홈/싸이렌 | `features/home/presentation/home_screen.dart` |
| 키패드 | `features/dial/presentation/dial_screen.dart` |
| 최근기록 | `features/recents/presentation/recents_screen.dart` |
| 연락처 | `features/contacts/presentation/contacts_screen.dart` |
| 통화 중 모니터링 | `features/calling/presentation/calling_screen.dart` |
| 경고 바텀시트 | `features/calling/widgets/suspicious_bottom_sheet.dart` |
| 위험 바텀시트 | `features/calling/widgets/harmful_bottom_sheet.dart` |
| 경찰 공유 | `features/result/presentation/police_share_screen.dart` |
| 경찰 접수 완료 | `features/result/presentation/receipt_done_screen.dart` |
| 납치협박 대응 | `features/harmful/presentation/harmful_dashboard_screen.dart` |
| 납치협박 대응 완료 | `features/harmful/presentation/harmful_done_screen.dart` |

## `models/`

앱에서 사용하는 데이터 구조가 들어갑니다.

```txt
models/
  guardian.dart
  call_log.dart
  contact.dart
  risk_result.dart
```

## `services/`

외부 기능과 API 연결 코드를 넣는 곳입니다.

```txt
services/
  permission_service.dart
  audio_record_service.dart
  analyze_api_service.dart
  location_service.dart
  fcm_service.dart
  websocket_service.dart
```

역할은 다음과 같습니다.

| 파일 | 역할 |
|---|---|
| `permission_service.dart` | 마이크, 연락처, 위치 권한 |
| `audio_record_service.dart` | 통화/마이크 음성 수음 |
| `analyze_api_service.dart` | `/analyze` API 연결 |
| `location_service.dart` | GPS 위치 조회 |
| `fcm_service.dart` | 보호자 알림 FCM |
| `websocket_service.dart` | `/ws/trigger` 등 실시간 연결 |

## 작업 규칙

1. 자기 화면은 `features/{기능명}/presentation`에서 작업합니다.
2. 화면 안에서 반복되는 작은 UI는 같은 feature의 `widgets/`로 분리합니다.
3. 여러 화면에서 같이 쓰면 `core/widgets/`로 이동합니다.
4. 색상은 가능한 `AppColors`를 사용합니다.
5. 화면 이동 경로는 `RoutePaths`에 추가하고 `AppRouter`에 연결합니다.
6. API, 권한, 위치, FCM, WebSocket 코드는 화면 파일에 직접 넣지 말고 `services/`에 둡니다.

## 현재 상태

현재 파일들은 팀원이 작업을 나눠 들어가기 위한 skeleton 상태입니다.

- 라우트 연결은 되어 있음
- 각 화면 파일은 placeholder 상태
- 실제 와이어프레임 UI 구현은 각 담당자가 진행
- API/권한/녹음/FCM/WebSocket은 stub만 생성된 상태
