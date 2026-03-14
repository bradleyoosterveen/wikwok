import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class AlertCubit extends WCubit<Alert?> {
  AlertCubit(
    this._alertRepository,
  ) : super(null);

  final AlertRepository _alertRepository;

  StreamSubscription? _alertSubscription;

  Future<void> init() async {
    if (_alertSubscription != null) return;

    _alertSubscription ??= _alertRepository.alertStream.listen((alert) async {
      final currentAlert = state;

      if (currentAlert != null) {
        await read(currentAlert);

        await Future.delayed(const Duration(milliseconds: 20));
      }

      emit(alert);

      await Future.delayed(const Duration(milliseconds: 3000), () async {
        await read(alert);
      });
    });
  }

  Future<void> read(Alert alert) async {
    if (alert.concurrencyStamp != state?.concurrencyStamp) return;

    emit(null);
  }

  @override
  Future<void> close() async {
    await _alertSubscription?.cancel();
    await super.close();
  }
}
