import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/presentation/widgets/core_ui.dart';
import '../../../models/exercise_model.dart';
import '../../../providers/favorites_provider.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  final ExerciseModel exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider(exercise.id));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 350.h,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
                onPressed: () async {
                  final notifier = ref.read(
                    favoriteToggleProvider(exercise.id).notifier,
                  );
                  await notifier.toggle(exercise);
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'exercise-${exercise.id}',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.scaffoldBackgroundColor,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: exercise.gifUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Skeletonizer(
                      enabled: true,
                      child: Container(color: theme.colorScheme.surface),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(
                        Icons.fitness_center,
                        size: 100.sp,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise Name
                  Text(
                        exercise.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.headlineLarge!.color,
                          letterSpacing: 1.2,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideX(begin: -0.2, end: 0, duration: 400.ms),

                  SizedBox(height: 24.h),

                  // Info Cards Row
                  Row(
                        children: [
                          Expanded(
                            child: _InfoCardGlass(
                              icon: Icons.accessibility_new,
                              label: 'Body Part',
                              value: exercise.bodyPart,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _InfoCardGlass(
                              icon: Icons.fitness_center,
                              label: 'Equipment',
                              value: exercise.equipment,
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 400.ms)
                      .slideY(begin: 0.2, end: 0, duration: 400.ms),

                  SizedBox(height: 12.h),

                  _InfoCardGlass(
                        icon: Icons.my_location,
                        label: 'Target Muscle',
                        value: exercise.target,
                        isWide: true,
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideY(begin: 0.2, end: 0, duration: 400.ms),

                  SizedBox(height: 32.h),

                  // Secondary Muscles
                  if (exercise.secondaryMuscles.isNotEmpty) ...[
                    Text(
                      'Secondary Muscles',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.headlineSmall!.color,
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                    SizedBox(height: 12.h),

                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: exercise.secondaryMuscles
                          .map(
                            (muscle) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary.withOpacity(0.2),
                                    theme.colorScheme.secondary.withOpacity(
                                      0.2,
                                    ),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                muscle,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

                    SizedBox(height: 32.h),
                  ],

                  // Instructions
                  if (exercise.instructions.isNotEmpty) ...[
                    Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.headlineSmall!.color,
                      ),
                    ).animate().fadeIn(delay: 500.ms, duration: 400.ms),

                    SizedBox(height: 16.h),

                    ...exercise.instructions
                        .asMap()
                        .entries
                        .map(
                          (entry) =>
                              Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: GlassCard(
                                      padding: EdgeInsets.all(16.w),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 32.w,
                                            height: 32.h,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  AppTheme.neonGreen,
                                                  AppTheme.electricBlue,
                                                ],
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${entry.key + 1}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 16.w),
                                          Expanded(
                                            child: Text(
                                              entry.value,
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                color: theme
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(
                                    delay: (600 + entry.key * 100).ms,
                                    duration: 400.ms,
                                  )
                                  .slideX(
                                    begin: 0.2,
                                    end: 0,
                                    delay: (600 + entry.key * 100).ms,
                                    duration: 400.ms,
                                  ),
                        )
                        .toList(),
                  ],

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Glass Info Card Widget
class _InfoCardGlass extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isWide;

  const _InfoCardGlass({
    required this.icon,
    required this.label,
    required this.value,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Icon(icon, size: 36.sp, color: theme.colorScheme.primary),
          SizedBox(height: 12.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.textTheme.bodySmall!.color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: isWide ? 16.sp : 15.sp,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleMedium!.color,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
