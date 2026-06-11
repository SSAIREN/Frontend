import 'package:flutter/material.dart';
import 'package:ssairen/models/risk_result.dart';

class RiskBadge extends StatelessWidget {
  const RiskBadge({
    required this.level,
    super.key,
  });

  final RiskLevel level;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(level.label),
      backgroundColor: level.color.withValues(alpha: 0.14),
      labelStyle: TextStyle(
        color: level.color,
        fontWeight: FontWeight.w700,
      ),
      side: BorderSide(color: level.color.withValues(alpha: 0.35)),
    );
  }
}
