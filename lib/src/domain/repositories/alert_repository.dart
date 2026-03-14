import 'dart:async';
import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/domain.dart';

enum AlertRepositoryError {
  unknown,
  somethingWentWrong,
  connectionError,
}

@singleton
@injectable
class AlertRepository {
  AlertRepository(
    this._preferences,
  );

  final SharedPreferencesAsync _preferences;

  static AlertRepositoryError _toError(dynamic e) => switch (e) {
    AlertRepositoryError e => e,
    SafeMapLookupError e => switch (e) {
      .keyNotFound => .somethingWentWrong,
      .typeMismatch => .somethingWentWrong,
      .somethingWentWrong => .somethingWentWrong,
    },
    _ => .unknown,
  };

  static const _key = 'alerts';

  final _alertStreamController = StreamController<Alert>.broadcast();

  Stream<Alert> get alertStream => _alertStreamController.stream;

  void _notifyNewAlert(Alert alert) {
    _alertStreamController.add(alert);
  }

  Future<bool> saveAlert(Alert alert) async {
    try {
      final alertsResult = await getAlerts().run();

      return alertsResult.fold((e) => false, (alerts) async {
        alerts.add(alert);

        final jsonList = alerts.map((a) => jsonEncode(a.toJson())).toList();
        await _preferences.setStringList(_key, jsonList);

        _notifyNewAlert(alert);
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  TaskEither<AlertRepositoryError, List<Alert>> getAlerts() =>
      TaskEither.tryCatch(() async {
        final saved = await _preferences.getStringList(_key);

        if (saved == null || saved.isEmpty) {
          return [];
        }

        return saved.map((jsonString) {
          final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
          return Alert.fromJson(jsonMap);
        }).toList();
      }, (e, _) => _toError(e));

  Future<bool> deleteAlert(Alert alert) async {
    try {
      final alertsResult = await getAlerts().run();

      return alertsResult.fold((e) => false, (alerts) async {
        final index = alerts.indexWhere(
          (a) => a.concurrencyStamp == alert.concurrencyStamp,
        );
        if (index == -1) return false;

        alerts.removeAt(index);

        final jsonList = alerts.map((a) => jsonEncode(a.toJson())).toList();
        await _preferences.setStringList(_key, jsonList);

        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAllAlerts() async {
    try {
      await _preferences.setStringList(_key, []);
      return true;
    } catch (e) {
      return false;
    }
  }

  @disposeMethod
  void dispose() {
    _alertStreamController.close();
  }
}
