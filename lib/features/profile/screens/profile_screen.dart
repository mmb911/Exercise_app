import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/presentation/widgets/core_ui.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/route_constants.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // User Info Card
            GlassCard(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: AppTheme.neonGreen,
                    backgroundImage: currentUser?.photoURL != null
                        ? NetworkImage(currentUser!.photoURL!)
                        : null,
                    child: currentUser?.photoURL == null
                        ? Icon(Icons.person, size: 50.sp, color: Colors.white)
                        : null,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    currentUser?.displayName ?? 'User',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headlineSmall?.color,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    currentUser?.email ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Theme Toggle Card
            GlassCard(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.neonGreen.withOpacity(0.3),
                          AppTheme.electricBlue.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: AppTheme.neonGreen,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(
                              context,
                            ).textTheme.titleMedium?.color,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Toggle between light and dark theme',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isDark,
                    onChanged: (value) {
                      ref.read(themeModeProvider.notifier).toggleTheme();
                    },
                    activeColor: AppTheme.neonGreen,
                    activeTrackColor: AppTheme.neonGreen.withOpacity(0.5),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // App Info Card
            GlassCard(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.electricBlue.withOpacity(0.3),
                          AppTheme.neonGreen.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: AppTheme.electricBlue,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'App Version',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(
                              context,
                            ).textTheme.titleMedium?.color,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          AppConstants.appVersion,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // Sign Out Button
            PrimaryButton(
              text: 'Sign Out',
              onPressed: () async {
                final authService = ref.read(authServiceProvider);
                await authService.signOut();
                if (context.mounted) {
                  context.go(RouteConstants.login);
                }
              },
              useGradient: false,
            ),
          ],
        ),
      ),
    );
  }
}
