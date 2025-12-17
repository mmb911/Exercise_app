import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/presentation/widgets/core_ui.dart';
import '../../../models/exercise_model.dart';
import '../providers/workout_session_provider.dart';
import '../providers/xp_provider.dart';
import '../widgets/workout_exercise_card.dart';
import '../widgets/completion_celebration_dialog.dart';

class WorkoutSessionScreen extends ConsumerStatefulWidget {
  final List<ExerciseModel> exercises;

  const WorkoutSessionScreen({super.key, required this.exercises});

  @override
  ConsumerState<WorkoutSessionScreen> createState() =>
      _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  @override
  void initState() {
    super.initState();
    // Create session on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSession();
    });
  }

  Future<void> _initializeSession() async {
    final notifier = ref.read(workoutSessionProvider.notifier);
    final currentSession = ref.read(workoutSessionProvider).value;

    // If no session exists, create one
    if (currentSession == null) {
      await notifier.createSession(widget.exercises);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionAsync = ref.watch(workoutSessionProvider);
    final xpAsync = ref.watch(totalXPProvider);
    final confettiController = ref.watch(confettiControllerProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            slivers: [
              // App Bar with XP Badge
              SliverAppBar(
                expandedHeight: 120.h,
                floating: false,
                pinned: true,
                backgroundColor: theme.colorScheme.surface,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Daily Workout',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.headlineSmall!.color,
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
                  ),
                ),
                actions: [
                  // XP Badge
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Center(
                      child: xpAsync.when(
                        data: (xp) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.neonGreen,
                                AppTheme.electricBlue,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.black,
                                size: 16.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '$xp XP',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => const SizedBox(),
                      ),
                    ),
                  ),
                ],
              ),

              // Progress Header
              SliverToBoxAdapter(
                child: sessionAsync.when(
                  data: (session) {
                    if (session == null) {
                      return Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Center(
                          child: Text(
                            'Loading workout...',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: theme.textTheme.bodyMedium!.color,
                            ),
                          ),
                        ),
                      );
                    }

                    return _buildProgressHeader(session, theme);
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('Error: $error'),
                    ),
                  ),
                ),
              ),

              // Exercise List
              sessionAsync.when(
                data: (session) {
                  if (session == null) return const SliverToBoxAdapter();

                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final exercise = session.exercises[index];
                        return WorkoutExerciseCard(
                              exercise: exercise,
                              onToggle: () {
                                ref
                                    .read(workoutSessionProvider.notifier)
                                    .toggleExerciseStatus(exercise.id);

                                // Show celebration dialog if completed
                                if (session.exercises.every((e) {
                                  if (e.id == exercise.id)
                                    return !e.isCompleted;
                                  return e.isCompleted;
                                })) {
                                  Future.delayed(
                                    const Duration(milliseconds: 500),
                                    () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const CompletionCelebrationDialog(),
                                      );
                                    },
                                  );
                                }
                              },
                            )
                            .animate()
                            .fadeIn(delay: (100 * index).ms)
                            .slideY(begin: 0.2, end: 0);
                      }, childCount: session.exercises.length),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(),
                error: (_, __) => const SliverToBoxAdapter(),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 40.h)),
            ],
          ),

          // Confetti Overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
              colors: const [
                AppTheme.neonGreen,
                AppTheme.electricBlue,
                Colors.yellow,
                Colors.pink,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(dynamic session, ThemeData theme) {
    final percentage = session.completionPercentage;
    final completed = session.completedCount;
    final total = session.exercises.length;

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: GlassCard(
        child: Column(
          children: [
            Text(
              'Daily Progress',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge!.color,
              ),
            ),
            SizedBox(height: 20.h),
            CircularPercentIndicator(
              radius: 80.r,
              lineWidth: 12.w,
              percent: percentage,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(percentage * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    '$completed/$total',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: theme.textTheme.bodySmall!.color,
                    ),
                  ),
                ],
              ),
              progressColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surface,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 800,
            ),
            SizedBox(height: 16.h),
            Text(
              '$completed of $total Exercises Done',
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.textTheme.bodyMedium!.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale();
  }
}
