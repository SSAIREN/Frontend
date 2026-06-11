import 'package:flutter/material.dart';
import 'package:ssairen/core/widgets/risk_badge.dart';
import 'package:ssairen/core/widgets/risk_gauge.dart';
import 'package:ssairen/models/risk_result.dart';

class RiskMonitorPanel extends StatelessWidget {
  const RiskMonitorPanel({
    required this.percent,
    super.key,
  });

  final int percent;

  @override
  Widget build(BuildContext context) {
    final level = RiskLevel.fromPercent(percent);

    return Card(
      child: ListTile(
        title: Text('보이스피싱 확률 $percent%'),
        subtitle: RiskBadge(level: level),
        trailing: RiskGauge(percent: percent),
      ),
    );
  }
}
