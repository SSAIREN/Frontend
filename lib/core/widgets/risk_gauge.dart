import 'package:flutter/material.dart';
import 'package:ssairen/models/risk_result.dart';

class RiskGauge extends StatelessWidget {
  const RiskGauge({
    required this.percent,
    super.key,
  });

  final int percent;

  @override
  Widget build(BuildContext context) {
    final level = RiskLevel.fromPercent(percent);

    return SizedBox.square(
      dimension: 76,
      child: CircularProgressIndicator(
        value: percent / 100,
        strokeWidth: 6,
        color: level.color,
        backgroundColor: level.color.withValues(alpha: 0.14),
      ),
    );
  }
}
