import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/data.dart';

@singleton
@injectable
class GithubService {
  GithubService(
    Dio dio,
    this._serviceConfig,
    this._asyncCacheHandler,
  ) : _dio = dio
        ..options = dio.options.copyWith(
          baseUrl: _serviceConfig.baseUrl,
        );

  final Dio _dio;
  final GithubServiceConfig _serviceConfig;
  final AsyncCacheHandler _asyncCacheHandler;

  Future<Map<String, dynamic>> fetchLatestRelease() async =>
      _asyncCacheHandler.handle(
        key: 'GithubService.fetchLatestRelease',
        action: () async {
          final response = await _dio.get(_serviceConfig.latestReleasePath());

          return response.data as Map<String, dynamic>;
        },
      );
}
