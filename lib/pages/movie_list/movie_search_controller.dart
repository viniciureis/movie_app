import 'package:movie/data/models/movie.dart';
import 'package:movie/data/movie_api.dart';
import 'package:movie/service_locator.dart';

class MovieSearchController {
  final api = getIt<MovieApi>();
  
  Future<List<Movie>> searchMovie(String query) => api.searchMovie(query);
}