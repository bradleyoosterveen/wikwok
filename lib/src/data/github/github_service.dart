import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/data.dart';

@singleton
@injectable
class GithubService {
  GithubService(
    Dio dio,
    this._serviceConfig,
    this._asyncCacheHandler,
    this._logger,
  ) : _dio = dio
        ..options = dio.options.copyWith(
          baseUrl: _serviceConfig.baseUrl,
        );

  final Dio _dio;
  final GithubServiceConfig _serviceConfig;
  final AsyncCacheHandler _asyncCacheHandler;
  final Logger _logger;

  static _fetchLatestReleaseKey() => 'GithubService.fetchLatestRelease';
  TaskEither<GithubServiceError, Map<String, dynamic>> fetchLatestRelease() =>
      TaskEither.tryCatch(
        () async => _asyncCacheHandler.run(
          key: _fetchLatestReleaseKey(),
          duration: const Duration(days: 1),
          action: () async {
            final response = await _dio.get(_serviceConfig.latestReleasePath());

            return response.data as Map<String, dynamic>;
          },
        ),
        (e, __) => _toError(e),
      ).tapLeft((error) {
        _asyncCacheHandler.invalidate(_fetchLatestReleaseKey());
        _logger.e(error);
      });
}

enum GithubServiceError {
  unknown,
  serverError,
  clientError,
  connectionError,
  timeout,
}

GithubServiceError _toError(dynamic e) => switch (e) {
  GithubServiceError _ => e,
  DioException dioException => switch (Never) {
    _ when dioException.isServerError => .serverError,
    _ when dioException.isClientError => .clientError,
    _ when dioException.isConnectionError => .connectionError,
    _ when dioException.isTimeoutError => .timeout,
    _ => .unknown,
  },
  _ => .unknown,
};
