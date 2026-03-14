// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:wikwok/src/domain/models/alert.dart';

void main() {
  group('Alert', () {
    group('concurrencyStamp', () {
      test('should generate unique stamp for different alerts', () {
        final alert1 = Alert(
          timestamp: DateTime(2023, 1, 1, 12, 0, 0),
          type: AlertType.info,
          title: 'Test 1',
          content: 'Content 1',
        );

        final alert2 = Alert(
          timestamp: DateTime(2023, 1, 1, 12, 0, 1),
          type: AlertType.info,
          title: 'Test 1',
          content: 'Content 1',
        );

        expect(alert1.concurrencyStamp, isNot(equals(alert2.concurrencyStamp)));
      });

      test('should generate same stamp for identical alerts', () {
        final timestamp = DateTime(2023, 1, 1, 12, 0, 0);
        final alert1 = Alert(
          timestamp: timestamp,
          type: AlertType.info,
          title: 'Test',
          content: 'Content',
        );

        final alert2 = Alert(
          timestamp: timestamp,
          type: AlertType.info,
          title: 'Test',
          content: 'Content',
        );

        expect(alert1.concurrencyStamp, equals(alert2.concurrencyStamp));
      });
    });
  });
}
