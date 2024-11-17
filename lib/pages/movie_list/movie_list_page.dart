import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie/data/models/movie.dart';
import 'package:movie/pages/movie_list/movie_list_controller.dart';
import 'package:movie/pages/movie_list/movie_search_delegate.dart';
import 'package:movie/pages/movie_list/widgets/movie_item_widget.dart';
import 'package:movie/service_locator.dart';
import 'package:movie/widgets/progress_indicator_widget.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final controller = getIt<MovieListController>();

  @override
  void initState() {
    controller.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: MovieSearchDelegate());
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: PagedListView<int, Movie>(
        pagingController: controller.pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, movie, index) => MovieItemWidget(movie: movie),
          firstPageProgressIndicatorBuilder: (_) => const ProgressIndicatorWidget(),
          newPageProgressIndicatorBuilder: (_) => const ProgressIndicatorWidget(),
        ),
      ),
    );
  }
}