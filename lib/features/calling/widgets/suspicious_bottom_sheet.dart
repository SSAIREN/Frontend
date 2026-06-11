import 'package:flutter/material.dart';

class SuspiciousBottomSheet extends StatelessWidget {
  const SuspiciousBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text('의심 패턴이 감지됐어요'),
      ),
    );
  }
}
