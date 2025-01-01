import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    name: HomeScreen.name,
    path: '/',
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    name: MovieScreen.name,
    path: '/movie/:id',
    builder: (context, state) {
      
      final movieId = state.pathParameters['id'] ?? 'no-id';

      return MovieScreen(movieId: movieId);
    },
  )
]);
