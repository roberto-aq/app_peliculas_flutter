import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_format.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;

  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate(
      {required this.initialMovies, required this.searchMovies});

  void clearStreams() {
    debouncedMovies.close();
  }

  void onQueryChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);
      initialMovies = movies;
      debouncedMovies.add(movies);
    });
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      // SpinPerfect(
      //     duration: const Duration(milliseconds: 500),
      //     infinite: true,
      //     spins: 10,
      //     child: IconButton(
      //         onPressed: () {
      //           query = '';
      //         },
      //         icon: const Icon(Icons.refresh_outlined))),
      FadeIn(
          animate: query.isNotEmpty,
          duration: const Duration(milliseconds: 150),
          child: IconButton(
              onPressed: () {
                query = '';
              },
              icon: const Icon(Icons.clear)))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
        initialData: initialMovies,
        stream: debouncedMovies.stream,
        // future: searchMovies(query),
        builder: (context, snapshot) {
          final movies = snapshot.data ?? [];

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return _MovieItem(
                movie: movie,
                onMovieSelected: (context, movie) {
                  clearStreams();
                  close(context, movie);
                },
              );
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onQueryChanged(query);

    return buildResultsAndSuggestions();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Informacion de la pelicula
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textStyles.titleMedium,
                  ),
                  movie.overview.length > 100
                      ? Text(
                          '${movie.overview.substring(0, 100)}...',
                          style: textStyles.bodyMedium,
                        )
                      : Text(
                          movie.overview,
                          style: textStyles.bodyMedium,
                        ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.star_half_outlined,
                          color: Colors.amber.shade900),
                      const SizedBox(width: 5),
                      Text(
                        HumanFormat.number(movie.voteAverage, 1),
                        style: textStyles.bodyMedium!
                            .copyWith(color: Colors.amber.shade900),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
