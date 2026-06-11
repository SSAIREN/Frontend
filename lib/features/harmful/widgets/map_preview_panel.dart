import 'package:flutter/material.dart';

class MapPreviewPanel extends StatelessWidget {
  const MapPreviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(child: Text('REAL-TIME GPS')),
      ),
    );
  }
}
