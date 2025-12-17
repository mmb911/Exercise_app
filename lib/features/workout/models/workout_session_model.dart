import 'package:hive/hive.dart';
import 'workout_exercise_model.dart';

part 'workout_session_model.g.dart';

@HiveType(typeId: 2)
class WorkoutSessionModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final List<WorkoutExerciseModel> exercises;

  @HiveField(3)
  final int xpEarned;

  @HiveField(4)
  final bool isCompleted;

  WorkoutSessionModel({
    required this.id,
    required this.date,
    required this.exercises,
    this.xpEarned = 0,
    this.isCompleted = false,
  });

  // Calculate completion percentage
  double get completionPercentage {
    if (exercises.isEmpty) return 0.0;
    final completed = exercises.where((e) => e.isCompleted).length;
    return completed / exercises.length;
  }

  // Get number of completed exercises
  int get completedCount {
    return exercises.where((e) => e.isCompleted).length;
  }

  // Check if all exercises are completed
  bool get isFullyCompleted {
    return exercises.isNotEmpty && exercises.every((e) => e.isCompleted);
  }

  // Copy with method for state updates
  WorkoutSessionModel copyWith({
    String? id,
    DateTime? date,
    List<WorkoutExerciseModel>? exercises,
    int? xpEarned,
    bool? isCompleted,
  }) {
    return WorkoutSessionModel(
      id: id ?? this.id,
      date: date ?? this.date,
      exercises: exercises ?? this.exercises,
      xpEarned: xpEarned ?? this.xpEarned,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'xpEarned': xpEarned,
      'isCompleted': isCompleted,
    };
  }

  // Create from JSON
  factory WorkoutSessionModel.fromJson(Map<String, dynamic> json) {
    return WorkoutSessionModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      exercises: (json['exercises'] as List)
          .map((e) => WorkoutExerciseModel.fromJson(e))
          .toList(),
      xpEarned: json['xpEarned'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
