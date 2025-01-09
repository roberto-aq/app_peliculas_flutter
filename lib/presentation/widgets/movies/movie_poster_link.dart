import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class MoviePosterLink extends StatelessWidget {
  final Movie movie;

  const MoviePosterLink({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () => context.push('/movie/${movie.id}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(movie.posterPath),
        ),
      ),
    );
  }
}
