// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikwok/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  group('AsyncCacheHandler', () {
    group('handle()', () {
      test('should return the result of the action', () async {
        final result = await AsyncCacheHandler().run<String>(
          key: 'key',
          action: () async => 'result',
        );

        expect(result, 'result');
      });
      test(
        'should return the result of the action and invalidate the cache',
        () async {
          final handler = AsyncCacheHandler();
          const key = 'key';
          final now = DateTime.now();

          final firstResult = await handler.run<DateTime>(
            key: key,
            action: () async => now,
          );

          expect(firstResult, now);

          final nowInOneHour = now.add(const Duration(hours: 1));

          final secondResult = await handler.run<DateTime>(
            key: key,
            action: () async => nowInOneHour,
          );

          expect(secondResult, nowInOneHour);
          expect(handler.completers.isEmpty, true);
        },
      );
      test(
        'should return the same result when called again with the same key and a duration of non-zero',
        () async {
          final handler = AsyncCacheHandler();
          const key = 'key';
          final now = DateTime.now();

          final firstResult = await handler.run<DateTime>(
            key: key,
            action: () async => now,
            duration: const Duration(hours: 1),
          );

          expect(firstResult, now);
          expect(handler.completers.isEmpty, false);

          final secondResult = await handler.run<DateTime>(
            key: key,
            action: () async => DateTime.now().add(const Duration(hours: 1)),
            duration: const Duration(hours: 1),
          );

          expect(secondResult, now);
        },
      );
      test(
        'should return the same exception when called again with the same key and a duration of non-zero',
        () async {
          final handler = AsyncCacheHandler();
          const key = 'key';
          final exception = Exception();

          final firstResult = handler.run<DateTime>(
            key: key,
            action: () async => throw exception,
            duration: const Duration(hours: 1),
          );

          expect(firstResult, throwsA(exception));

          final secondResult = handler.run<DateTime>(
            key: key,
            action: () async => DateTime.now(),
            duration: const Duration(hours: 1),
          );

          expect(secondResult, throwsA(exception));
        },
      );
      test('should properly throw an error on exception', () async {
        final handler = AsyncCacheHandler();
        const key = 'key';

        final result = handler.run<DateTime>(
          key: key,
          action: () async => throw Exception(),
        );

        expect(result, throwsException);
      });
    });
    group('scheduleInvalidate()', () {
      test('should invalidate the cache after the given duration', () async {
        final handler = AsyncCacheHandler();
        const key = 'key';

        handler.completers[key] = Completer<DateTime>();

        handler.scheduleInvalidate(key, const Duration(milliseconds: 10));

        expect(handler.completers.isEmpty, false);

        await Future.delayed(const Duration(milliseconds: 100));

        expect(handler.completers.isEmpty, true);
      });
    });
    group('invalidate()', () {
      test('should invalidate the cache', () async {
        final handler = AsyncCacheHandler();
        const key = 'key';
        handler.completers[key] = Completer<DateTime>();

        expect(handler.completers.isEmpty, false);

        handler.invalidate(key);

        expect(handler.completers.isEmpty, true);
      });
    });
    group('clear()', () {
      test('should invalidate the cache', () async {
        final handler = AsyncCacheHandler();
        handler.completers['one'] = Completer<DateTime>();
        handler.completers['two'] = Completer<DateTime>();

        expect(handler.completers.isEmpty, false);
        expect(handler.completers.length, 2);

        handler.clear();

        expect(handler.completers.isEmpty, true);
      });
    });
  });
}
