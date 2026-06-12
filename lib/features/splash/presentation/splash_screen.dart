import 'package:flutter/material.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/primary_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset(
                'assets/main_logo.png',
                width: 170,
              ),
              const SizedBox(height: AppSpacing.xl),
              Image.asset(
                'assets/main_title.png',
                width: 235,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                '가족이 지켜주는 전화 앱',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHeading,
                ),
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                label: '시작하기',
                trailingIcon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(RoutePaths.onboardingMic);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'v1.0.4 Protective Guardian AI',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
