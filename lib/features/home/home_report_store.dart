import 'package:flutter/foundation.dart';

class HomeReportState {
  const HomeReportState({
    required this.suspiciousCallCount,
    required this.statusLabel,
  });

  const HomeReportState.initial()
      : suspiciousCallCount = 0,
        statusLabel = '의심 전화 없음';

  final int suspiciousCallCount;
  final String statusLabel;
}

abstract final class HomeReportStore {
  static final notifier = ValueNotifier<HomeReportState>(
    const HomeReportState.initial(),
  );

  static void markHarmfulResponseCompleted() {
    notifier.value = const HomeReportState(
      suspiciousCallCount: 1,
      statusLabel: '위험 상황 대응 완료',
    );
  }
}
