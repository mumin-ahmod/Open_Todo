import '../../core/utils/result.dart';
import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Result<AppSettings>> getSettings();

  Future<Result<AppSettings>> saveSettings(AppSettings settings);
}