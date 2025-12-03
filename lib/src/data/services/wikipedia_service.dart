import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wikwok/core.dart';

@singleton
@injectable
class WikipediaService {
  WikipediaService(Dio dio, this._asyncCacheHandler)
    : _dio = dio
        ..options = dio.options.copyWith(
          baseUrl: 'https://en.wikipedia.org/api/rest_v1/',
        );

  final Dio _dio;
  final AsyncCacheHandler _asyncCacheHandler;

  Future<Map<String, dynamic>> fetchRandomArticle() async {
    final response = await _dio.get('page/random/summary');

    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchArticleByTitle(String title) async =>
      _asyncCacheHandler.handle(
        key: title,
        action: () async {
          final response = await _dio.get('page/summary/$title');

          return response.data as Map<String, dynamic>;
        },
      );
}
