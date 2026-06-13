/// 서버 `phishingType` enum 문자열을 사용자용 한글 라벨로 변환한다.
///
/// Swagger 정의 4종 + 코드에서 함께 쓰이는 `FAMILY_THREAT`/`NONE`을 커버한다.
/// 미정의 값이 들어오면 안전하게 기본 라벨('보이스피싱')을 돌려준다.
abstract final class PhishingType {
  static const _labels = {
    'AGENCY_IMPERSONATION': '기관 사칭',
    'ACCOUNT_TRANSFER_INDUCEMENT': '계좌이체 유도',
    'KIDNAPPING_THREAT': '납치 협박',
    'FAMILY_THREAT': '가족 사칭 협박',
    'REMOTE_APP_INSTALLATION': '원격 앱 설치',
  };

  static const defaultLabel = '보이스피싱';

  /// [type]에 대응하는 한글 라벨. 미정의·null·`NONE`이면 [defaultLabel].
  static String labelOf(String? type) => _labels[type] ?? defaultLabel;
}
