import 'package:flutter/material.dart';
import '../presentation/widgets/core_ui.dart';

/// Extension to easily access theme-aware colors
/// Falls back to appropriate light/dark colors based on brightness
extension ThemeHelpers on BuildContext {
  /// Gets the primary color (neon green)
  Color get primaryColor => Theme.of(this).colorScheme.primary;

  /// Gets the secondary color (electric blue)
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;

  /// Gets the background color
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;

  /// Gets the surface color
  Color get surfaceColor => Theme.of(this).colorScheme.surface;

  /// Gets the error color
  Color get errorColor => Theme.of(this).colorScheme.error;

  /// Gets theme-aware text primary color
  Color get textPrimary {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark
        ? AppTheme.textPrimary
        : AppTheme.lightTextPrimary;
  }

  /// Gets theme-aware text secondary color
  Color get textSecondary {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark
        ? AppTheme.textSecondary
        : AppTheme.lightTextSecondary;
  }

  /// Checks if current theme is dark
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
