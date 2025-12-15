// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikwok/core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('SafeMapLookupExtension', () {
    group('get()', () {
      test('should return the correct value when it exists', () {
        final map = <String, int>{'key': 1};

        final result = map.get<int>('key');

        expect(result.isRight(), true);
      });
      test('should return keyNotFound when key does not exist', () {
        final map = <String, int>{'key': 1};

        final result = map.get<int>('otherKey');

        expect(result.isLeft(), true);

        final err = result.getLeft().toNullable()!;

        expect(err, SafeMapLookupError.keyNotFound);
      });
      test(
        'should return typeMismatch when value is not the correct type',
        () {
          final map = <String, int>{'key': 1};

          final result = map.get<String>('key');

          expect(result.isLeft(), true);

          final err = result.getLeft().toNullable()!;

          expect(err, SafeMapLookupError.typeMismatch);
        },
      );
    });
    group('set()', () {
      test('should set the correct value when it exists', () {
        final map = <String, int>{'key': 1};

        final result = map.set('key', 2);

        expect(result.isRight(), true);
        expect(map['key'], 2);
      });
      test('should set the correct value when it does not exist', () {
        final map = <String, int>{};

        final result = map.set('key', 2);

        expect(result.isRight(), true);
        expect(map['key'], 2);
      });
    });
    group('rem()', () {
      test('should remove the correct value when it exists', () {
        final map = <String, int>{'key': 1};

        final result = map.rem<int>('key');

        expect(result.isRight(), true);
        expect(map.containsKey('key'), false);
      });
      test('should return keyNotFound when key does not exist', () {
        final map = <String, int>{'key': 1};

        final result = map.rem<int>('otherKey');

        expect(result.isLeft(), true);

        final err = result.getLeft().toNullable()!;

        expect(err, SafeMapLookupError.keyNotFound);
      });
      test(
        'should return typeMismatch when value is not the correct',
        () {
          final map = <String, int>{'key': 1};

          final result = map.rem<String>('key');

          expect(result.isLeft(), true);

          final err = result.getLeft().toNullable()!;

          expect(err, SafeMapLookupError.typeMismatch);
        },
      );
    });
  });
}
