import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';

/// 화면 우측 상단의 액션 아이콘 묶음.
///
/// 검색 + 더보기(주황 알림 점)는 항상 표시하고,
/// 정렬/추가 아이콘은 화면에 따라 옵션으로 켠다.
class ScreenActionIcons extends StatelessWidget {
  const ScreenActionIcons({
    this.showSort = false,
    this.showAdd = false,
    super.key,
  });

  final bool showSort;
  final bool showAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showSort) ...[
          const Icon(Icons.sort, size: 26, color: AppColors.textHeading),
          const SizedBox(width: AppSpacing.xl),
        ],
        if (showAdd) ...[
          const Icon(Icons.add, size: 26, color: AppColors.textHeading),
          const SizedBox(width: AppSpacing.xl),
        ],
        const Icon(Icons.search, size: 26, color: AppColors.textHeading),
        const SizedBox(width: AppSpacing.xl),
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.more_vert,
              size: 26,
              color: AppColors.textHeading,
            ),
            Positioned(
              top: -2,
              right: -4,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.alertOrange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
