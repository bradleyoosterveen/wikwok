import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:wikwok/domain.dart';

enum AlertRepositoryError {
  unknown,
  somethingWentWrong,
}

@singleton
@injectable
class AlertRepository {
  AlertRepository();

  final _alertStreamController = StreamController<Alert>.broadcast();

  Stream<Alert> get alertStream => _alertStreamController.stream;

  void _notifyNewAlert(Alert alert) => _alertStreamController.add(alert);

  Future<bool> saveAlert(Alert alert) async {
    try {
      _notifyNewAlert(alert);
      return true;
    } catch (e) {
      return false;
    }
  }

  @disposeMethod
  void dispose() => unawaited(_alertStreamController.close());
}
