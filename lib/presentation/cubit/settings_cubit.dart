import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/result.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit(this._repository) : super(const AppSettings());

  final SettingsRepository _repository;

  Future<void> load() async {
    final result = await _repository.getSettings();
    if (result case Success(:final value)) {
      emit(value);
    }
  }

  Future<void> setDarkTheme(bool value) => _persist(state.copyWith(useDarkTheme: value));

  Future<void> setShowDateTime(bool value) =>
      _persist(state.copyWith(showDateTime: value));

  Future<void> _persist(AppSettings next) async {
    final result = await _repository.saveSettings(next);
    if (result case Success(:final value)) {
      emit(value);
    }
  }

  ThemeMode get themeMode => state.themeMode;
}