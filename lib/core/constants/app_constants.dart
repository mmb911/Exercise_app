import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // API Configuration
  static String get exerciseApiBaseUrl =>
      dotenv.env['EXERCISE_API_BASE_URL'] ??
      'https://exercisedb.p.rapidapi.com';

  // Storage Keys
  static const String themeModeKey = 'theme_mode';
  static const String favoritesBoxName = 'favorites';

  // App Info
  static const String appName = 'FitHub';
  static const String appVersion = '1.0.0';

  // Pagination
  static const int exercisesPerPage = 20;

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration searchDebounce = Duration(milliseconds: 500);
}
