import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikwok/domain/models/settings.dart';

@singleton
@injectable
class SettingsRepository {
  SettingsRepository(
    this._preferences,
  );

  final SharedPreferencesAsync _preferences;

  static const _key = 'settings';

  Future<Settings> get() async {
    final data = await _preferences.getString(_key);

    if (data == null) return Settings.asDefault();

    return Settings.fromJson(data);
  }

  Future<void> set(Settings settings) async =>
      await _preferences.setString(_key, settings.toJson());
}
