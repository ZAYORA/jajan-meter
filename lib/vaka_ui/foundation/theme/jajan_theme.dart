import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'jajan_colors.dart';
import 'jajan_typography.dart';

/// Theme terang dan gelap Jajan Meter.
/// Gunakan JajanTheme.light() dan JajanTheme.dark() pada MaterialApp.
abstract final class JajanTheme {
  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final textColor = isDark ? JajanColors.darkText : JajanColors.lightText;
    final mutedColor = isDark ? JajanColors.darkMuted : JajanColors.lightMuted;
    final surfaceColor =
        isDark ? JajanColors.darkSurface : JajanColors.lightSurface;
    final borderColor =
        isDark ? JajanColors.darkBorder : JajanColors.lightBorder;
    final backgroundColor =
        isDark ? JajanColors.darkBackground : JajanColors.lightBackground;

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
    );

    final scheme = ColorScheme.fromSeed(
      seedColor: JajanColors.blue,
      brightness: brightness,
    ).copyWith(
      primary: JajanColors.blue,
      onPrimary: Colors.white,
      secondary: JajanColors.green,
      onSecondary: Colors.white,
      tertiary: JajanColors.gold,
      error: JajanColors.red,
      surface: surfaceColor,
    );

    final textTheme = isDark
        ? JajanTypography.dark(base.textTheme)
        : JajanTypography.light(base.textTheme);

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: backgroundColor,
      canvasColor: backgroundColor,
      cardColor: surfaceColor,
      dividerColor: borderColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: JajanColors.green,
          foregroundColor: Colors.white,
          disabledBackgroundColor: JajanColors.green.withValues(alpha: 0.45),
          elevation: 3,
          shadowColor: JajanColors.green.withValues(alpha: 0.35),
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: JajanColors.blue,
          minimumSize: const Size(0, 50),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
          side: const BorderSide(color: JajanColors.blue, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor:
            isDark ? JajanColors.darkSurfaceElevated : JajanColors.lightSurface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.poppins(
          color: mutedColor,
          fontSize: 13,
        ),
        labelStyle: GoogleFonts.poppins(
          color: mutedColor,
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: JajanColors.blue, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: JajanColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: JajanColors.red, width: 1.8),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
