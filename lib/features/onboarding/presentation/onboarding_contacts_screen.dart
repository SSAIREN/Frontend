import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/primary_button.dart';
import 'package:ssairen/features/onboarding/widgets/onboarding_layout.dart';

class OnboardingContactsScreen extends StatelessWidget {
  const OnboardingContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            const _StepHeader(currentStep: 2, totalSteps: 4),
            const SizedBox(height: 48),
            const _ContactsPermissionCard(),
            const Spacer(),
            PrimaryButton(
              label: '연락처 허용하기',
              trailingIcon: Icons.arrow_forward,
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(RoutePaths.onboardingFamily);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              '나중에 설정에서 변경할 수 있어요',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.brandBlueStrong,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Column(
          children: [
            const Text(
              '단계',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '$currentStep / $totalSteps',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactsPermissionCard extends StatelessWidget {
  const _ContactsPermissionCard();

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
        children: [
          CircleAvatar(
            radius: 39,
            backgroundColor: AppColors.brandBlue,
            child: SvgPicture.asset(
              'assets/onboarding/contacts_screen.svg',
              width: 34,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const Text(
            '소중한 가족을 연결할게요',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppColors.brandBlueDark,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            '위험한 전화가 감지되면\n가족에게 즉시 알림을 보내요.\n연락처는 외부로 전송되지 않아요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/onboarding/logo_blue.svg',
                width: 14,
              ),
              const SizedBox(width: AppSpacing.sm),
              const Text(
                '가족 정보는 기기에만 저장돼요.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brandBlueStrong,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
