import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/models/risk_result.dart';

class RiskMonitorPanel extends StatelessWidget {
  const RiskMonitorPanel({
    required this.percent,
    this.height = 170,
    super.key,
  });

  final int percent;
  final double height;

  @override
  Widget build(BuildContext context) {
    final level = RiskLevel.fromPercent(percent);
    final color = level.color;
    final scale = height / 170;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.95), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 20,
            spreadRadius: 0,
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
              height: 28 * scale,
              padding: EdgeInsets.symmetric(horizontal: 10 * scale),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomRight: Radius.circular(7),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/icons/calling-ssiren-icon-ai.png',
                    width: 12 * scale,
                    height: 14 * scale,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 4 * scale),
                  Text(
                    'AIMONITORING ACTIVE',
                    style: TextStyle(
                      color: AppColors.brandBlueDark,
                      fontSize: 11 * scale,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 25 * scale,
            top: 68 * scale,
            child: SizedBox(
              width: 184 * scale,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '의심 상태: ${level.label}',
                    style: TextStyle(
                      color: color,
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10 * scale),
                  Text(
                    '보이스피싱 확률',
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                      color: const Color(0xFFD7D9E8),
                      fontSize: 21 * scale,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 42 * scale,
            top: 35 * scale,
            child: SizedBox.square(
              dimension: 96 * scale,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: CircularProgressIndicator(
                      value: percent / 100,
                      strokeWidth: 6.8 * scale,
                      color: color,
                      backgroundColor: color.withValues(alpha: 0.12),
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      color: color,
                      fontSize: 23 * scale,
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
