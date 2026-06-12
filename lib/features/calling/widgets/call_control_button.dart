import 'package:flutter/material.dart';

class CallControlButton extends StatelessWidget {
  const CallControlButton({
    required this.icon,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final effectiveBackground =
        backgroundColor ?? Colors.white.withValues(alpha: 0.17);
    final effectiveForeground = foregroundColor ?? Colors.white;
    final effectiveOnPressed = onPressed ?? () {};

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: effectiveOnPressed,
          borderRadius: BorderRadius.circular(18),
          splashColor: Colors.white.withValues(alpha: 0.16),
          highlightColor: Colors.white.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Ink(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: effectiveBackground,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(icon, color: effectiveForeground, size: 30),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: effectiveForeground,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
