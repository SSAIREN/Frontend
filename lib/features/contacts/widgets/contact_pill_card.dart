import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';

/// 즐겨찾기/내 프로필/그룹처럼 한 줄짜리 흰색 알약 카드.
class ContactPillCard extends StatelessWidget {
  const ContactPillCard({
    required this.label,
    this.leadingColor,
    this.leadingIcon,
    this.leadingAsset,
    super.key,
  }) : assert(
          leadingColor != null || leadingAsset != null,
          'leadingColor 또는 leadingAsset 중 하나는 필요합니다',
        );

  final String label;
  final Color? leadingColor;
  final IconData? leadingIcon;

  /// 지정하면 색상 원 대신 이미지를 leading으로 표시한다.
  final String? leadingAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          if (leadingAsset != null)
            Image.asset(leadingAsset!, width: 40, height: 40)
          else
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: leadingColor,
                shape: BoxShape.circle,
              ),
              child: leadingIcon == null
                  ? null
                  : Icon(leadingIcon, color: Colors.white, size: 22),
            ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
