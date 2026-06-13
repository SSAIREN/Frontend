import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/primary_button.dart';
import 'package:ssairen/features/onboarding/widgets/onboarding_step_header.dart';

class OnboardingLayout extends StatelessWidget {
  const OnboardingLayout({
    required this.child,
    this.currentStep,
    this.totalSteps = 5,
    this.buttonLabel,
    this.onButtonPressed,
    this.caption = '나중에 설정에서 변경할 수 있어요',
    super.key,
  });

  final Widget child;

  /// null이면 상단 단계 헤더를 표시하지 않는다.
  final int? currentStep;
  final int totalSteps;

  /// null이면 하단 버튼 영역을 표시하지 않는다.
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  /// 버튼 아래 캡션. null이면 표시하지 않는다.
  final String? caption;

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
              if (currentStep != null) ...[
                const SizedBox(height: AppSpacing.lg),
                OnboardingStepHeader(
                  currentStep: currentStep!,
                  totalSteps: totalSteps,
                ),
                const SizedBox(height: 48),
              ],
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: child,
                ),
              ),
              if (buttonLabel != null) ...[
                PrimaryButton(
                  label: buttonLabel!,
                  trailingIcon: Icons.arrow_forward,
                  onPressed: onButtonPressed,
                ),
                if (caption != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    caption!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.brandBlueStrong,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xxl),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
