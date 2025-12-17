import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class XPService {
  static const String _xpKey = 'user_total_xp';
  static const int _baseXPPerExercise = 20;
  static const int _completionBonus = 10;

  final _logger = Logger();

  // Get total XP
  Future<int> getTotalXP() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_xpKey) ?? 0;
    } catch (e) {
      _logger.e('Error getting total XP: $e');
      return 0;
    }
  }

  // Add XP to user's total
  Future<void> addXP(int amount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentXP = await getTotalXP();
      final newTotal = currentXP + amount;
      await prefs.setInt(_xpKey, newTotal);
      _logger.i('XP added: $amount, New total: $newTotal');
    } catch (e) {
      _logger.e('Error adding XP: $e');
      rethrow;
    }
  }

  // Calculate XP for a workout based on exercises completed
  int calculateWorkoutXP(int exercisesCompleted, {bool allCompleted = false}) {
    int totalXP = exercisesCompleted * _baseXPPerExercise;

    // Add bonus if all exercises were completed
    if (allCompleted && exercisesCompleted > 0) {
      totalXP += _completionBonus;
    }

    return totalXP;
  }

  // Reset XP (for testing or user request)
  Future<void> resetXP() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_xpKey);
      _logger.i('XP reset to 0');
    } catch (e) {
      _logger.e('Error resetting XP: $e');
      rethrow;
    }
  }

  // Get current level based on XP (optional gamification bonus)
  int calculateLevel(int totalXP) {
    // Simple formula: level = sqrt(XP / 100)
    // Level 1 = 0 XP, Level 2 = 100 XP, Level 3 = 400 XP, etc.
    if (totalXP < 100) return 1;
    return (totalXP / 100).sqrt().floor() + 1;
  }

  // Get XP needed for next level
  int getXPForNextLevel(int currentLevel) {
    return (currentLevel * currentLevel) * 100;
  }

  // Get progress to next level (0.0 to 1.0)
  double getLevelProgress(int totalXP, int currentLevel) {
    final currentLevelXP = ((currentLevel - 1) * (currentLevel - 1)) * 100;
    final nextLevelXP = getXPForNextLevel(currentLevel);
    final xpInCurrentLevel = totalXP - currentLevelXP;
    final xpNeededForLevel = nextLevelXP - currentLevelXP;

    if (xpNeededForLevel == 0) return 1.0;
    return (xpInCurrentLevel / xpNeededForLevel).clamp(0.0, 1.0);
  }
}

// Extension for sqrt on ints
extension _IntSqrt on int {
  int sqrt() => (this as num).sqrt().toInt();
}

extension on num {
  num sqrt() => this < 0 ? 0 : (this as double).abs().sqrt();
}
