import 'package:flutter/material.dart';
import 'package:ssairen/core/widgets/placeholder_screen.dart';

class CallingScreen extends StatelessWidget {
  const CallingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: '010-8765-4321',
      description: '통화 중 AI 모니터링',
    );
  }
}
