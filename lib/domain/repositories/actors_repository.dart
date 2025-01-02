import 'package:cinemapedia/domain/entities/actor.dart';

abstract class ActorsRepository {
  Future<List<Actor>> getActorByMovie(String movieId);
}
