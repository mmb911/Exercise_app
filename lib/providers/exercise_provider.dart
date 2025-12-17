import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/exercise_api_service.dart';
import '../models/exercise_model.dart';

// Exercise API Service Provider
final exerciseApiServiceProvider = Provider<ExerciseApiService>((ref) {
  return ExerciseApiService();
});

// Exercises List Provider
final exercisesProvider = FutureProvider<List<ExerciseModel>>((ref) async {
  final apiService = ref.watch(exerciseApiServiceProvider);
  return await apiService.getAllExercises(limit: 100);
});

// Search Query State Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filter State Providers
final selectedBodyPartProvider = StateProvider<String?>((ref) => null);
final selectedEquipmentProvider = StateProvider<String?>((ref) => null);
final selectedTargetProvider = StateProvider<String?>((ref) => null);

// Filtered Exercises Provider
final filteredExercisesProvider = Provider<AsyncValue<List<ExerciseModel>>>((
  ref,
) {
  final exercisesAsync = ref.watch(exercisesProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final selectedBodyPart = ref.watch(selectedBodyPartProvider);
  final selectedEquipment = ref.watch(selectedEquipmentProvider);
  final selectedTarget = ref.watch(selectedTargetProvider);

  return exercisesAsync.whenData((exercises) {
    var filtered = exercises;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((exercise) {
        return exercise.name.toLowerCase().contains(searchQuery) ||
            exercise.target.toLowerCase().contains(searchQuery) ||
            exercise.bodyPart.toLowerCase().contains(searchQuery);
      }).toList();
    }

    // Apply body part filter
    if (selectedBodyPart != null && selectedBodyPart.isNotEmpty) {
      filtered = filtered.where((exercise) {
        return exercise.bodyPart.toLowerCase() ==
            selectedBodyPart.toLowerCase();
      }).toList();
    }

    // Apply equipment filter
    if (selectedEquipment != null && selectedEquipment.isNotEmpty) {
      filtered = filtered.where((exercise) {
        return exercise.equipment.toLowerCase() ==
            selectedEquipment.toLowerCase();
      }).toList();
    }

    // Apply target muscle filter
    if (selectedTarget != null && selectedTarget.isNotEmpty) {
      filtered = filtered.where((exercise) {
        return exercise.target.toLowerCase() == selectedTarget.toLowerCase();
      }).toList();
    }

    return filtered;
  });
});

// Body Parts List from exercises
final bodyPartsProvider = Provider<List<String>>((ref) {
  final exercisesAsync = ref.watch(exercisesProvider);
  return exercisesAsync.when(
    data: (exercises) {
      final bodyParts = exercises.map((e) => e.bodyPart).toSet().toList();
      bodyParts.sort();
      return bodyParts;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Equipment List from exercises
final equipmentListProvider = Provider<List<String>>((ref) {
  final exercisesAsync = ref.watch(exercisesProvider);
  return exercisesAsync.when(
    data: (exercises) {
      final equipment = exercises.map((e) => e.equipment).toSet().toList();
      equipment.sort();
      return equipment;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Target Muscles List from exercises
final targetMusclesProvider = Provider<List<String>>((ref) {
  final exercisesAsync = ref.watch(exercisesProvider);
  return exercisesAsync.when(
    data: (exercises) {
      final targets = exercises.map((e) => e.target).toSet().toList();
      targets.sort();
      return targets;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
