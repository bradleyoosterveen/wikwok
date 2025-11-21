import 'package:wikwok/core.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

class SettingsCubit extends WCubit<Settings> {
  SettingsCubit() : super(Settings.asDefault());

  final _settingsRepository = inject<SettingsRepository>();

  Future get() async {
    final settings = await _settingsRepository.get();

    emit(settings);
  }

  Future change(Settings settings) async {
    await _settingsRepository.set(settings);

    emit(settings);
  }
}
