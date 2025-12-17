import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/exercise_provider.dart';
import '../../../providers/favorites_provider.dart';
import '../../exercises/widgets/exercise_card.dart';
import '../../../core/router/route_constants.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesIds = ref.watch(favoritesIdsProvider);
    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: exercisesAsync.when(
        data: (allExercises) {
          final favoriteExercises = allExercises
              .where((exercise) => favoritesIds.contains(exercise.id))
              .toList();

          if (favoriteExercises.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No favorites yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start adding exercises to your favorites!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: favoriteExercises.length,
            itemBuilder: (context, index) {
              final exercise = favoriteExercises[index];
              return ExerciseCard(
                exercise: exercise,
                onTap: () {
                  context.go(
                    RouteConstants.exerciseDetailRoute(exercise.id),
                    extra: exercise,
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }
}
