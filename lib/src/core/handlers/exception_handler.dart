import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class WExceptionHandler {
  static final WExceptionHandler _instance = WExceptionHandler._internal();

  factory WExceptionHandler() => _instance;

  WExceptionHandler._internal();

  BehaviorSubject<String> errorStream = BehaviorSubject<String>();

  void handleException(Exception e) => errorStream.add(switch (e) {
        _ when e is DioException => _onDioException(e),
        _ => _onException(e),
      });

  void handleAnything(Object e) => errorStream.add(e.toString());

  String _onException(Exception e) => 'A generic exception occurred: $e';

  String _onDioException(DioException e) {
    final url = e.requestOptions.uri.toString();

    final isTimeout = switch (e) {
      _ when e.type == DioExceptionType.connectionTimeout => true,
      _ when e.type == DioExceptionType.receiveTimeout => true,
      _ when e.type == DioExceptionType.sendTimeout => true,
      _ => false,
    };

    if (isTimeout) {
      return '$url timed out';
    }

    if (e.type == DioExceptionType.connectionError) {
      return '$url failed to connect';
    }

    return '$url returned ${e.response?.statusCode}';
  }
}
