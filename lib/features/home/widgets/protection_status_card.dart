import 'package:flutter/material.dart';

class ProtectionStatusCard extends StatelessWidget {
  const ProtectionStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(child: ListTile(title: Text('보호 중')));
  }
}
