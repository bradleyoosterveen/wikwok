import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/shared.dart';

@singleton
@injectable
class WikipediaService {
  WikipediaService(
    Dio dio,
  ) : _dio = dio
          ..options = dio.options.copyWith(
            baseUrl: 'https://en.wikipedia.org/api/rest_v1/',
          );

  final Dio _dio;

  final _asyncCache = AsyncCache();

  Future<Map<String, dynamic>> fetchRandomArticle() async {
    try {
      final response = await _dio.get('page/random/summary');

      return response.data as Map<String, dynamic>;
    } on Exception catch (e) {
      WExceptionHandler().handleException(e);

      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchArticleByTitle(String title) async =>
      _asyncCache.handle(
          key: title,
          action: () async {
            try {
              final response = await _dio.get('page/summary/$title');

              return response.data as Map<String, dynamic>;
            } on Exception catch (e) {
              WExceptionHandler().handleException(e);

              rethrow;
            }
          });
}
