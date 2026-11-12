import 'package:flutter/material.dart';

/// Kartu fondasi yang juga dipakai JajanSurface: radius 24, border 2, shadow Y6.
class JmCard extends StatelessWidget {
  const JmCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.color,
    this.radius = 24,
    this.border = true,
    this.onTap,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double radius;
  final bool border;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(color: scheme.outlineVariant, offset: const Offset(0, 6)),
        ],
      ),
      child: Material(
        color: color ?? scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: border
              ? BorderSide(color: scheme.outlineVariant, width: 2)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
