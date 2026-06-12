import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';

/// 섹션 제목용 회색 라벨 ('내 프로필', '오늘', 'ㄱ' 등).
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
