import 'package:dio/dio.dart';
import 'package:movie/data/exception_handlers.dart';
import 'package:movie/data/models/movie.dart';

class MovieApi {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://apifilmes.webevolui.com')
  );

  MovieApi() {
    _dio.interceptors.add(AppInterceptors());
  }

  Future<List<Movie>> getMovies({int skip=0, int take=20}) async {
    var response = await _dio.get('/Filme?skip=$skip&take=$take');

    return (response.data as List)
        .map((item) => Movie.fromJson(item))
        .toList();
  }

  Future<List<Movie>> searchMovie(String query) async {
    var response = await _dio.get('/Filme?q=$query');

    return (response.data as List)
        .map((item) => Movie.fromJson(item))
        .toList();
  }

  Future<Movie> getMovie(int id) async {
    var response = await _dio.get('/Filme/$id');

    return Movie.fromJson(response.data);
  }

  Future<void> deleteComment(int movieId, int id) async {
    await _dio.delete('/Filme/$movieId/Comentario/$id');
  }

  Future<void> postComment(int movieId, String comment) async {
    await _dio.post(
      '/Filme/$movieId/Comentario',
      data: {
        'comment': comment,
      }
    );
  }
}

class AppInterceptors extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions, err.response);
          case 500:
            throw InternalServerErrorException(err.requestOptions);
        }
        break;
      default:
    }

    return handler.next(err);
  }
}