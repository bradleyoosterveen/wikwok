import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/shared.dart';

@singleton
@injectable
class GithubService {
  GithubService(
    Dio dio,
  ) : _dio = dio
          ..options = dio.options.copyWith(
            baseUrl: 'https://api.github.com/',
          );

  final Dio _dio;

  final _asyncCache = AsyncCache();

  Future<Map<String, dynamic>> fetchLatestRelease() async => _asyncCache.handle(
      key: 'GithubService.fetchLatestRelease',
      action: () async {
        try {
          final response = await _dio.get(
            'repos/bradleyoosterveen/wikwok/releases/latest',
          );

          return response.data as Map<String, dynamic>;
        } on Exception catch (e) {
          WExceptionHandler().handleException(e);

          rethrow;
        }
      });
}
