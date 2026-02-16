import 'package:flutter/material.dart';

class SpaceXTheme {
  static const Color brandColor = Color(0xFF6750A4);

  // Custom Status Colors
  static const Color successLight = Color(0xFF2E7D32);
  static const Color errorLight = Color(0xFFD32F2F);

  static const Color successDark = Color(0xFF81C784);
  static const Color errorDark = Color(0xFFE57373);

  /// Helper to get success color based on brightness
  static Color getSuccessColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? successLight : successDark;
  }

  /// Helper to get error color based on brightness
  static Color getErrorColor(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: brandColor, brightness: Brightness.light, error: errorLight),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0, scrolledUnderElevation: 2),
      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: brandColor, brightness: Brightness.dark, error: errorDark),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0, scrolledUnderElevation: 2),
      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0xFF424242), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}
