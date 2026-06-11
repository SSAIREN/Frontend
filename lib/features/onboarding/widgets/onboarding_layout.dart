import 'package:flutter/material.dart';

class OnboardingLayout extends StatelessWidget {
  const OnboardingLayout({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
    );
  }
}
