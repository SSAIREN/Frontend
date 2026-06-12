import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';

/// 회색 라벨('오늘', 'ㄱ' 등) + 흰색 라운드 카드 + 행 사이 구분선 묶음.
///
/// 최근기록·연락처처럼 목록을 날짜/초성으로 묶어 보여주는 화면에서 공용으로 쓴다.
class LabeledSectionCard extends StatelessWidget {
  const LabeledSectionCard({
    required this.title,
    required this.children,
    this.dividerIndent = 0,
    super.key,
  });

  final String title;
  final List<Widget> children;

  /// 구분선 왼쪽 들여쓰기 (아이콘/아바타 너비만큼).
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: dividerIndent,
                    color: AppColors.bgSecondary,
                  ),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
