import 'package:flutter/material.dart';
import 'package:ssairen/core/theme/app_colors.dart';

class PermissionIconCard extends StatelessWidget {
  const PermissionIconCard({
    required this.icon,
    super.key,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 42,
      backgroundColor: AppColors.brandBlue,
      child: Icon(icon, color: Colors.white, size: 38),
    );
  }
}
