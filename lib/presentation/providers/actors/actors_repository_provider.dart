import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actors_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Este repositorio es Inmutable -> SOlO LECTURA

final actorsRepositoryProvider = Provider((ref) {
  return ActorsRepositoryImpl(datasource: ActorMoviedbDatasource());
});
