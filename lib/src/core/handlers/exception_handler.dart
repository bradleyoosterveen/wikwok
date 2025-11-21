import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@singleton
@injectable
class ExceptionHandler {
  BehaviorSubject<String> errorStream = BehaviorSubject<String>();

  void handle(Object e) => errorStream.add(switch (e) {
    _ when e is DioException => _onDioException(e),
    _ when e is Exception => _onException(e),
    _ => _onAnything(e),
  });

  String _onAnything(Object e) => e.toString();

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
