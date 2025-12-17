import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import '../core/constants/app_constants.dart';
import '../models/exercise_model.dart';

class FavoritesService {
  late Box<String> _favoritesBox;
  final _logger = Logger();

  // Initialize Hive box
  Future<void> init() async {
    _favoritesBox = await Hive.openBox<String>(AppConstants.favoritesBoxName);
    _logger.i('Favorites box initialized');
  }

  // Add exercise to favorites
  Future<void> addFavorite(ExerciseModel exercise) async {
    try {
      await _favoritesBox.put(exercise.id, exercise.id);
      _logger.i('Added exercise to favorites: ${exercise.name}');
    } catch (e) {
      _logger.e('Error adding favorite: $e');
      throw 'Failed to add favorite';
    }
  }

  // Remove exercise from favorites
  Future<void> removeFavorite(String exerciseId) async {
    try {
      await _favoritesBox.delete(exerciseId);
      _logger.i('Removed exercise from favorites: $exerciseId');
    } catch (e) {
      _logger.e('Error removing favorite: $e');
      throw 'Failed to remove favorite';
    }
  }

  // Check if exercise is favorite
  bool isFavorite(String exerciseId) {
    return _favoritesBox.containsKey(exerciseId);
  }

  // Get all favorite exercise IDs
  List<String> getAllFavorites() {
    return _favoritesBox.values.toList();
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      await _favoritesBox.clear();
      _logger.i('Cleared all favorites');
    } catch (e) {
      _logger.e('Error clearing favorites: $e');
      throw 'Failed to clear favorites';
    }
  }

  // Get favorites count
  int get favoritesCount => _favoritesBox.length;
}
