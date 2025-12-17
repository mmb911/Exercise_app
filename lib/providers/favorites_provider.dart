import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/favorites_service.dart';
import '../models/exercise_model.dart';

// Favorites Service Provider
final favoritesServiceProvider = Provider<FavoritesService>((ref) {
  return FavoritesService();
});

// Favorites IDs List Provider
final favoritesIdsProvider = StateProvider<List<String>>((ref) {
  final favoritesService = ref.watch(favoritesServiceProvider);
  return favoritesService.getAllFavorites();
});

// Check if Exercise is Favorite
final isFavoriteProvider = Provider.family<bool, String>((ref, exerciseId) {
  final favoritesIds = ref.watch(favoritesIdsProvider);
  return favoritesIds.contains(exerciseId);
});

// Toggle Favorite State Notifier
class FavoriteNotifier extends StateNotifier<bool> {
  final Ref ref;
  final String exerciseId;

  FavoriteNotifier(this.ref, this.exerciseId) : super(false) {
    _init();
  }

  void _init() {
    final favoritesService = ref.read(favoritesServiceProvider);
    state = favoritesService.isFavorite(exerciseId);
  }

  Future<void> toggle(ExerciseModel exercise) async {
    final favoritesService = ref.read(favoritesServiceProvider);

    if (state) {
      await favoritesService.removeFavorite(exerciseId);
      state = false;
    } else {
      await favoritesService.addFavorite(exercise);
      state = true;
    }

    // Update the favorites list
    ref.read(favoritesIdsProvider.notifier).state = favoritesService
        .getAllFavorites();
  }
}

// Favorite Toggle Provider
final favoriteToggleProvider =
    StateNotifierProvider.family<FavoriteNotifier, bool, String>(
      (ref, exerciseId) => FavoriteNotifier(ref, exerciseId),
    );
