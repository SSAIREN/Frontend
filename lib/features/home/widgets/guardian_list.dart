import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/models/guardian.dart';

class GuardianList extends StatelessWidget {
  const GuardianList({
    required this.guardians,
    super.key,
  });

  final List<Guardian> guardians;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgBlueSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.brandBlueLight.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        children: [
          for (var i = 0; i < guardians.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.brandBlueLight.withValues(alpha: 0.35),
              ),
            _GuardianTile(guardian: guardians[i]),
          ],
        ],
      ),
    );
  }
}

class _GuardianTile extends StatelessWidget {
  const _GuardianTile({required this.guardian});

  final Guardian guardian;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.brandBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${guardian.relationship} (${guardian.name})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brandBlueDark,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  guardian.isActive ? '연결됨 • 보호 활성화' : '초대 수락 대기중',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandBlue,
                  ),
                ),
              ],
            ),
          ),
          if (guardian.isActive)
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.safeGreenAlt,
                shape: BoxShape.circle,
              ),
            )
          else
            const Icon(
              Icons.more_horiz,
              color: AppColors.textMuted,
              size: 22,
            ),
        ],
      ),
    );
  }
}
