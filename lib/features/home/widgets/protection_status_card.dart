import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';

class ProtectionStatusCard extends StatelessWidget {
  const ProtectionStatusCard({
    required this.protectedDuration,
    super.key,
  });

  final String protectedDuration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.bgBlueSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.brandBlueLight.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '보호 중',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brandBlueDark,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '오늘 $protectedDuration 보호됨',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandBlue,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brandBlueLight.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/widget_logo_blue.png',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}
