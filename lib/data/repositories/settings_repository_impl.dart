import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/preferences_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._preferences);

  final PreferencesLocalDataSource _preferences;

  @override
  Future<Result<AppSettings>> getSettings() async {
    try {
      return Success(await _preferences.fetchSettings());
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<AppSettings>> saveSettings(AppSettings settings) async {
    try {
      await _preferences.persistSettings(settings);
      return Success(settings);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }
}