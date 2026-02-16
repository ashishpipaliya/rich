import 'package:flutter/material.dart';
import 'app_colors.dart';

class SpaceXCardColors extends ThemeExtension<SpaceXCardColors> {
  final List<Color> gradientColors;
  final Color orbitalColor;
  final Color reflectionColor;
  final Color borderColor;
  final Color contentColor;

  const SpaceXCardColors({
    required this.gradientColors,
    required this.orbitalColor,
    required this.reflectionColor,
    required this.borderColor,
    required this.contentColor,
  });

  @override
  SpaceXCardColors copyWith({List<Color>? gradientColors, Color? orbitalColor, Color? reflectionColor, Color? borderColor, Color? contentColor}) {
    return SpaceXCardColors(
      gradientColors: gradientColors ?? this.gradientColors,
      orbitalColor: orbitalColor ?? this.orbitalColor,
      reflectionColor: reflectionColor ?? this.reflectionColor,
      borderColor: borderColor ?? this.borderColor,
      contentColor: contentColor ?? this.contentColor,
    );
  }

  @override
  SpaceXCardColors lerp(ThemeExtension<SpaceXCardColors>? other, double t) {
    if (other is! SpaceXCardColors) return this;
    return SpaceXCardColors(
      gradientColors: [
        Color.lerp(gradientColors[0], other.gradientColors[0], t)!,
        Color.lerp(gradientColors[1], other.gradientColors[1], t)!,
        Color.lerp(gradientColors[2], other.gradientColors[2], t)!,
      ],
      orbitalColor: Color.lerp(orbitalColor, other.orbitalColor, t)!,
      reflectionColor: Color.lerp(reflectionColor, other.reflectionColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      contentColor: Color.lerp(contentColor, other.contentColor, t)!,
    );
  }

  static SpaceXCardColors of(BuildContext context) => Theme.of(context).extension<SpaceXCardColors>()!;
}

class SpaceXTheme {
  /// Helper to get success color based on brightness
  static Color getSuccessColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? AppColors.successLight : AppColors.successDark;
  }

  static Color getErrorColor(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(seedColor: AppColors.brandPrimary, brightness: Brightness.light, error: AppColors.errorLight);
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(scrolledUnderElevation: 0, surfaceTintColor: Colors.transparent, backgroundColor: Colors.transparent),
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
      extensions: [
        SpaceXCardColors(
          gradientColors: [
            colorScheme.primaryContainer.withValues(alpha: 0.4),
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
            colorScheme.surface,
          ],
          orbitalColor: colorScheme.primary.withValues(alpha: 0.1),
          reflectionColor: colorScheme.primary.withValues(alpha: 0.05),
          borderColor: colorScheme.primary.withValues(alpha: 0.1),
          contentColor: colorScheme.onSurface,
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(seedColor: AppColors.brandPrimary, brightness: Brightness.dark, error: AppColors.errorDark);
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(scrolledUnderElevation: 0, surfaceTintColor: Colors.transparent, backgroundColor: Colors.transparent),
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
      extensions: const [
        SpaceXCardColors(
          gradientColors: AppColors.deepSpaceGradient,
          orbitalColor: Color(0x336750A4),
          reflectionColor: AppColors.glassWhite,
          borderColor: AppColors.glassBorder,
          contentColor: Colors.white,
        ),
      ],
    );
  }
}
