import 'package:flutter/material.dart';
import 'package:ssairen/core/widgets/placeholder_screen.dart';

class OnboardingDoneScreen extends StatelessWidget {
  const OnboardingDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: '준비가 됐어요!',
      description: '온보딩 완료',
    );
  }
}
