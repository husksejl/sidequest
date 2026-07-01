import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color accent = Color(0xFF00B2AA);
  static const Color danger = Color(0xFFFF8D84);

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF050608),
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: danger,
        surface: Color(0xFF0B0E12),
        onSurface: Colors.white,
      ),
    );
  }

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF008FA3),
        secondary: Color(0xFFD94A3D),
        surface: Colors.white,
        onSurface: Color(0xFF101317),
      ),
    );
  }
}

extension AppThemeColors on BuildContext {
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;

  Color get appBackground => Theme.of(this).scaffoldBackgroundColor;

  Color get appCardColor => isLightMode ? Colors.white : const Color(0xFF0B0E12);

  Color get appElevatedCardColor => isLightMode ? const Color(0xFFFDFDFE) : const Color(0xFF111317);

  Color get appTextColor => isLightMode ? const Color(0xFF101317) : Colors.white;

  Color get appMutedTextColor => isLightMode ? const Color(0xFF68707C) : const Color(0xFF8A8F98);

  Color get appBorderColor => isLightMode ? const Color(0xFFE1E6EE) : Colors.white.withOpacity(0.05);

  Color get appIconColor => isLightMode ? const Color(0xFF303946) : Colors.white70;
}
