import 'package:flutter/material.dart';
import 'package:ssairen/core/widgets/app_bottom_nav.dart';
import 'package:ssairen/core/widgets/placeholder_screen.dart';

class RecentsScreen extends StatelessWidget {
  const RecentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PlaceholderScreen(
        title: '전화',
        description: '최근기록 화면',
      ),
      bottomNavigationBar: AppBottomNav(currentTab: MainTab.recents),
    );
  }
}
