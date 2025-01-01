import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* 
  {
    '443003': Movie(),
    '443004': Movie(),
    '443005': Movie(),
  }
*/

final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final getMovieById = ref.watch(moviesRepositoryProvider).getMovieById;

  return MovieMapNotifier(getMovie: getMovieById);
});

typedef GetMovieCallback = Future<Movie> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;

  MovieMapNotifier({
    required this.getMovie,
  }) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;
    final movie = await getMovie(movieId);
    state = {...state, movieId: movie};
  }
}
