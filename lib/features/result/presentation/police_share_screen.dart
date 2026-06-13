import 'package:flutter/material.dart';
import 'package:ssairen/core/router/app_router.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/primary_button.dart';
import 'package:ssairen/core/widgets/screen_headline.dart';
import 'package:ssairen/core/widgets/soft_blue_card.dart';
import 'package:ssairen/core/widgets/stretch_scroll_column.dart';
import 'package:ssairen/features/result/widgets/result_stat_card.dart';

class PoliceShareScreen extends StatelessWidget {
  const PoliceShareScreen({super.key});

  /// 통화 화면에서 전달된 통화 지속 시간을 'mm:ss'로 포맷한다.
  /// 전달값이 없으면 데모용 기본값을 쓴다.
  String _callDurationOf(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Duration) return '04:21';
    final minutes = args.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = args.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StretchScrollColumn(
          children: [
            const Spacer(),
            Center(
              child: Container(
                width: 120,
                height: 120,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.bgBlueSoft,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/logo_check.png',
                  width: 68,
                  height: 68,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const ScreenHeadline(
              title: '이제 안심하세요',
              subtitle: '통화가 종료됐어요. 위험 요소는 사라졌습니다.',
              gap: AppSpacing.md,
            ),
            const Spacer(),
            const _PrivacyNoticeCard(),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                const Expanded(
                  child: ResultStatCard(
                    icon: Icons.warning,
                    iconColor: AppColors.warningButton,
                    label: '위험 감지 항목',
                    value: '보이스피싱',
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: ResultStatCard(
                    icon: Icons.watch_later,
                    iconColor: AppColors.brandBlue,
                    label: '통화 지속 시간',
                    value: _callDurationOf(context),
                  ),
                ),
              ],
            ),
            const Spacer(),
            PrimaryButton(
              label: '경찰에 공유하기',
              icon: Icons.share,
              onPressed: () {
                // TODO: 경찰 공유 API 연동
                Navigator.of(context).pushReplacement(
                  AppRouter.fadeRoute(RoutePaths.receiptDone),
                );
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  AppRouter.fadeRoute(RoutePaths.home),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textMuted,
              ),
              child: const Text(
                '괜찮아요',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 개인정보 보호 안내 카드.
class _PrivacyNoticeCard extends StatelessWidget {
  const _PrivacyNoticeCard();

  @override
  Widget build(BuildContext context) {
    return const SoftBlueCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.visibility_off,
            color: AppColors.brandBlue,
            size: 24,
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '개인정보는 안전하게 보호돼요',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  '공유되는 정보는 수사 목적으로만 사용되며, '
                  '이름과 연락처는 익명화 처리를 거쳐 안전하게 전달됩니다. '
                  '오직 범죄 예방을 위한 통화 내용 분석 결과만 공유됩니다.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.6,
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
