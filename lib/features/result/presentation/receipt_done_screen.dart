import 'package:flutter/material.dart';
import 'package:ssairen/core/widgets/placeholder_screen.dart';

class ReceiptDoneScreen extends StatelessWidget {
  const ReceiptDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: '접수됐습니다',
      description: '경찰 접수 완료',
    );
  }
}
