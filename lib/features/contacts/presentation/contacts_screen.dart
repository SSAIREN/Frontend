import 'package:flutter/material.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';
import 'package:ssairen/core/theme/app_spacing.dart';
import 'package:ssairen/core/utils/hangul.dart';
import 'package:ssairen/core/widgets/app_bottom_nav.dart';
import 'package:ssairen/core/widgets/screen_action_icons.dart';
import 'package:ssairen/core/widgets/section_label.dart';
import 'package:ssairen/features/contacts/widgets/contact_pill_card.dart';
import 'package:ssairen/features/contacts/widgets/contact_section.dart';
import 'package:ssairen/models/contact.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  static const _contacts = [
    Contact(name: '팀 싸이렌', phoneNumber: '010-8765-4321'),
    Contact(name: '강땡땡', phoneNumber: '010-1111-2222'),
    Contact(name: '고땡땡', phoneNumber: '010-2222-3333'),
    Contact(name: '구땡땡', phoneNumber: '010-3333-4444'),
    Contact(name: '김땡땡', phoneNumber: '010-4444-5555'),
    Contact(name: '박땡땡', phoneNumber: '010-5555-6666'),
    Contact(name: '이땡땡', phoneNumber: '010-6666-7777'),
    Contact(name: '최땡땡', phoneNumber: '010-7777-8888'),
  ];

  static Map<String, List<Contact>> _groupByInitial(List<Contact> contacts) {
    final grouped = <String, List<Contact>>{};
    for (final contact in contacts) {
      (grouped[Hangul.initialOf(contact.name)] ??= []).add(contact);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final sections = _groupByInitial(_contacts);

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              const SizedBox(height: AppSpacing.sm),
              const Text(
                // TODO: 연락처 연동 후 실제 개수로 교체
                '전화번호가 저장된 연락처 8개',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 30),
              const ScreenActionIcons(showAdd: true),
              const SizedBox(height: AppSpacing.xl),
              const ContactPillCard(
                label: '즐겨찾는 연락처 추가',
                leadingColor: AppColors.warningButton,
                leadingIcon: Icons.star,
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SectionLabel('내 프로필'),
              const ContactPillCard(
                label: '싸이렌',
                leadingAsset: 'assets/main_logo.png',
              ),
              const SizedBox(height: AppSpacing.lg),
              const ContactPillCard(
                label: '그룹',
                leadingColor: AppColors.textMuted,
                leadingIcon: Icons.group,
              ),
              const SizedBox(height: AppSpacing.xxl),
              for (final entry in sections.entries) ...[
                ContactSection(
                  title: entry.key,
                  contacts: entry.value,
                  // TODO: 입력 번호 전달은 calling 담당자와 협의 (RouteSettings.arguments)
                  onContactTap: (_) =>
                      Navigator.of(context).pushNamed(RoutePaths.calling),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentTab: MainTab.contacts),
    );
  }
}
