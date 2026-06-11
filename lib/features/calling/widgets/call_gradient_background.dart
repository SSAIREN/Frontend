import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';

class CallGradientBackground extends StatelessWidget {
  const CallGradientBackground({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandBlueDark,
            Color(0xFF6160A6),
            Color(0xFFB59A84),
          ],
        ),
      ),
      child: child,
    );
  }
}
