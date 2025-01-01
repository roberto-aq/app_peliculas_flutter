import 'package:flutter/material.dart';

class MovieScreen extends StatelessWidget {
  static String name = 'movie';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie $movieId'),
      ),
    );
  }
}
