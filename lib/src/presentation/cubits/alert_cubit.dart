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

  bool _isListening = false;
  Future<void> listen() async {
    if (_isListening) return;

    _isListening = true;

    _alertRepository.alertStream.listen((alert) async {
      final currentAlert = state;

      if (currentAlert != null) {
        read(currentAlert);

        await Future.delayed(const Duration(milliseconds: 20));
      }

      emit(alert);

      Future.delayed(const Duration(milliseconds: 3000), () async {
        await read(alert);
      });
    });
  }

  Future<void> read(Alert alert) async {
    if (alert.concurrencyStamp != state?.concurrencyStamp) return;

    emit(null);
  }

  Future<void> add(Alert alert) async =>
      await _alertRepository.saveAlert(alert);
}
