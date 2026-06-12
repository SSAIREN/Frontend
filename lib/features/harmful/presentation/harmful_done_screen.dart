import 'package:flutter/material.dart';
import 'package:ssairen/core/router/app_router.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/glowing_check.dart';
import 'package:ssairen/core/widgets/primary_button.dart';

class HarmfulDoneScreen extends StatelessWidget {
  const HarmfulDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // 화면이 작으면 스크롤되고, 충분하면 Spacer가 여백을 채우는 구조
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - AppSpacing.screenPadding * 2,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 2),
                    const Center(child: GlowingCheck()),
                    const SizedBox(height: 40),
                    const Text(
                      '모두 안전해요!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      '아드님이 안전한 것이 확인됐어요.\n경찰에 자동으로 신고가 완료됐습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const Spacer(flex: 2),
                    const Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SafetyCheckRow(label: '아들 김철수 안전 확인'),
                          SizedBox(height: AppSpacing.lg),
                          _SafetyCheckRow(label: '경찰 자동 신고 완료'),
                          SizedBox(height: AppSpacing.lg),
                          _SafetyCheckRow(label: '통화 내용 익명 처리 완료'),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    const _PoliceMessageCard(message: '"신고 접수됐습니다. 수고하셨습니다."'),
                    const SizedBox(height: AppSpacing.xl),
                    const Text(
                      '위험한 상황에서 침착하게 대응하여 큰 사고를 막으셨습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const Spacer(flex: 2),
                    PrimaryButton(
                      label: '확인',
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacement(AppRouter.fadeRoute(RoutePaths.home));
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 초록 체크 원 + 안전 확인 문구 한 줄.
class _SafetyCheckRow extends StatelessWidget {
  const _SafetyCheckRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: AppColors.safeGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 14),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// 경찰청 안내 메시지 카드.
class _PoliceMessageCard extends StatelessWidget {
  const _PoliceMessageCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.bgBlueSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.brandBlueLight.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.brandBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_police,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '대한민국 경찰청',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brandBlue,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}