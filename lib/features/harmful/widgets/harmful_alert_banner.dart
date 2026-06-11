import 'package:flutter/material.dart';

class HarmfulAlertBanner extends StatelessWidget {
  const HarmfulAlertBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(title: Text('가족 협박형 보이스피싱이 감지됐어요')),
    );
  }
}
