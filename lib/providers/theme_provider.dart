import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/theme_service.dart';

// Theme Service Provider
final themeServiceProvider = Provider<ThemeService>((ref) {
  return ThemeService();
});

// Theme Mode State Notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final ThemeService _themeService;

  ThemeModeNotifier(this._themeService) : super(ThemeMode.dark) {
    // Start with dark mode
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    state = await _themeService.getThemeMode();
  }

  Future<void> toggleTheme() async {
    state = await _themeService.toggleTheme(state);
  }

  Future<void> setTheme(ThemeMode mode) async {
    await _themeService.setThemeMode(mode);
    state = mode;
  }
}

// Theme Mode Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  final themeService = ref.watch(themeServiceProvider);
  return ThemeModeNotifier(themeService);
});
