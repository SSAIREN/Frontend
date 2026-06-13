import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/models/guardian.dart';
import 'package:ssairen/features/onboarding/widgets/onboarding_layout.dart';

const _maxGuardians = 3;

class OnboardingFamilyScreen extends StatefulWidget {
  const OnboardingFamilyScreen({super.key});

  @override
  State<OnboardingFamilyScreen> createState() => _OnboardingFamilyScreenState();
}

class _OnboardingFamilyScreenState extends State<OnboardingFamilyScreen> {
  final List<Guardian> _guardians = [];

  void _removeGuardian(int index) {
    setState(() => _guardians.removeAt(index));
  }

  Future<void> _addGuardian() async {
    if (_guardians.length >= _maxGuardians) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('가족은 최대 $_maxGuardians명까지 등록할 수 있어요')),
      );
      return;
    }

    final picked = await FlutterContacts.openExternalPick();
    if (picked == null) return;

    var name = picked.displayName;
    var phoneNumber = '';
    try {
      final full = await FlutterContacts.getContact(
        picked.id,
        withProperties: true,
      );
      if (full != null) {
        if (full.displayName.isNotEmpty) name = full.displayName;
        if (full.phones.isNotEmpty) phoneNumber = full.phones.first.number;
      }
    } catch (_) {
      // 연락처 권한이 없으면 선택창에서 받은 이름만 사용한다.
    }

    if (!mounted) return;
    setState(() {
      _guardians.add(Guardian(name: name, phoneNumber: phoneNumber));
    });
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      currentStep: 4,
      buttonLabel: '가족 연결하기',
      onButtonPressed: () =>
          Navigator.of(context).pushNamed(RoutePaths.onboardingLocation),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '가족 보호 설정',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.brandBlueDark,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            '위급 상황 발생 시 즉시 연락을 받을\n보호자를 등록해 주세요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: AppColors.brandBlueStrong,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const Text(
            '등록된 가족',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < _maxGuardians; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: i < _guardians.length
                      ? _GuardianCard(
                          guardian: _guardians[i],
                          onDelete: () => _removeGuardian(i),
                        )
                      : const _EmptyGuardianSlot(),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _AddGuardianButton(onTap: _addGuardian),
        ],
      ),
    );
  }
}

class _GuardianCard extends StatelessWidget {
  const _GuardianCard({
    required this.guardian,
    required this.onDelete,
  });

  final Guardian guardian;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.brandBlueLight),
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.brandBlue, width: 1.2),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/onboarding/family_3B82F6.svg',
                    width: 18,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                guardian.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brandBlueDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: onDelete,
          child: Container(
            width: double.infinity,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.dangerRedBright,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Center(
              child: Text(
                '삭제',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyGuardianSlot extends StatelessWidget {
  const _EmptyGuardianSlot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.bgBlueSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.brandBlueLight, width: 1.2),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/onboarding/family_C4D9FC.svg',
                width: 18,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: 36,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.brandBlueLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _AddGuardianButton extends StatelessWidget {
  const _AddGuardianButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRRectPainter(
        color: AppColors.brandBlueLight,
        radius: 16,
      ),
      child: Material(
        color: AppColors.bgBlueSoft,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: const SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  size: 20,
                  color: AppColors.brandBlueStrong,
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  '가족 추가하기',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandBlueStrong,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({
    required this.color,
    required this.radius,
  });

  final Color color;
  final double radius;

  static const _dashLength = 6.0;
  static const _gapLength = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + _dashLength),
          paint,
        );
        distance += _dashLength + _gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRectPainter oldDelegate) {
    return color != oldDelegate.color || radius != oldDelegate.radius;
  }
}
