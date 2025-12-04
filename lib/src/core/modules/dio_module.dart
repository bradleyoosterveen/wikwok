import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioModule {
  Dio get dio => Dio()
    ..options = BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
    );
}

extension DioExceptionExtensions on DioException {
  /// Returns the status code, or 0 when it's not available.
  int get statusCode => response?.statusCode ?? 0;

  bool get isServerError => statusCode >= 500;
  bool get isClientError => statusCode >= 400 && statusCode < 500;
  bool get isTimeoutError =>
      type == DioExceptionType.receiveTimeout ||
      type == DioExceptionType.sendTimeout ||
      type == DioExceptionType.connectionTimeout;
  bool get isConnectionError => type == DioExceptionType.connectionError;
}
