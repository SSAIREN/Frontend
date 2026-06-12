import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/labeled_section_card.dart';
import 'package:ssairen/models/call_log.dart';

/// '오늘'/'어제' 같은 날짜 라벨과 해당 날짜의 통화 기록 카드.
class CallLogSection extends StatelessWidget {
  const CallLogSection({
    required this.title,
    required this.logs,
    this.onLogTap,
    super.key,
  });

  final String title;
  final List<CallLog> logs;
  final ValueChanged<CallLog>? onLogTap;

  @override
  Widget build(BuildContext context) {
    return LabeledSectionCard(
      title: title,
      dividerIndent: 56,
      children: [
        for (final log in logs) _CallLogTile(log: log, onTap: onLogTap),
      ],
    );
  }
}

class _CallLogTile extends StatelessWidget {
  const _CallLogTile({required this.log, this.onTap});

  final CallLog log;
  final ValueChanged<CallLog>? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(log),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xl,
        ),
        child: Row(
          children: [
            Icon(
              log.isOutgoing ? Icons.call_made : Icons.call_received,
              size: 20,
              color: log.isOutgoing
                  ? AppColors.safeGreenAlt
                  : AppColors.textMuted,
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
      ),
    );
  }
}
