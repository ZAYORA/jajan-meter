import 'package:flutter/material.dart';

import '../theme/jajan_colors.dart';

/// Tombol bersama dengan tinggi, radius, dan bobot visual konsisten.
class JmButton extends StatelessWidget {
  const JmButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    this.outlined = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool expand;
  final bool outlined;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final foreground = foregroundColor ??
        (outlined ? JajanColors.blue : Colors.white);
    final child = isLoading
        ? SizedBox(
            width: 19,
            height: 19,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: foreground,
            ),
          )
        : Text(label);

    final button = outlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: foreground,
              minimumSize: const Size(0, 52),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              side: BorderSide(color: backgroundColor ?? JajanColors.blue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: child,
          )
        : (icon != null && !isLoading)
            ? ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon, size: 19),
                label: Text(label),
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor ?? JajanColors.green,
                  foregroundColor: foreground,
                  minimumSize: const Size(0, 52),
                  elevation: 3,
                  shadowColor:
                      (backgroundColor ?? JajanColors.green).withValues(alpha: 0.35),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor ?? JajanColors.green,
                  foregroundColor: foreground,
                  minimumSize: const Size(0, 52),
                  elevation: 3,
                  shadowColor:
                      (backgroundColor ?? JajanColors.green).withValues(alpha: 0.35),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: child,
              );

    return SizedBox(
      width: expand ? double.infinity : null,
      child: button,
    );
  }
}
