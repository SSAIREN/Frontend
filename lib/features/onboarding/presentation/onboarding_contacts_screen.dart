import 'package:flutter/material.dart';
import 'package:ssairen/core/widgets/placeholder_screen.dart';

class OnboardingContactsScreen extends StatelessWidget {
  const OnboardingContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: '소중한 가족을 연결할게요',
      description: '온보딩 2/4 - 연락처 권한',
    );
  }
}
