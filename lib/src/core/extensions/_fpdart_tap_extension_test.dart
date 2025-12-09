// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:wikwok/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  group('FpdartTapEitherExtension', () {
    group('tapLeft()', () {
      test('should return the initial value when not left', () async {
        final result = Either<String, int>.of(1);

        bool tapped = false;
        final tappedResult = result.tapLeft((left) {
          tapped = true;
        });

        expect(tappedResult, result);
        expect(tapped, false);
      });
      test('should return the initial value when left', () async {
        final result = Either<String, int>.left('error');

        bool tapped = false;
        final tappedResult = result.tapLeft((left) {
          tapped = true;
        });

        expect(tappedResult, result);
        expect(tapped, true);
      });
    });
    group('tapRight()', () {
      test('should return the initial value when not right', () async {
        final result = Either<String, int>.left('error');

        bool tapped = false;
        final tappedResult = result.tapRight((right) {
          tapped = true;
        });

        expect(tappedResult, result);
        expect(tapped, false);
      });
      test('should return the initial value when right', () async {
        final result = Either<String, int>.of(1);

        bool tapped = false;
        final tappedResult = result.tapRight((right) {
          tapped = true;
        });

        expect(tappedResult, result);
        expect(tapped, true);
      });
    });
  });
  group('FpdartTapTaskEitherExtension', () {
    group('tapLeft()', () {
      test('should return the initial value when not left', () async {
        final result = TaskEither<String, int>.of(1);

        bool tapped = false;
        final tappedResult = result.tapLeft((left) {
          tapped = true;
        });

        expect(await tappedResult.run(), await result.run());
        expect(tapped, false);
      });
      test('should return the initial value when left', () async {
        final result = TaskEither<String, int>.left('error');

        bool tapped = false;
        final tappedResult = result.tapLeft((left) {
          tapped = true;
        });

        expect(await tappedResult.run(), await result.run());
        expect(tapped, true);
      });
    });
    group('tapRight()', () {
      test('should return the initial value when not right', () async {
        final result = TaskEither<String, int>.left('error');

        bool tapped = false;
        final tappedResult = result.tapRight((right) {
          tapped = true;
        });

        expect(await tappedResult.run(), await result.run());
        expect(tapped, false);
      });
      test('should return the initial value when right', () async {
        final result = TaskEither<String, int>.of(1);

        bool tapped = false;
        final tappedResult = result.tapRight((right) {
          tapped = true;
        });

        expect(await tappedResult.run(), await result.run());
        expect(tapped, true);
      });
    });
  });
}
