import 'package:flutter/material.dart';

import '../foundation/widgets/jm_button.dart';
import '../foundation/widgets/jm_card.dart';
import '../jajan_theme.dart';

/// Alias presentasional untuk komponen foundation, bukan sistem desain kedua.
class JajanSurface extends StatelessWidget {
  const JajanSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.onTap,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) =>
      JmCard(padding: padding, color: color, onTap: onTap, child: child);
}

class JajanActionButton extends StatelessWidget {
  const JajanActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = JajanColors.green,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  @override
  Widget build(BuildContext context) => JmButton(
    label: label,
    onPressed: onPressed,
    icon: icon,
    backgroundColor: color,
  );
}
