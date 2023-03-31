import 'package:flutter/material.dart';

class MoviesCards extends StatelessWidget {
  final String title;
  final String overview;
  final String posterPath;

  const MoviesCards({
    Key? key,
    required this.title,
    required this.overview,
    required this.posterPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: NetworkImage(posterPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
