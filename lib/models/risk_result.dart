import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';

enum RiskLevel {
  safe,
  caution,
  warning,
  danger;

  factory RiskLevel.fromPercent(int percent) {
    if (percent <= 30) return RiskLevel.safe;
    if (percent <= 50) return RiskLevel.caution;
    if (percent <= 80) return RiskLevel.warning;
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
      RiskLevel.safe => AppColors.safeGreen,
      RiskLevel.caution => AppColors.warningOrange,
      RiskLevel.warning => AppColors.alertOrange,
      RiskLevel.danger => AppColors.dangerRed,
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
