import 'package:flutter/material.dart';

class ThemeService {
  ThemeService._();

  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(
    ThemeMode.dark,
  );

  static bool get isLightMode => themeMode.value == ThemeMode.light;

  static void setLightMode(bool enabled) {
    themeMode.value = enabled ? ThemeMode.light : ThemeMode.dark;
  }
}
