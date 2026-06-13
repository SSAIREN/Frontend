/// 통화 화면 → 납치협박 대시보드로 전달하는 진행 중 통화 정보.
class HarmfulDashboardArgs {
  const HarmfulDashboardArgs({
    required this.phoneNumber,
    required this.callElapsed,
    this.latitude = _defaultLat,
    this.longitude = _defaultLng,
  });

  // 강남역 (서버 GPS 미연동 시 데모 기본 좌표)
  static const _defaultLat = 37.4979;
  static const _defaultLng = 127.0276;

  /// 상대 전화번호 (숫자만, 예: 01087654321).
  final String phoneNumber;

  /// 대시보드 진입 시점까지의 통화 경과 시간.
  final Duration callElapsed;

  /// 보호 대상자(보호자) 위치 — 추후 GPS API 연동 시 실제 값 주입.
  final double latitude;
  final double longitude;
}
