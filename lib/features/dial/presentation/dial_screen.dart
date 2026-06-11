import 'package:flutter/material.dart';
import 'package:ssairen/core/widgets/app_bottom_nav.dart';
import 'package:ssairen/core/widgets/placeholder_screen.dart';

class DialScreen extends StatelessWidget {
  const DialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PlaceholderScreen(
        title: '키패드',
        description: '다이얼 화면',
      ),
      bottomNavigationBar: AppBottomNav(currentTab: MainTab.dial),
    );
  }
}
