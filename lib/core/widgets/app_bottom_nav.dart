import 'package:flutter/material.dart';
import 'package:ssairen/core/router/route_paths.dart';
import 'package:ssairen/core/theme/app_colors.dart';

enum MainTab {
  dial,
  recents,
  contacts,
  home,
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.currentTab,
    super.key,
  });

  final MainTab currentTab;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentTab.index,
      indicatorColor: AppColors.bgBlueSoft,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.dialpad), label: '키패드'),
        NavigationDestination(icon: Icon(Icons.history), label: '최근기록'),
        NavigationDestination(icon: Icon(Icons.person), label: '연락처'),
        NavigationDestination(icon: Icon(Icons.health_and_safety), label: '싸이렌'),
      ],
      onDestinationSelected: (index) {
        final path = switch (MainTab.values[index]) {
          MainTab.dial => RoutePaths.dial,
          MainTab.recents => RoutePaths.recents,
          MainTab.contacts => RoutePaths.contacts,
          MainTab.home => RoutePaths.home,
        };
        Navigator.of(context).pushReplacementNamed(path);
      },
    );
  }
}
