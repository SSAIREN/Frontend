import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
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
    final color = level.color;

    return Container(
      height: 154,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.17),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color, width: 1.3),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.45),
            blurRadius: 22,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomRight: Radius.circular(7),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.health_and_safety,
                    size: 14,
                    color: AppColors.brandBlueDark,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'AIMONITORING ACTIVE',
                    style: TextStyle(
                      color: AppColors.brandBlueDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 25,
            top: 62,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '의심 상태: ${level.label}',
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '보이스피싱 확률',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 28,
            top: 38,
            child: SizedBox.square(
              dimension: 88,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: percent / 100,
                    strokeWidth: 6,
                    color: color,
                    backgroundColor: Colors.white.withValues(alpha: 0.20),
                  ),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      color: color,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
