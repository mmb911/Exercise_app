import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/presentation/widgets/core_ui.dart';
import '../../../core/router/route_constants.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    // Wait for 3 seconds before navigating
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.go(RouteConstants.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppTheme.darkBackground,
                    AppTheme.darkSurface,
                    AppTheme.darkBackground,
                  ]
                : [
                    AppTheme.lightBackground,
                    Colors.white,
                    AppTheme.lightBackground,
                  ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo Icon
              Icon(
                    Icons.fitness_center,
                    size: 120.sp,
                    color: AppTheme.neonGreen,
                  )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),
              SizedBox(height: 32.h),

              // App Name with Shimmer Effect
              Shimmer.fromColors(
                    baseColor: AppTheme.textPrimary,
                    highlightColor: AppTheme.neonGreen,
                    period: const Duration(milliseconds: 1500),
                    child: Text(
                      'FitHub',
                      style: TextStyle(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),

              SizedBox(height: 16.h),

              // Tagline
              Text(
                    'Your Fitness Journey Starts Here',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppTheme.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 400.ms)
                  .slideY(begin: 0.5, end: 0, duration: 400.ms),

              SizedBox(height: 80.h),

              // Loading Indicator
              SizedBox(
                    width: 40.w,
                    height: 40.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.neonGreen,
                      ),
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .fadeIn(delay: 800.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
