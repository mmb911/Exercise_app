import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/presentation/widgets/core_ui.dart';
import 'core/presentation/widgets/connectivity_banner.dart';
import 'core/router/app_router.dart';
import 'providers/theme_provider.dart';
import 'providers/favorites_provider.dart';
import 'features/workout/models/workout_session_model.dart';
import 'features/workout/models/workout_exercise_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp();

  await Hive.initFlutter();

  // Register Hive adapters for workout gamification
  Hive.registerAdapter(WorkoutSessionModelAdapter());
  Hive.registerAdapter(WorkoutExerciseModelAdapter());

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize favorites service
    ref.read(favoritesServiceProvider).init();

    // Watch theme mode
    final themeMode = ref.watch(themeModeProvider);

    // Watch router
    final router = ref.watch(routerProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X base size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ConnectivityBanner(
          child: MaterialApp.router(
            title: 'FitHub',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getLightTheme(),
            darkTheme: AppTheme.getDarkTheme(),
            themeMode: themeMode,
            routerConfig: router,
          ),
        );
      },
    );
  }
}
