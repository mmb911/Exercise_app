import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/presentation/widgets/core_ui.dart';
import '../../../providers/exercise_provider.dart';
import '../widgets/exercise_card_glass.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../../../core/router/route_constants.dart';

class ExercisesListScreen extends ConsumerStatefulWidget {
  const ExercisesListScreen({super.key});

  @override
  ConsumerState<ExercisesListScreen> createState() =>
      _ExercisesListScreenState();
}

class _ExercisesListScreenState extends ConsumerState<ExercisesListScreen> {
  @override
  Widget build(BuildContext context) {
    final filteredExercises = ref.watch(filteredExercisesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar with Gradient
          SliverAppBar(
            expandedHeight: 180.h,
            floating: false,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Exercises',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.headlineLarge!.color,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.2),
                      theme.colorScheme.surface,
                      theme.colorScheme.secondary.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.fitness_center,
                    size: 80.sp,
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.favorite, color: theme.colorScheme.primary),
                onPressed: () => context.push(RouteConstants.favorites),
              ),
              IconButton(
                icon: Icon(Icons.person, color: theme.colorScheme.primary),
                onPressed: () => context.push(RouteConstants.profile),
              ),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: SearchBarWidget(
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              ),
            ),
          ),

          // Filter Button
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const FilterBottomSheet(),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppTheme.neonGreen.withOpacity(0.5),
                          width: 1.5,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      icon: Icon(Icons.filter_list, color: AppTheme.neonGreen),
                      label: Text(
                        'Filters',
                        style: TextStyle(
                          color: AppTheme.neonGreen,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 16.h)),

          // Exercises List
          filteredExercises.when(
            data: (exercises) {
              if (exercises.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80.sp,
                          color: AppTheme.textSecondary.withOpacity(0.5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No exercises found',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final exercise = exercises[index];
                    return ExerciseCardGlass(
                          exercise: exercise,
                          onTap: () {
                            context.push(
                              RouteConstants.exerciseDetailRoute(exercise.id),
                              extra: exercise,
                            );
                          },
                        )
                        .animate()
                        .fadeIn(delay: (50 * index).ms, duration: 400.ms)
                        .slideY(
                          begin: 0.2,
                          end: 0,
                          delay: (50 * index).ms,
                          duration: 400.ms,
                        );
                  }, childCount: exercises.length),
                ),
              );
            },
            loading: () => SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Shimmer.fromColors(
                    baseColor: AppTheme.darkSurface,
                    highlightColor: AppTheme.darkSurface.withOpacity(0.5),
                    child: GlassCard(
                      child: Container(
                        height: 120.h,
                        decoration: BoxDecoration(
                          color: AppTheme.darkSurface,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                  );
                }, childCount: 6),
              ),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 60.sp, color: AppTheme.errorColor),
                    SizedBox(height: 16.h),
                    Text(
                      'Error loading exercises',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    PrimaryButton(
                      text: 'Retry',
                      onPressed: () {
                        ref.invalidate(exercisesProvider);
                      },
                      width: 150.w,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        ],
      ),
      floatingActionButton: filteredExercises.when(
        data: (exercises) {
          if (exercises.isEmpty) return null;

          return FloatingActionButton.extended(
            onPressed: () {
              // Take first 5 exercises (or all if less than 5)
              final workoutExercises = exercises.take(5).toList();
              context.push(
                RouteConstants.workoutSession,
                extra: workoutExercises,
              );
            },
            backgroundColor: AppTheme.neonGreen,
            icon: const Icon(Icons.play_arrow, color: Colors.black),
            label: Text(
              'Start Workout',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          );
        },
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }
}
