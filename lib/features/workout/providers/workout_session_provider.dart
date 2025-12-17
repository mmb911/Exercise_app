import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../models/workout_session_model.dart';
import '../models/workout_exercise_model.dart';
import '../services/workout_session_service.dart';
import '../services/xp_service.dart';
import '../../../models/exercise_model.dart';

// Workout Session Service Provider
final workoutSessionServiceProvider = Provider<WorkoutSessionService>((ref) {
  return WorkoutSessionService();
});

// Workout Session State Notifier
class WorkoutSessionNotifier
    extends StateNotifier<AsyncValue<WorkoutSessionModel?>> {
  final WorkoutSessionService _sessionService;
  final XPService _xpService;
  final ConfettiController confettiController;

  WorkoutSessionNotifier(
    this._sessionService,
    this._xpService,
    this.confettiController,
  ) : super(const AsyncValue.loading()) {
    loadTodaySession();
  }

  // Load today's session or return null
  Future<void> loadTodaySession() async {
    state = const AsyncValue.loading();
    try {
      final session = await _sessionService.getTodaySession();
      state = AsyncValue.data(session);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Create a new session from exercises
  Future<void> createSession(List<ExerciseModel> exercises) async {
    if (exercises.isEmpty) return;

    try {
      state = const AsyncValue.loading();
      final session = await _sessionService.createSession(exercises);
      state = AsyncValue.data(session);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Toggle exercise completion status
  Future<void> toggleExerciseStatus(String exerciseId) async {
    final currentSession = state.value;
    if (currentSession == null) return;

    try {
      // Find and toggle the exercise
      final updatedExercises = currentSession.exercises.map((exercise) {
        if (exercise.id == exerciseId) {
          return exercise.toggleCompletion();
        }
        return exercise;
      }).toList();

      // Create updated session
      final updatedSession = currentSession.copyWith(
        exercises: updatedExercises,
      );

      // Save to Hive
      await _sessionService.updateSession(updatedSession);

      // Update state
      state = AsyncValue.data(updatedSession);

      // Check if workout is complete
      if (updatedSession.isFullyCompleted && !currentSession.isCompleted) {
        await _finishWorkout(updatedSession);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Finish workout (private)
  Future<void> _finishWorkout(WorkoutSessionModel session) async {
    try {
      // Calculate XP
      final exercisesCompleted = session.exercises.length;
      final xpEarned = _xpService.calculateWorkoutXP(
        exercisesCompleted,
        allCompleted: true,
      );

      // Add XP to user's total
      await _xpService.addXP(xpEarned);

      // Mark session as completed
      await _sessionService.completeSession(session.id, xpEarned);

      // Update state with completed session
      final completedSession = session.copyWith(
        isCompleted: true,
        xpEarned: xpEarned,
      );
      state = AsyncValue.data(completedSession);

      // Trigger confetti celebration
      confettiController.play();

      // Auto-stop confetti after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        confettiController.stop();
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Manually finish workout (for testing or manual completion)
  Future<void> finishWorkout() async {
    final currentSession = state.value;
    if (currentSession == null || currentSession.isCompleted) return;

    await _finishWorkout(currentSession);
  }

  // Reset session (clear today's session)
  Future<void> resetSession() async {
    final currentSession = state.value;
    if (currentSession != null) {
      await _sessionService.deleteSession(currentSession.id);
    }
    state = const AsyncValue.data(null);
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }
}

// Workout Session Provider
final workoutSessionProvider =
    StateNotifierProvider.autoDispose<
      WorkoutSessionNotifier,
      AsyncValue<WorkoutSessionModel?>
    >((ref) {
      final sessionService = ref.watch(workoutSessionServiceProvider);
      final xpService = ref.watch(xpServiceProvider);

      // Create confetti controller
      final confettiController = ConfettiController(
        duration: const Duration(seconds: 3),
      );

      final notifier = WorkoutSessionNotifier(
        sessionService,
        xpService,
        confettiController,
      );

      // Dispose controller when provider is disposed
      ref.onDispose(() {
        confettiController.dispose();
      });

      return notifier;
    });

// Confetti Controller Provider (for accessing in UI)
final confettiControllerProvider = Provider.autoDispose<ConfettiController>((
  ref,
) {
  final notifier = ref.watch(workoutSessionProvider.notifier);
  return notifier.confettiController;
});

// XP Service Provider (re-export for convenience)
final xpServiceProvider = Provider<XPService>((ref) {
  return XPService();
});
