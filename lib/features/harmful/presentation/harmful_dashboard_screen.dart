import 'package:flutter/material.dart';
import 'package:ssairen/core/widgets/placeholder_screen.dart';

class HarmfulDashboardScreen extends StatelessWidget {
  const HarmfulDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: '아들에게 답장이 왔어요!',
      description: '납치협박 실시간 대응 화면',
    );
  }
}
