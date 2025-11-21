import 'package:injectable/injectable.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class SettingsCubit extends WCubit<Settings> {
  SettingsCubit(this._settingsRepository) : super(Settings.asDefault());

  final SettingsRepository _settingsRepository;

  Future get() async {
    final settings = await _settingsRepository.get();

    emit(settings);
  }

  Future change(Settings settings) async {
    await _settingsRepository.set(settings);

    emit(settings);
  }
}
