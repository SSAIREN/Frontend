import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/models/call_log.dart';

/// '오늘'/'어제' 같은 날짜 라벨과 해당 날짜의 통화 기록 카드.
class CallLogSection extends StatelessWidget {
  const CallLogSection({
    required this.title,
    required this.logs,
    super.key,
  });

  final String title;
  final List<CallLog> logs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              for (var i = 0; i < logs.length; i++) ...[
                if (i > 0)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    indent: 56,
                    color: AppColors.bgSecondary,
                  ),
                _CallLogTile(log: logs[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CallLogTile extends StatelessWidget {
  const _CallLogTile({required this.log});

  final CallLog log;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xl,
      ),
      child: Row(
        children: [
          Icon(
            log.isOutgoing ? Icons.call_made : Icons.call_received,
            size: 20,
            color:
                log.isOutgoing ? AppColors.safeGreenAlt : AppColors.textMuted,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              log.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
