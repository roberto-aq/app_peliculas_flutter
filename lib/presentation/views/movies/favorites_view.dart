import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/widgets.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;

    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();

    if (favoriteMovies.isEmpty) {
      final colors = Theme.of(context).colorScheme;

      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                size: 100,
                color: colors.primary,
              ),
              SizedBox(height: 20),
              Text(
                'No favorite movies yet',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.primary),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: MovieMasonry(
        loadNextPage: loadNextPage,
        movies: favoriteMovies,
      ),
    );
  }
}
