import 'package:flutter/material.dart';

import '../theme/jajan_colors.dart';

/// Tombol bersama: callback null/loading = nonaktif, tinggi minimum 56.
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
    final scheme = Theme.of(context).colorScheme;
    final callback = isLoading ? null : onPressed;
    final color = backgroundColor ?? JajanColors.green;
    final foreground =
        foregroundColor ?? (outlined ? JajanColors.blue : Colors.white);
    final content = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: scheme.onSurfaceVariant,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 22),
                const SizedBox(width: 8),
              ],
              Flexible(child: Text(label, textAlign: TextAlign.center)),
            ],
          );
    final button = outlined
        ? OutlinedButton(
            onPressed: callback,
            style: OutlinedButton.styleFrom(
              foregroundColor: foreground,
              minimumSize: const Size(48, 56),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            child: content,
          )
        : Container(
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: callback == null
                      ? scheme.outlineVariant
                      : Color.lerp(color, Colors.black, .22)!,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: FilledButton(
              onPressed: callback,
              style: FilledButton.styleFrom(
                backgroundColor: color,
                foregroundColor: foreground,
                minimumSize: const Size(48, 56),
                disabledBackgroundColor: scheme.outlineVariant,
                disabledForegroundColor: scheme.onSurfaceVariant,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              child: content,
            ),
          );
    return SizedBox(width: expand ? double.infinity : null, child: button);
  }
}
