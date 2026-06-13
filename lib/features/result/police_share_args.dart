import 'package:ssairen/core/utils/phishing_type.dart';

/// 통화 화면 → 경찰 공유 화면으로 전달하는 통화 결과 인자.
class PoliceShareArgs {
  const PoliceShareArgs({
    required this.callDuration,
    required this.phishingType,
  });

  /// 통화 지속 시간.
  final Duration callDuration;

  /// 서버가 판단한 피싱 유형 enum (예: ACCOUNT_TRANSFER_INDUCEMENT).
  final String phishingType;

  /// 'mm:ss' 포맷 통화 시간.
  String get formattedDuration {
    final minutes = callDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = callDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// 위험 감지 항목용 한글 라벨.
  String get phishingTypeLabel => PhishingType.labelOf(phishingType);
}
