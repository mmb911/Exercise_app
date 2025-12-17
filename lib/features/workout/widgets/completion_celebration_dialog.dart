import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/presentation/widgets/core_ui.dart';
import '../providers/workout_session_provider.dart';

class CompletionCelebrationDialog extends ConsumerWidget {
  const CompletionCelebrationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sessionAsync = ref.watch(workoutSessionProvider);

    final xpEarned = sessionAsync.value?.xpEarned ?? 100;

    // Auto-dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    });

    return Dialog(
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(32.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface.withOpacity(0.9),
                theme.colorScheme.surface.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Trophy Icon
              Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppTheme.neonGreen, AppTheme.electricBlue],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      size: 60.sp,
                      color: Colors.black,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 2000.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ),

              SizedBox(height: 24.h),

              // Title
              Text(
                '🎉 Great Job! 🎉',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.headlineLarge!.color,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms),

              SizedBox(height: 12.h),

              // XP Earned
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.neonGreen.withOpacity(0.3),
                      AppTheme.electricBlue.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Text(
                  '+$xpEarned XP Earned!',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms).scale(),

              SizedBox(height: 24.h),

              // Message
              Text(
                'You completed all exercises!\nKeep up the great work! 💪',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: theme.textTheme.bodyMedium!.color,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 600.ms),

              SizedBox(height: 24.h),

              // Close Button
              PrimaryButton(
                text: 'Awesome!',
                onPressed: () => Navigator.of(context).pop(),
                width: double.infinity,
                useGradient: true,
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
