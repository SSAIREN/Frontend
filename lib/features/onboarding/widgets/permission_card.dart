import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';

class PermissionCard extends StatelessWidget {
  const PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
    this.footnote,
    super.key,
  });

  /// 파란 원 안에 들어가는 아이콘 (SvgPicture, Icon 등)
  final Widget icon;
  final String title;
  final String description;

  /// 카드 하단의 파란 안내 문구. null이면 표시하지 않는다.
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: 40,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgBlueSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.brandBlueLight, width: 0.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 39,
            backgroundColor: AppColors.brandBlue,
            child: icon,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppColors.brandBlueDark,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          if (footnote != null) ...[
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/onboarding/logo_blue.svg',
                  width: 14,
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    footnote!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brandBlueStrong,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
