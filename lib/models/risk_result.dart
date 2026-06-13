import 'package:flutter/material.dart';

enum RiskLevel {
  safe,
  caution,
  warning,
  danger;

  factory RiskLevel.fromPercent(int percent) {
    if (percent <= 40) return RiskLevel.safe;
    if (percent <= 55) return RiskLevel.caution;
    if (percent <= 75) return RiskLevel.warning;
    return RiskLevel.danger;
  }

  String get label {
    return switch (this) {
      RiskLevel.safe => '안심',
      RiskLevel.caution => '주의',
      RiskLevel.warning => '경고',
      RiskLevel.danger => '위험',
    };
  }

  Color get color {
    return switch (this) {
      RiskLevel.safe => const Color(0xFF2AA97A),
      RiskLevel.caution => const Color(0xFFFBBF24),
      RiskLevel.warning => const Color(0xFFFB923C),
      RiskLevel.danger => const Color(0xFFBE3A3A),
    };
  }

  bool get shouldShowBottomSheet {
    return this == RiskLevel.warning || this == RiskLevel.danger;
  }
}

class RiskResult {
  const RiskResult({
    required this.percent,
    required this.type,
    this.transcript,
  });

  final int percent;
  final String type;
  final String? transcript;

  RiskLevel get level => RiskLevel.fromPercent(percent);
}
