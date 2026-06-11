import 'package:flutter/material.dart';

class HarmfulBottomSheet extends StatelessWidget {
  const HarmfulBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text('가족 협박형 보이스피싱이 감지됐어요'),
      ),
    );
  }
}
