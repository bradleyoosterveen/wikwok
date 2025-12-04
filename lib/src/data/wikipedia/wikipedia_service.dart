import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/data.dart';

@singleton
@injectable
class WikipediaService {
  WikipediaService(
    Dio dio,
    this._serviceConfig,
    this._asyncCacheHandler,
  ) : _dio = dio
        ..options = dio.options.copyWith(
          baseUrl: _serviceConfig.baseUrl,
        );

  final Dio _dio;
  final WikipediaServiceConfig _serviceConfig;
  final AsyncCacheHandler _asyncCacheHandler;

  Future<Map<String, dynamic>> fetchRandomArticle() async {
    final response = await _dio.get(_serviceConfig.randomArticlePath());

    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchArticleByTitle(String title) async =>
      _asyncCacheHandler.run(
        key: title,
        action: () async {
          final response = await _dio.get(
            _serviceConfig.articleByTitlePath(title),
          );

          return response.data as Map<String, dynamic>;
        },
      );
}
