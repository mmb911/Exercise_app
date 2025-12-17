import 'package:hive/hive.dart';
import '../../../models/exercise_model.dart';

part 'workout_exercise_model.g.dart';

@HiveType(typeId: 3)
class WorkoutExerciseModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String target;

  @HiveField(3)
  final String equipment;

  @HiveField(4)
  final String gifUrl;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final DateTime? completedAt;

  WorkoutExerciseModel({
    required this.id,
    required this.name,
    required this.target,
    required this.equipment,
    required this.gifUrl,
    this.isCompleted = false,
    this.completedAt,
  });

  // Create from ExerciseModel
  factory WorkoutExerciseModel.fromExercise(ExerciseModel exercise) {
    return WorkoutExerciseModel(
      id: exercise.id,
      name: exercise.name,
      target: exercise.target,
      equipment: exercise.equipment,
      gifUrl: exercise.gifUrl,
      isCompleted: false,
    );
  }

  // Toggle completion status
  WorkoutExerciseModel toggleCompletion() {
    return WorkoutExerciseModel(
      id: id,
      name: name,
      target: target,
      equipment: equipment,
      gifUrl: gifUrl,
      isCompleted: !isCompleted,
      completedAt: !isCompleted ? DateTime.now() : null,
    );
  }

  // Copy with method
  WorkoutExerciseModel copyWith({
    String? id,
    String? name,
    String? target,
    String? equipment,
    String? gifUrl,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return WorkoutExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      target: target ?? this.target,
      equipment: equipment ?? this.equipment,
      gifUrl: gifUrl ?? this.gifUrl,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'target': target,
      'equipment': equipment,
      'gifUrl': gifUrl,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  // Create from JSON
  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseModel(
      id: json['id'],
      name: json['name'],
      target: json['target'],
      equipment: json['equipment'],
      gifUrl: json['gifUrl'],
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }
}
