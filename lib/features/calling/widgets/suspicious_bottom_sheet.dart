import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/features/calling/widgets/risk_analysis_card.dart';

class SuspiciousBottomSheet extends StatelessWidget {
  const SuspiciousBottomSheet({
    required this.percent,
    required this.aiSummary,
    required this.keywords,
    this.onEndCall,
    this.onContinue,
    super.key,
  });

  final int percent;
  final String aiSummary;
  final List<String> keywords;
  final VoidCallback? onEndCall;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(21, 14, 21, 24 + bottomInset),
        decoration: const BoxDecoration(
          color: Color(0xFF1F1B21),
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF6A4515),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warningButton,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '의심 패턴이 감지됐어요',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            RiskAnalysisCard(percent: percent),
            const SizedBox(height: 22),
            Text(
              aiSummary,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.82),
                fontSize: 14,
                height: 1.42,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final keyword in _visibleKeywords) _Tag(label: keyword),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onEndCall ?? () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.warningButton,
                foregroundColor: AppColors.brandBlueDark,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('전화 끊기'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onContinue ?? () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.16)),
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('계속 통화'),
            ),
          ],
        ),
      ),
    );
  }

  List<String> get _visibleKeywords {
    if (keywords.isEmpty) return const ['검사', '수사', '입금'];
    return keywords.take(3).toList();
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.warningButton.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.warningButton),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.warningButton,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
