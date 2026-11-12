import 'package:flutter/material.dart';

import 'jajan_colors.dart';

/// Satu sumber tema untuk UI Kit dan shell adaptif. Font dibundel lokal.
abstract final class JajanTheme {
  static ThemeData light() => _build();
  static ThemeData dark() => _build(brightness: Brightness.dark);
  static ThemeData _build({Brightness brightness = Brightness.light}) {
    final dark = brightness == Brightness.dark;
    final ink = dark ? const Color(0xFFEAF2F8) : JajanColors.ink;
    final muted = dark ? const Color(0xFFA4B8C7) : const Color(0xFF65788A);
    final border = dark ? JajanColors.darkBorder : JajanColors.border;
    final background = dark
        ? JajanColors.darkBackground
        : JajanColors.background;
    final scheme = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: JajanColors.blue,
      primary: JajanColors.blue,
      onPrimary: JajanColors.ink,
      secondary: JajanColors.green,
      onSecondary: JajanColors.ink,
      tertiary: JajanColors.yellow,
      onTertiary: JajanColors.ink,
      surface: dark ? JajanColors.darkSurface : JajanColors.surface,
      onSurface: ink,
      onSurfaceVariant: muted,
      outlineVariant: border,
      error: JajanColors.danger,
    );
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
    );
    TextStyle text(double size, FontWeight weight) => TextStyle(
      fontFamily: 'Poppins',
      fontSize: size,
      fontWeight: weight,
      height: 1.4,
      color: ink,
    );
    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineLarge: text(24, FontWeight.w700),
        headlineMedium: text(24, FontWeight.w700),
        titleLarge: text(20, FontWeight.w700),
        titleMedium: text(16, FontWeight.w600),
        bodyLarge: text(14, FontWeight.w500),
        bodyMedium: text(14, FontWeight.w400),
        bodySmall: text(12, FontWeight.w400).copyWith(color: muted),
        labelLarge: text(14, FontWeight.w700),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 56),
          backgroundColor: JajanColors.blue,
          foregroundColor: JajanColors.ink,
          textStyle: text(16, FontWeight.w700),
          shape: const StadiumBorder(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF172B39) : const Color(0xFFEEF3F6),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: JajanColors.blue, width: 2),
        ),
      ),
      dividerColor: border,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.disabled) ? muted : Colors.white,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? JajanColors.green
              : border,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
    );
  }
}
