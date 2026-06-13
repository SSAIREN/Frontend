/// 보호자 응답 화면에 전달되는 FCM 알림 정보.
///
/// 알림 payload의 제목/본문을 화면 상단에 표시하는 용도다.
class GuardianResponseArgs {
  const GuardianResponseArgs({
    this.title,
    this.body,
  });

  final String? title;
  final String? body;
}
