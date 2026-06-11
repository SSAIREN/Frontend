import 'package:flutter/material.dart';
import 'package:ssairen/core/widgets/app_bottom_nav.dart';
import 'package:ssairen/core/widgets/placeholder_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PlaceholderScreen(
        title: '싸이렌',
        description: '홈/보호 상태 화면',
      ),
      bottomNavigationBar: AppBottomNav(currentTab: MainTab.home),
    );
  }
}
