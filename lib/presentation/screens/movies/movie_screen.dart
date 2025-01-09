import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static String name = 'movie';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return Scaffold(
        body: const Center(
            child: CircularProgressIndicator(
          color: Colors.indigoAccent,
          strokeWidth: 3,
        )),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movie),
            childCount: 1,
          ))
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    movie.posterPath,
                    height: size.height * 0.2,
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: size.width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        movie.overview,
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      )
                    ],
                  ),
                )
              ],
            )),

        // Generos de la pelicula
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              children: [
                ...movie.genreIds.map((gender) => Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Chip(
                        backgroundColor: colors.primary,
                        label: Text(
                          gender,
                          style: TextStyle(color: colors.surface),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ))
              ],
            )),

        // Actores de la pelicula
        _ActorsByMovie(
          movieId: movie.id.toString(),
        ),

        const SizedBox(height: 50),
      ],
    );
  }
}

final isFavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            await ref
                .read(favoriteMoviesProvider.notifier)
                .toggleFavorite(movie);

            ref.invalidate(isFavoriteProvider(movie.id));
          },
          icon: isFavoriteFuture.when(
              data: (isFavorite) => isFavorite
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(Icons.favorite_border),
              error: (_, __) => throw UnimplementedError(),
              loading: () => const Icon(Icons.favorite_border)),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        // titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(fontSize: 32, color: Colors.white),
        //   textAlign: TextAlign.start,
        // ),
        background: Stack(
          children: [
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.0, 0.3],
                    colors: [Colors.black45, Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actorsByMovie = ref.watch(actorByMovieProvider);

    if (actorsByMovie[movieId] == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.indigoAccent,
          strokeWidth: 3,
        ),
      );
    }

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actorsByMovie[movieId]![index];

          return Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 5, 10),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    actor.profilePath,
                    height: 140,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  actor.name,
                  maxLines: 2,
                ),
                Text(
                  actor.character ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
