import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';

/// 완료/결과 화면의 중앙 타이틀 + 부제목 블록.
class ScreenHeadline extends StatelessWidget {
  const ScreenHeadline({
    required this.title,
    required this.subtitle,
    this.gap = AppSpacing.lg,
    super.key,
  });

  final String title;
  final String subtitle;

  /// 타이틀과 부제목 사이 간격.
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: gap),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
