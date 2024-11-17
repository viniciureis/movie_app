import 'dart:async';

import 'package:movie/data/models/movie.dart';
import 'package:movie/data/movie_api.dart';
import 'package:movie/service_locator.dart';

class MovieDetailController {
  final api = getIt<MovieApi>();

  final _controller = StreamController<Movie>();
  Stream<Movie> get stream => _controller.stream;
  late Movie _movie;

  void init(Movie movie) {
    _movie = movie;

    getMovie();
  }

  Future<void> getMovie() async {
    var result = await api.getMovie(_movie.id);

    _controller.sink.add(result);
  }

  Future<void> deleteComment(int id) async {
    await api.deleteComment(_movie.id, id);

    getMovie();
  }

  Future<void> postComment(String comment) async {
    await api.postComment(_movie.id, comment);

    getMovie();
  }
}