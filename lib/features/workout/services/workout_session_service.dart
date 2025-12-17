import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import '../models/workout_session_model.dart';
import '../models/workout_exercise_model.dart';
import '../../../models/exercise_model.dart';

class WorkoutSessionService {
  static const String _boxName = 'workout_sessions';
  final _logger = Logger();

  // Get Hive box
  Future<Box<WorkoutSessionModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<WorkoutSessionModel>(_boxName);
    }
    return Hive.box<WorkoutSessionModel>(_boxName);
  }

  // Create a new workout session from exercises
  Future<WorkoutSessionModel> createSession(
    List<ExerciseModel> exercises,
  ) async {
    try {
      final session = WorkoutSessionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        exercises: exercises
            .map((e) => WorkoutExerciseModel.fromExercise(e))
            .toList(),
      );

      await saveSession(session);
      _logger.i('Workout session created: ${session.id}');
      return session;
    } catch (e) {
      _logger.e('Error creating workout session: $e');
      rethrow;
    }
  }

  // Save workout session
  Future<void> saveSession(WorkoutSessionModel session) async {
    try {
      final box = await _getBox();
      await box.put(session.id, session);
      _logger.i('Workout session saved: ${session.id}');
    } catch (e) {
      _logger.e('Error saving workout session: $e');
      rethrow;
    }
  }

  // Get today's workout session
  Future<WorkoutSessionModel?> getTodaySession() async {
    try {
      final box = await _getBox();
      final today = DateTime.now();

      // Find session from today
      for (var session in box.values) {
        if (session.date.year == today.year &&
            session.date.month == today.month &&
            session.date.day == today.day &&
            !session.isCompleted) {
          return session;
        }
      }
      return null;
    } catch (e) {
      _logger.e('Error getting today session: $e');
      return null;
    }
  }

  // Get session by ID
  Future<WorkoutSessionModel?> getSession(String id) async {
    try {
      final box = await _getBox();
      return box.get(id);
    } catch (e) {
      _logger.e('Error getting session: $e');
      return null;
    }
  }

  // Update session
  Future<void> updateSession(WorkoutSessionModel session) async {
    try {
      final box = await _getBox();
      await box.put(session.id, session);
      _logger.i('Session updated: ${session.id}');
    } catch (e) {
      _logger.e('Error updating session: $e');
      rethrow;
    }
  }

  // Complete a workout session
  Future<void> completeSession(String sessionId, int xpEarned) async {
    try {
      final box = await _getBox();
      final session = box.get(sessionId);

      if (session != null) {
        final completedSession = session.copyWith(
          isCompleted: true,
          xpEarned: xpEarned,
        );
        await box.put(sessionId, completedSession);
        _logger.i('Session completed: $sessionId, XP earned: $xpEarned');
      }
    } catch (e) {
      _logger.e('Error completing session: $e');
      rethrow;
    }
  }

  // Get all sessions
  Future<List<WorkoutSessionModel>> getAllSessions() async {
    try {
      final box = await _getBox();
      return box.values.toList();
    } catch (e) {
      _logger.e('Error getting all sessions: $e');
      return [];
    }
  }

  // Get completed sessions
  Future<List<WorkoutSessionModel>> getCompletedSessions() async {
    try {
      final box = await _getBox();
      return box.values.where((s) => s.isCompleted).toList();
    } catch (e) {
      _logger.e('Error getting completed sessions: $e');
      return [];
    }
  }

  // Delete session
  Future<void> deleteSession(String id) async {
    try {
      final box = await _getBox();
      await box.delete(id);
      _logger.i('Session deleted: $id');
    } catch (e) {
      _logger.e('Error deleting session: $e');
      rethrow;
    }
  }

  // Clear all completed sessions (cleanup)
  Future<void> clearCompletedSessions() async {
    try {
      final box = await _getBox();
      final toDelete = box.values
          .where((s) => s.isCompleted)
          .map((s) => s.id)
          .toList();

      for (var id in toDelete) {
        await box.delete(id);
      }
      _logger.i('Cleared ${toDelete.length} completed sessions');
    } catch (e) {
      _logger.e('Error clearing completed sessions: $e');
      rethrow;
    }
  }
}
