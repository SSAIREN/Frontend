/// 통화 화면 → 납치협박 대시보드로 전달하는 진행 중 통화 정보.
class HarmfulDashboardArgs {
  const HarmfulDashboardArgs({
    required this.phoneNumber,
    required this.callElapsed,
  });

  /// 상대 전화번호 (숫자만, 예: 01087654321).
  final String phoneNumber;

  /// 대시보드 진입 시점까지의 통화 경과 시간.
  final Duration callElapsed;
}
