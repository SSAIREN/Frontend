import 'package:flutter/material.dart';
import 'package:ssairen/core/widgets/placeholder_screen.dart';

class HarmfulDoneScreen extends StatelessWidget {
  const HarmfulDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: '모두 안전해요!',
      description: '납치협박 대응 완료',
    );
  }
}
