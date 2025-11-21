// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:wikwok/domain.dart';

class _Case {
  final Version version;
  final Version other;
  final bool expected;

  const _Case({
    required this.version,
    required this.other,
    required this.expected,
  });
}

void main() {
  group('Version', () {
    group('isNewerThan()', () {
      final cases = <_Case>[
        _Case(
          version: Version.parse('1.0.0'),
          other: Version.parse('1.0.0'),
          expected: false,
        ),
        _Case(
          version: Version.parse('1.0.0'),
          other: Version.parse('1.0.1'),
          expected: false,
        ),
        _Case(
          version: Version.parse('1.0.1'),
          other: Version.parse('1.0.0'),
          expected: true,
        ),
        _Case(
          version: Version.parse('1.0.0'),
          other: Version.parse('0.0.1'),
          expected: true,
        ),
        _Case(
          version: Version.parse('0.0.1'),
          other: Version.parse('1.0.0'),
          expected: false,
        ),
        _Case(
            version: Version.parse('2.0.0'),
            other: Version.parse('1.0.0'),
            expected: true),
      ];

      for (final case_ in cases) {
        test('${case_.version} is newer than ${case_.other}', () {
          expect(
            case_.version.isNewerThan(case_.other),
            case_.expected,
            reason: 'version: ${case_.version}, other: ${case_.other}',
          );
        });
      }
    });
  });
}
