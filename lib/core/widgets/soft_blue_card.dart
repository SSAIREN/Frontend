import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';

/// 연파랑 라운드 카드.
///
/// 홈 화면 카드와 완료/결과 화면의 안내 카드가 같은 장식을 공유한다.
class SoftBlueCard extends StatelessWidget {
  const SoftBlueCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.bgBlueSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.brandBlueLight.withValues(alpha: 0.45),
        ),
      ),
      child: child,
    );
  }
}
