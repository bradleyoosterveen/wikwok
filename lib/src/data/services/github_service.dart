import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wikwok/core.dart';

@singleton
@injectable
class GithubService {
  GithubService(Dio dio, this._asyncCacheHandler)
    : _dio = dio
        ..options = dio.options.copyWith(baseUrl: 'https://api.github.com/');

  final Dio _dio;
  final AsyncCacheHandler _asyncCacheHandler;

  Future<Map<String, dynamic>> fetchLatestRelease() async =>
      _asyncCacheHandler.handle(
        key: 'GithubService.fetchLatestRelease',
        action: () async {
          final response = await _dio.get(
            'repos/bradleyoosterveen/wikwok/releases/latest',
          );

          return response.data as Map<String, dynamic>;
        },
      );
}
