import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/models/risk_result.dart';

class RiskAnalysisCard extends StatelessWidget {
  const RiskAnalysisCard({
    required this.percent,
    super.key,
  });

  final int percent;

  @override
  Widget build(BuildContext context) {
    final level = RiskLevel.fromPercent(percent);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFF333333),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                '위험도 분석',
                style: TextStyle(
                  color: Color(0xFFC4C1CC),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                level.label,
                style: TextStyle(
                  color: level.color,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _GradientRiskBar(
            value: percent.clamp(0, 100).toDouble() / 100,
            colors: _gradientColors(level),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '안전',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '위험',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static List<Color> _gradientColors(RiskLevel level) {
    return switch (level) {
      RiskLevel.safe => const [
        AppColors.brandBlue,
        Color(0xFF2AA97A),
      ],
      RiskLevel.caution => const [
        AppColors.brandBlue,
        Color(0xFFFBBF24),
      ],
      RiskLevel.warning => const [
        AppColors.brandBlue,
        AppColors.warningOrange,
      ],
      RiskLevel.danger => const [
        AppColors.brandBlue,
        AppColors.warningOrange,
        Color(0xFFBE3A3A),
      ],
    };
  }
}

class _GradientRiskBar extends StatelessWidget {
  const _GradientRiskBar({
    required this.value,
    required this.colors,
  });

  final double value;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0).toDouble();

    return SizedBox(
      height: 8,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: clampedValue,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
