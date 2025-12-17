import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/data.dart';

enum WikipediaServiceError {
  unknown,
  serverError,
  clientError,
  connectionError,
  timeout,
}

@singleton
@injectable
class WikipediaService {
  WikipediaService(
    Dio dio,
    this._serviceConfig,
    this._asyncCacheHandler,
    this._logger,
  ) : _dio = dio
        ..options = dio.options.copyWith(
          baseUrl: _serviceConfig.baseUrl,
        );

  final Dio _dio;
  final WikipediaServiceConfig _serviceConfig;
  final AsyncCacheHandler _asyncCacheHandler;
  final Logger _logger;

  static WikipediaServiceError _toError(dynamic e) => switch (e) {
    WikipediaServiceError _ => e,
    DioException dioException => switch (Never) {
      _ when dioException.isServerError => .serverError,
      _ when dioException.isClientError => .clientError,
      _ when dioException.isConnectionError => .connectionError,
      _ when dioException.isTimeoutError => .timeout,
      _ => .unknown,
    },
    _ => .unknown,
  };

  TaskEither<WikipediaServiceError, Map<String, dynamic>>
  fetchRandomArticle() => TaskEither.tryCatch(() async {
    final response = await _dio.get(_serviceConfig.randomArticlePath());

    return response.data as Map<String, dynamic>;
  }, (e, _) => _toError(e)).tapLeft((error) => _logger.e(error));

  TaskEither<WikipediaServiceError, Map<String, dynamic>> fetchArticleByTitle(
    String title,
  ) =>
      TaskEither.tryCatch(
        () => _asyncCacheHandler.run(
          key: _serviceConfig.articleByTitlePath(title),
          duration: const Duration(days: 1),
          action: () async {
            final response = await _dio.get(
              _serviceConfig.articleByTitlePath(title),
            );

            return response.data as Map<String, dynamic>;
          },
        ),
        (e, _) => _toError(e),
      ).tapLeft((error) {
        _asyncCacheHandler.invalidate(_serviceConfig.articleByTitlePath(title));
        _logger.e(error);
      });
}
