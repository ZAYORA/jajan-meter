import 'package:flutter/material.dart';

import '../theme/jajan_colors.dart';

/// Chip kategori generik. ID kategori dari repository tetap dikelola di luar
/// widget ini; widget hanya menerima label dan status pilihan.
class JmCategoryChip extends StatelessWidget {
  const JmCategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.accentColor = JajanColors.blue,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = selected
        ? (isDark ? Colors.white : accentColor)
        : Theme.of(context).colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? accentColor.withValues(alpha: isDark ? 0.25 : 0.12)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected
                  ? accentColor
                  : (isDark ? JajanColors.darkBorder : JajanColors.lightBorder),
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 17, color: selected ? accentColor : textColor),
                const SizedBox(width: 7),
              ],
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
