// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikwok/core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('DioExceptionExtension', () {
    group('statusCode', () {
      test('should return 0 when response is null', () {
        final exception = DioException(
          requestOptions: RequestOptions(path: ''),
        );

        expect(
          exception.statusCode,
          0,
          reason: 'status code should be 0, but is ${exception.statusCode}',
        );
      });
      test('should return the response status code when available', () {
        for (var i = 1; i < 600; i++) {
          final exception = DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: i,
            ),
          );

          expect(
            exception.statusCode,
            i,
            reason: 'status code should be $i, but is ${exception.statusCode}',
          );
        }
      });
    });
    group('isServerError', () {
      test('should return true when status code is 500 or higher', () {
        for (var i = 500; i < 600; i++) {
          final exception = DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: i,
            ),
          );

          expect(
            exception.isServerError,
            true,
            reason:
                'isServerError should be true, but is not for status code ${exception.statusCode}',
          );
        }
      });
      test('should return false when status code is lower than 500', () {
        for (var i = 100; i < 500; i++) {
          final exception = DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: i,
            ),
          );

          expect(
            exception.isServerError,
            false,
            reason:
                'isServerError should be false, but is not for status code ${exception.statusCode}',
          );
        }
      });
    });
    group('isClientError', () {
      test(
        'should return true when status code is 400 or higher and lower than 500',
        () {
          for (var i = 400; i < 500; i++) {
            final exception = DioException(
              requestOptions: RequestOptions(path: ''),
              response: Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: i,
              ),
            );

            expect(
              exception.isClientError,
              true,
              reason:
                  'isClientError should be true, but is not for status code ${exception.statusCode}',
            );
          }
        },
      );
      test(
        'should return false when status code is lower than 400 or higher than 499',
        () {
          for (var i = 100; i < 400; i++) {
            final exception = DioException(
              requestOptions: RequestOptions(path: ''),
              response: Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: i,
              ),
            );

            expect(
              exception.isClientError,
              false,
              reason:
                  'isClientError should be false, but is not for status code ${exception.statusCode}',
            );
          }
          for (var i = 500; i < 600; i++) {
            final exception = DioException(
              requestOptions: RequestOptions(path: ''),
              response: Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: i,
              ),
            );

            expect(
              exception.isClientError,
              false,
              reason:
                  'isClientError should be false, but is not for status code ${exception.statusCode}',
            );
          }
        },
      );
    });
    group('isTimeoutError', () {
      test(
        'should return true when type is receiveTimeout, sendTimeout, or connectionTimeout',

        () {
          for (var type in <DioExceptionType>[
            .receiveTimeout,
            .sendTimeout,
            .connectionTimeout,
          ]) {
            final exception = DioException(
              requestOptions: RequestOptions(path: ''),
              type: type,
            );

            expect(
              exception.isTimeoutError,
              true,
              reason:
                  'isTimeoutError should be true, but is not for type $type',
            );
          }
        },
      );
      test(
        'should return false when type is not receiveTimeout, sendTimeout, or connectionTimeout',

        () {
          for (var type in <DioExceptionType>[
            .badCertificate,
            .badResponse,
            .cancel,
            .connectionError,
            .unknown,
          ]) {
            final exception = DioException(
              requestOptions: RequestOptions(path: ''),
              type: type,
            );

            expect(
              exception.isTimeoutError,
              false,
              reason:
                  'isTimeoutError should be false, but is not for type $type',
            );
          }
        },
      );
    });
    group('isConnectionError', () {
      test(
        'should return true when type is connectionError',

        () {
          for (var type in <DioExceptionType>[.connectionError]) {
            final exception = DioException(
              requestOptions: RequestOptions(path: ''),
              type: type,
            );

            expect(
              exception.isConnectionError,
              true,
              reason:
                  'isConnectionError should be true, but is not for type $type',
            );
          }
        },
      );
      test(
        'should return false when type is not connectionError',

        () {
          for (var type in <DioExceptionType>[
            .badCertificate,
            .badResponse,
            .cancel,
            .unknown,
            .receiveTimeout,
            .sendTimeout,
            .connectionTimeout,
          ]) {
            final exception = DioException(
              requestOptions: RequestOptions(path: ''),
              type: type,
            );

            expect(
              exception.isConnectionError,
              false,
              reason:
                  'isConnectionError should be false, but is not for type $type',
            );
          }
        },
      );
    });
  });
}
