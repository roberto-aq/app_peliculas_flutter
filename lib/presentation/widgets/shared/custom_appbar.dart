import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Icon(Icons.movie_outlined, color: colors.primary),
                const SizedBox(width: 5),
                Text(
                  'Cinemapedia',
                  style: titleStyle,
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      // final searchMovies =
                      //     ref.read(moviesRepositoryProvider).searchMovies;
                      final searchMovies = ref
                          .read(searchedMoviesProvider.notifier)
                          .searchMoviesByQuery;
                      final searchQuery = ref.read(searchQueryProvider);
                      final searchedMovies = ref.read(searchedMoviesProvider);

                      showSearch<Movie?>(
                          query: searchQuery,
                          context: context,
                          delegate: SearchMovieDelegate(
                              initialMovies: searchedMovies,
                              searchMovies: (query) {
                                return searchMovies(query);
                              })).then((movie) {
                        if (movie == null || !context.mounted) return;

                        context.push('/movie/${movie.id}');
                      });
                    },
                    icon: Icon(Icons.search_outlined))
              ],
            ),
          )),
    );
  }
}
