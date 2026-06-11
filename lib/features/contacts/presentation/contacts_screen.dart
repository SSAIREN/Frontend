import 'package:flutter/material.dart';
import 'package:ssairen/core/widgets/app_bottom_nav.dart';
import 'package:ssairen/core/widgets/placeholder_screen.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PlaceholderScreen(
        title: '전화',
        description: '연락처 화면',
      ),
      bottomNavigationBar: AppBottomNav(currentTab: MainTab.contacts),
    );
  }
}
