import 'package:flutter/material.dart';

import 'foundation/theme/jajan_colors.dart';
import 'foundation/theme/jajan_theme.dart';
export 'foundation/theme/jajan_colors.dart';

extension JajanThemeContext on BuildContext {
  Color get cardColor => Theme.of(this).colorScheme.surface;
  Color get inkColor => Theme.of(this).colorScheme.onSurface;
  Color get mutedColor => Theme.of(this).colorScheme.onSurfaceVariant;
  Color get lineColor => Theme.of(this).colorScheme.outlineVariant;
  Color get softBlue => Theme.of(this).brightness == Brightness.dark
      ? const Color(0xFF153E53)
      : JajanColors.paleBlue;
}

/// Jembatan API komponen minggu 1-2 ke tema foundation yang sama.
ThemeData buildJajanTheme({Brightness brightness = Brightness.light}) =>
    brightness == Brightness.dark ? JajanTheme.dark() : JajanTheme.light();
