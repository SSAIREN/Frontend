import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/soft_blue_card.dart';

class WeeklyReportCard extends StatelessWidget {
  const WeeklyReportCard({
    required this.suspiciousCallCount,
    super.key,
  });

  final int suspiciousCallCount;

  @override
  Widget build(BuildContext context) {
    return SoftBlueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  '이번 주 리포트',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brandBlueDark,
                  ),
                ),
              ),
              Icon(
                Icons.insights,
                color: AppColors.brandBlueDark,
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '$suspiciousCallCount건',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: AppColors.brandBlueDark,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  suspiciousCallCount == 0 ? '의심 전화 없음' : '의심 전화 감지됨',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandBlue,
                  ),
                ),
              ),
              const _WeeklyBars(),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyBars extends StatelessWidget {
  const _WeeklyBars();

  static const _heights = [18.0, 10.0, 14.0, 8.0, 26.0, 16.0, 6.0];
  static const _highlightIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < _heights.length; i++) ...[
          if (i > 0) const SizedBox(width: 5),
          Container(
            width: 9,
            height: _heights[i],
            decoration: BoxDecoration(
              color: i == _highlightIndex
                  ? AppColors.brandBlue
                  : AppColors.brandBlueLight.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(4.5),
            ),
          ),
        ],
      ],
    );
  }
}
