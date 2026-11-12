import 'package:flutter/material.dart';

import 'jajan_colors.dart';

/// Poppins lokal: tampilan konsisten saat offline, tanpa unduhan font runtime.
abstract final class JajanTypography {
  static TextTheme light(TextTheme base) => base.apply(
    fontFamily: 'Poppins',
    bodyColor: JajanColors.lightText,
    displayColor: JajanColors.lightText,
  );
  static TextTheme dark(TextTheme base) => base.apply(
    fontFamily: 'Poppins',
    bodyColor: JajanColors.darkText,
    displayColor: JajanColors.darkText,
  );
  static TextStyle pageTitle({Color color = JajanColors.lightText}) =>
      TextStyle(
        fontFamily: 'Poppins',
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color,
      );
  static TextStyle sectionTitle({Color color = JajanColors.lightText}) =>
      TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color,
      );
  static TextStyle body({Color color = JajanColors.lightText}) => TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: color,
  );
  static TextStyle caption({Color color = JajanColors.lightMuted}) => TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color,
  );
}
