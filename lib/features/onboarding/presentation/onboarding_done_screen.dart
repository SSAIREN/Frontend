import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/features/onboarding/widgets/onboarding_layout.dart';

class OnboardingDoneScreen extends StatelessWidget {
  const OnboardingDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      buttonLabel: '싸이렌 시작하기',
      caption: null,
      onButtonPressed: () => Navigator.of(context)
          .pushNamedAndRemoveUntil(RoutePaths.dial, (route) => false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 80),
          Image.asset(
            'assets/onboarding/done_screen_check.png',
            width: 140,
          ),
          const SizedBox(height: AppSpacing.xxl),
          const Text(
            '준비가 됐어요!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.brandBlueDark,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const Text(
            '이제 싸이렌이 통화를 지켜볼게요.\n가족들에게도 알림을 보냈어요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              fontWeight: FontWeight.w600,
              color: AppColors.brandBlueStrong,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _FamilySummaryCard(memberCount: 2),
        ],
      ),
    );
  }
}

class _FamilySummaryCard extends StatelessWidget {
  const _FamilySummaryCard({required this.memberCount});

  final int memberCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgBlueSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.brandBlueLight, width: 0.8),
      ),
      child: Row(
        children: [
          const _OverlappedMemberIcons(),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '등록된 가족 $memberCount명',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brandBlueDark,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '보호 설정이 활성화되었습니다',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.shield,
            size: 24,
            color: AppColors.brandBlue,
          ),
        ],
      ),
    );
  }
}

class _OverlappedMemberIcons extends StatelessWidget {
  const _OverlappedMemberIcons();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 40,
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/onboarding/done_screen_member.svg',
            width: 40,
          ),
          Positioned(
            left: 24,
            child: SvgPicture.asset(
              'assets/onboarding/done_screen_member.svg',
              width: 40,
            ),
          ),
        ],
      ),
    );
  }
}
