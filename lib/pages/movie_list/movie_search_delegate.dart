import 'package:flutter/material.dart';
import 'package:movie/data/models/movie.dart';
import 'package:movie/pages/movie_list/movie_search_controller.dart';
import 'package:movie/pages/movie_list/widgets/movie_item_widget.dart';
import 'package:movie/widgets/progress_indicator_widget.dart';

class MovieSearchDelegate extends SearchDelegate {
  final controller = MovieSearchController();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return buildSuggestions(context);
    }

    if (query.length < 3) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Text('A consulta: "$query" é curta. O mínimo de caracteres é 3.'),
      );
    }

    return FutureBuilder(
      future: controller.searchMovie(query),
      builder:(context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ProgressIndicatorWidget();
        }

        List<Movie> movies = snapshot.data!;

        if (movies.isEmpty) {
          return const Center(
            child: Text('Nenhum filme foi encontrado para a sua consulta.'),
          );
        }

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => MovieItemWidget(movie: movies[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink();
  }
}