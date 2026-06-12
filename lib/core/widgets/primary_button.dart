import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final child = icon == null && trailingIcon == null
        ? Text(label)
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon),
                const SizedBox(width: 8),
              ],
              Text(label),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon),
              ],
            ],
          );

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
