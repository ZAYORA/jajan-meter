import 'package:flutter/material.dart';

/// Nilai dari Fondasi visual dan UI kit milik Agnie.
abstract final class JajanColors {
  static const blue = Color(0xFF2855EB);
  static const yellow = Color(0xFFF9D94E);
  static const orange = Color(0xFFFF8C51);
  static const ink = Color(0xFF17223B);
  static const muted = Color(0xFF687389);
  static const background = Color(0xFFF7F8FC);
  static const surface = Colors.white;
  static const border = Color(0xFFE5E9F2);
  static const paleBlue = Color(0xFFEAF0FF);
  static const paleYellow = Color(0xFFFFF7D6);
  static const paleOrange = Color(0xFFFFF0E7);
  static const danger = Color(0xFFC84938);
}

ThemeData buildJajanTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: JajanColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: JajanColors.blue,
      primary: JajanColors.blue,
      secondary: JajanColors.yellow,
      surface: JajanColors.surface,
      error: JajanColors.danger,
      onSurface: JajanColors.ink,
    ),
  );
  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      headlineLarge: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.12,
        color: JajanColors.ink,
      ),
      titleLarge: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: JajanColors.ink,
      ),
      bodyLarge: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        height: 1.4,
        color: JajanColors.ink,
      ),
      bodyMedium: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        height: 1.4,
        color: JajanColors.muted,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: JajanColors.background,
      foregroundColor: JajanColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 54),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        disabledBackgroundColor: const Color(0xFFE0E5EF),
        disabledForegroundColor: JajanColors.muted,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: JajanColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: JajanColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: JajanColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: JajanColors.blue, width: 2),
      ),
    ),
    dividerColor: JajanColors.border,
  );
}
