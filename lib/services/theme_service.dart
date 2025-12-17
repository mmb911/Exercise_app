import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../core/constants/app_constants.dart';

class ThemeService {
  final _logger = Logger();

  // Get saved theme mode
  Future<ThemeMode> getThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex =
          prefs.getInt(AppConstants.themeModeKey) ?? 2; // Default to dark mode

      switch (themeIndex) {
        case 0:
          return ThemeMode.system;
        case 1:
          return ThemeMode.light;
        case 2:
          return ThemeMode.dark;
        default:
          return ThemeMode.dark; // Fallback to dark mode
      }
    } catch (e) {
      _logger.e('Error getting theme mode: $e');
      return ThemeMode.dark; // Error fallback to dark mode
    }
  }

  // Save theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int themeIndex;

      switch (themeMode) {
        case ThemeMode.system:
          themeIndex = 0;
          break;
        case ThemeMode.light:
          themeIndex = 1;
          break;
        case ThemeMode.dark:
          themeIndex = 2;
          break;
      }

      await prefs.setInt(AppConstants.themeModeKey, themeIndex);
      _logger.i('Theme mode saved: $themeMode');
    } catch (e) {
      _logger.e('Error setting theme mode: $e');
      throw 'Failed to save theme preference';
    }
  }

  // Toggle between light and dark
  Future<ThemeMode> toggleTheme(ThemeMode current) async {
    final newMode = current == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newMode);
    return newMode;
  }
}
