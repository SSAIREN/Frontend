import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/app_bottom_nav.dart';
import 'package:ssairen/core/widgets/screen_action_icons.dart';
import 'package:ssairen/features/recents/widgets/call_log_section.dart';
import 'package:ssairen/models/call_log.dart';

class RecentsScreen extends StatelessWidget {
  const RecentsScreen({super.key});

  // TODO: 기기 통화 기록 연동 후 실제 데이터로 교체
  static final _logs = [
    CallLog(
      name: '엄마',
      phoneNumber: '010-1234-5678',
      calledAt: DateTime.now(),
      isOutgoing: true,
    ),
    CallLog(
      name: '아빠',
      phoneNumber: '010-2345-6789',
      calledAt: DateTime.now(),
    ),
    CallLog(
      name: '팀 싸이렌',
      phoneNumber: '010-8765-4321',
      calledAt: DateTime.now(),
    ),
    CallLog(
      name: '김땡땡',
      phoneNumber: '010-3456-7890',
      calledAt: DateTime.now(),
    ),
    CallLog(
      name: '양땡땡',
      phoneNumber: '010-4567-8901',
      calledAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    CallLog(
      name: '이땡땡',
      phoneNumber: '010-5678-9012',
      calledAt: DateTime.now().subtract(const Duration(days: 1)),
      isOutgoing: true,
    ),
    CallLog(
      name: '박땡땡',
      phoneNumber: '010-6789-0123',
      calledAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    CallLog(
      name: '최땡땡',
      phoneNumber: '010-7890-1234',
      calledAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  /// 통화 일자별로 묶어 '오늘'/'어제'/'M월 d일' 라벨을 붙인다.
  static Map<String, List<CallLog>> _groupByDay(List<CallLog> logs) {
    final grouped = <String, List<CallLog>>{};
    for (final log in logs) {
      (grouped[_dayLabel(log.calledAt)] ??= []).add(log);
    }
    return grouped;
  }

  static String _dayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    return switch (today.difference(day).inDays) {
      0 => '오늘',
      1 => '어제',
      _ => '${date.month}월 ${date.day}일',
    };
  }

  @override
  Widget build(BuildContext context) {
    final sections = _groupByDay(_logs);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      // 플로팅 하단 바 양옆으로 본문이 보이도록 확장
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            0,
            AppSpacing.screenPadding,
            // 플로팅 하단 바에 가리지 않도록 확보
            120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 72),
              const Center(
                child: Text(
                  '전화',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 56),
              const ScreenActionIcons(showSort: true),
              const SizedBox(height: AppSpacing.xl),
              for (final entry in sections.entries) ...[
                CallLogSection(title: entry.key, logs: entry.value),
                const SizedBox(height: AppSpacing.xl),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentTab: MainTab.recents),
    );
  }
}
