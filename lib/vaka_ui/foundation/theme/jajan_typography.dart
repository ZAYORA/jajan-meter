import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'jajan_colors.dart';

/// Sistem tipografi Poppins untuk seluruh UI Jajan Meter.
///
/// Catatan kompatibilitas:
/// google_fonts 9.x menggunakan TextTheme dari package material_ui,
/// sedangkan aplikasi ini masih memakai TextTheme dari Flutter SDK.
/// Karena itu, jangan gunakan GoogleFonts.poppinsTextTheme().
/// Terapkan font per TextStyle agar kedua jenis TextTheme tidak bercampur.
abstract final class JajanTypography {
  static TextTheme light(TextTheme base) {
    final coloredTheme = base.apply(
      bodyColor: JajanColors.lightText,
      displayColor: JajanColors.lightText,
    );
    return _withGoogleFont(coloredTheme, GoogleFonts.poppins);
  }

  static TextTheme dark(TextTheme base) {
    final coloredTheme = base.apply(
      bodyColor: JajanColors.darkText,
      displayColor: JajanColors.darkText,
    );
    return _withGoogleFont(coloredTheme, GoogleFonts.poppins);
  }

  /// Menerapkan font melalui TextStyle, bukan helper TextTheme dari
  /// google_fonts, agar kompatibel dengan Flutter SDK Material.
  static TextTheme _withGoogleFont(
    TextTheme base,
    TextStyle Function({TextStyle? textStyle}) font,
  ) {
    TextStyle? apply(TextStyle? style) {
      return style == null ? null : font(textStyle: style);
    }

    return base.copyWith(
      displayLarge: apply(base.displayLarge),
      displayMedium: apply(base.displayMedium),
      displaySmall: apply(base.displaySmall),
      headlineLarge: apply(base.headlineLarge),
      headlineMedium: apply(base.headlineMedium),
      headlineSmall: apply(base.headlineSmall),
      titleLarge: apply(base.titleLarge),
      titleMedium: apply(base.titleMedium),
      titleSmall: apply(base.titleSmall),
      bodyLarge: apply(base.bodyLarge),
      bodyMedium: apply(base.bodyMedium),
      bodySmall: apply(base.bodySmall),
      labelLarge: apply(base.labelLarge),
      labelMedium: apply(base.labelMedium),
      labelSmall: apply(base.labelSmall),
    );
  }

  static TextStyle pageTitle({Color color = JajanColors.lightText}) {
    return GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle sectionTitle({Color color = JajanColors.lightText}) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle body({Color color = JajanColors.lightText}) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle caption({Color color = JajanColors.lightMuted}) {
    return GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }
}
