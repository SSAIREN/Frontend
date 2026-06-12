import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/widgets/labeled_section_card.dart';
import 'package:ssairen/models/contact.dart';

/// 초성('ㄱ', 'ㄴ' …) 라벨과 해당 초성의 연락처 카드.
class ContactSection extends StatelessWidget {
  const ContactSection({
    required this.title,
    required this.contacts,
    this.onContactTap,
    super.key,
  });

  final String title;
  final List<Contact> contacts;
  final ValueChanged<Contact>? onContactTap;

  @override
  Widget build(BuildContext context) {
    return LabeledSectionCard(
      title: title,
      dividerIndent: 72,
      children: [
        for (final contact in contacts)
          _ContactTile(contact: contact, onTap: onContactTap),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact, this.onTap});

  final Contact contact;
  final ValueChanged<Contact>? onTap;

  /// 아바타용 파스텔 팔레트. 이름에 따라 결정적으로 색이 정해진다.
  static const _avatarPalette = [
    Color(0xFF81C784), // 연두
    Color(0xFFF06292), // 핑크
    Color(0xFFF48FB1), // 연핑크
    Color(0xFF64B5F6), // 하늘
    Color(0xFFFFB74D), // 주황
    Color(0xFF9575CD), // 보라
  ];

  Color get _avatarColor =>
      _avatarPalette[contact.name.codeUnits.first % _avatarPalette.length];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(contact),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _avatarColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                contact.name.characters.first,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                contact.name,
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
