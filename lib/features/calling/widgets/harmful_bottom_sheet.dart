import 'package:flutter/material.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/features/calling/widgets/risk_analysis_card.dart';
import 'package:ssairen/features/harmful/harmful_dashboard_args.dart';

class HarmfulBottomSheet extends StatelessWidget {
  const HarmfulBottomSheet({
    required this.percent,
    required this.aiSummary,
    required this.keywords,
    required this.phoneNumber,
    required this.callElapsed,
    this.onEndCall,
    super.key,
  });

  final int percent;
  final String aiSummary;
  final List<String> keywords;
  final String phoneNumber;
  final Duration callElapsed;
  final VoidCallback? onEndCall;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        padding: EdgeInsets.fromLTRB(21, 14, 21, 15 + bottomInset),
        decoration: BoxDecoration(
          color: const Color(0xFF2A1014),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFF55151B),
                    child: Icon(Icons.warning_amber_rounded, color: Colors.red),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '높은 확률로 보이스피싱이에요',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              RiskAnalysisCard(percent: percent),
              const SizedBox(height: 22),
              Text(
                _visibleSummary,
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
                  for (final keyword in _visibleKeywords)
                    _DangerTag(label: keyword),
                ],
              ),
              const SizedBox(height: 18),
              const _ResponsePlanCard(),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(
                    RoutePaths.harmfulDashboard,
                    arguments: HarmfulDashboardArgs(
                      phoneNumber: phoneNumber,
                      callElapsed: callElapsed,
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.brandBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('AI 계획 실행'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: onEndCall ?? () => Navigator.of(context).pop(),
                child: const Text(
                  '전화끊기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _visibleSummary {
    if (aiSummary.trim().isNotEmpty) return aiSummary;
    return '가족을 사칭한 협박과 입금 유도 표현이 감지되었습니다.';
  }

  List<String> get _visibleKeywords {
    if (keywords.isEmpty) return const ['납치', '아들', '입금'];
    return keywords;
  }
}

class _DangerTag extends StatelessWidget {
  const _DangerTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE2451F).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFFE03B22).withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ResponsePlanCard extends StatelessWidget {
  const _ResponsePlanCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF3A1117),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brandBlue, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandBlue.withValues(alpha: 0.38),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.health_and_safety,
                color: AppColors.brandBlue,
                size: 19,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '싸이렌이 아래 계획으로 대응할게요',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _ProtectedTarget(),
          SizedBox(height: 24),
          _PlanStep(
            number: '1',
            text: '아들 현재 위치 확인',
            description: '휴대폰 GPS를 기반으로 안전 여부를 즉시 파악합니다.',
          ),
          SizedBox(height: 14),
          _PlanStep(
            number: '2',
            text: '아들에게 지속 알림 발송',
            description: '전화 및 긴급 메시지를 통해 직접 연결을 시도합니다.',
          ),
          SizedBox(height: 14),
          _PlanStep(
            number: '3',
            text: '경찰과 실시간 상황 공유',
            description: '사기 정황과 통화 자료를 관계 센터에 전송합니다.',
          ),
        ],
      ),
    );
  }
}

class _ProtectedTarget extends StatelessWidget {
  const _ProtectedTarget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.52)),
      ),
      child: Row(
        children: [
          Text(
            '보호 대상',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          const CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.brandBlue,
            child: Text(
              '아',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '아들',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanStep extends StatelessWidget {
  const _PlanStep({
    required this.number,
    required this.text,
    required this.description,
  });

  final String number;
  final String text;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor: AppColors.brandBlue,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 11,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
