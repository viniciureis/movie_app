import 'dart:async';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie/data/models/movie.dart';
import 'package:movie/data/movie_api.dart';
import 'package:movie/service_locator.dart';

class MovieListController {
  final api = getIt<MovieApi>();

  final int _pageSize = 20;
  final PagingController<int, Movie> pagingController = PagingController(firstPageKey: 0);

  void init() {
    pagingController.addPageRequestListener((pageKey) => _getMovies(pageKey));
  }

  Future<void> _getMovies(int pageKey) async {
    try {
      var newItems = await api.getMovies(skip: pageKey, take: _pageSize);
      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }
}