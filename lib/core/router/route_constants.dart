/// Route path constants used throughout the app
class RouteConstants {
  // Private constructor to prevent instantiation
  RouteConstants._();

  // Auth routes
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';

  // Main routes
  static const String exercises = '/exercises';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  // Dynamic routes
  static const String exerciseDetail = '/exercise/:id';
  static const String workoutSession = '/workout-session';

  // Helper methods for dynamic routes
  static String exerciseDetailRoute(String id) => '/exercise/$id';
}
