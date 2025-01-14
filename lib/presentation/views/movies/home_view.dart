import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);

    if (initialLoading) return const FullScreenLoader();

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideshowMovies = ref.watch(moviesSlideShowProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    if (slideshowMovies.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.all(0),
            title: CustomAppbar(),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          childCount: 1,
          (context, index) {
            return Column(
              children: [
                MoviesSlideshow(
                  movies: slideshowMovies,
                ),
                MovieHorizontalListview(
                  label: 'En cines',
                  subtitle: 'Lunes 30',
                  movies: nowPlayingMovies,
                  loadNextPage: () {
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  },
                ),
                MovieHorizontalListview(
                  label: 'Proximamente',
                  subtitle: 'En este mes',
                  movies: upcomingMovies,
                  loadNextPage: () {
                    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
                  },
                ),
                MovieHorizontalListview(
                  label: 'Populares',
                  // subtitle: 'En este mes',
                  movies: popularMovies,
                  loadNextPage: () {
                    ref.read(popularMoviesProvider.notifier).loadNextPage();
                  },
                ),
                MovieHorizontalListview(
                  label: 'Mejor Calificadas',
                  subtitle: 'Desde Siempre',
                  movies: topRatedMovies,
                  loadNextPage: () {
                    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                  },
                ),
                const SizedBox(height: 40),
              ],
            );
          },
        ))
      ],
    );
  }
}
