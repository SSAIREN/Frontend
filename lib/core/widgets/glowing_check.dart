import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';

/// 연녹색 글로우 링에 둘러싸인 체크 아이콘 (완료 화면 공용).
class GlowingCheck extends StatelessWidget {
  const GlowingCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.safeGreen.withValues(alpha: 0.25),
            AppColors.safeGreen.withValues(alpha: 0.0),
          ],
          stops: const [0.5, 1.0],
        ),
      ),
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          color: AppColors.safeGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 36),
      ),
    );
  }
}
