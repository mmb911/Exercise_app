import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/exercises/screens/exercises_list_screen.dart';
import '../../features/exercises/screens/exercise_detail_screen.dart';
import '../../features/favorites/screens/favorites_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/workout/screens/workout_session_screen.dart';
import '../../providers/auth_provider.dart';
import '../../models/exercise_model.dart';
import 'route_constants.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: RouteConstants.splash,
    redirect: (context, state) {
      final isAuth = authState.value != null;
      final isGoingToLogin = state.matchedLocation == RouteConstants.login;
      final isGoingToSignup = state.matchedLocation == RouteConstants.signup;
      final isGoingToSplash = state.matchedLocation == RouteConstants.splash;

      // Allow splash screen to show first
      if (isGoingToSplash) {
        return null;
      }

      // If not authenticated and not going to auth screens, redirect to login
      if (!isAuth && !isGoingToLogin && !isGoingToSignup) {
        return RouteConstants.login;
      }

      // If authenticated and going to auth screens, redirect to home
      if (isAuth && (isGoingToLogin || isGoingToSignup)) {
        return RouteConstants.exercises;
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteConstants.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RouteConstants.exercises,
        builder: (context, state) => const ExercisesListScreen(),
      ),
      GoRoute(
        path: RouteConstants.exerciseDetail,
        builder: (context, state) {
          final exercise = state.extra as ExerciseModel;
          return ExerciseDetailScreen(exercise: exercise);
        },
      ),
      GoRoute(
        path: RouteConstants.workoutSession,
        builder: (context, state) {
          final exercises = state.extra as List<ExerciseModel>;
          return WorkoutSessionScreen(exercises: exercises);
        },
      ),
      GoRoute(
        path: RouteConstants.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: RouteConstants.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
