import 'package:flutter/material.dart';
import 'package:ssairen/core/widgets/placeholder_screen.dart';

class OnboardingFamilyScreen extends StatelessWidget {
  const OnboardingFamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: '가족 보호 설정',
      description: '온보딩 3/4 - 보호자 등록',
    );
  }
}
