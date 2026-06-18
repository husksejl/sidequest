import 'package:flutter/material.dart';

class ThemeService {
  ThemeService._();

  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(
    ThemeMode.system,
  );

  static ThemeMode get currentMode => themeMode.value;

  static void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
  }

  static void useSystemTheme() {
    setThemeMode(ThemeMode.system);
  }

  static void useLightTheme() {
    setThemeMode(ThemeMode.light);
  }

  static void useDarkTheme() {
    setThemeMode(ThemeMode.dark);
  }

  // Kept so older code does not break if it still calls this method.
  static void setLightMode(bool enabled) {
    setThemeMode(enabled ? ThemeMode.light : ThemeMode.dark);
  }

  static ThemeMode modeFromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  static String modeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  static String labelForMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}