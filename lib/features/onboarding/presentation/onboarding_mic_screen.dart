import 'package:flutter/material.dart';
import 'package:ssairen/core/widgets/placeholder_screen.dart';

class OnboardingMicScreen extends StatelessWidget {
  const OnboardingMicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: '통화 내용을 분석할게요',
      description: '온보딩 1/4 - 마이크 권한',
    );
  }
}
