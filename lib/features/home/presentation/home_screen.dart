import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/app_bottom_nav.dart';
import 'package:ssairen/features/home/home_report_store.dart';
import 'package:ssairen/features/home/widgets/guardian_list.dart';
import 'package:ssairen/features/home/widgets/home_status_tile.dart';
import 'package:ssairen/features/home/widgets/protection_status_card.dart';
import 'package:ssairen/features/home/widgets/weekly_report_card.dart';
import 'package:ssairen/models/guardian.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // TODO: 보호자 연동 API 연결 후 실제 데이터로 교체
  static const _guardians = [
    Guardian(name: '김철수', relationship: '아들', isActive: true),
    Guardian(name: '김영희', relationship: '딸'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 하단 바가 플로팅 형태라 본문이 바 뒤까지 이어져야 함
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            0,
            AppSpacing.screenPadding,
            // 플로팅 하단 바(58) + 하단 여백에 가리지 않도록 확보
            96,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              const Center(
                child: Text(
                  '싸이렌',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const ProtectionStatusCard(protectedDuration: '2시간 32분'),
              const SizedBox(height: AppSpacing.lg),
              ValueListenableBuilder<HomeReportState>(
                valueListenable: HomeReportStore.notifier,
                builder: (context, report, _) {
                  return WeeklyReportCard(
                    suspiciousCallCount: report.suspiciousCallCount,
                    statusLabel: report.statusLabel,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              const Row(
                children: [
                  Expanded(
                    child: HomeStatusTile(
                      icon: Icons.call,
                      label: '실시간 검사',
                      value: '최상',
                    ),
                  ),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: HomeStatusTile(
                      icon: Icons.update,
                      label: 'DB 업데이트',
                      value: '12분 전',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              const _GuardianSectionHeader(),
              const SizedBox(height: AppSpacing.md),
              const GuardianList(guardians: _guardians),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentTab: MainTab.home),
    );
  }
}

/// '내 보호자' 섹션 제목과 초대 보내기 버튼.
class _GuardianSectionHeader extends StatelessWidget {
  const _GuardianSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            '내 보호자',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            // TODO: 보호자 초대 기능 연결
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.brandBlue,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.add_circle_outline, size: 18),
          label: const Text(
            '초대 보내기',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
