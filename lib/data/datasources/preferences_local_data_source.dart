import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/app_settings.dart';
import '../models/tag_model.dart';

abstract class PreferencesLocalDataSource {
  Future<List<TagModel>> fetchTags();

  Future<void> persistTags(List<TagModel> tags);

  Future<AppSettings> fetchSettings();

  Future<void> persistSettings(AppSettings settings);
}

class PreferencesLocalDataSourceImpl implements PreferencesLocalDataSource {
  PreferencesLocalDataSourceImpl(this._box);

  static const tagsKey = 'tags';
  static const settingsKey = 'settings';

  final Box<dynamic> _box;

  @override
  Future<List<TagModel>> fetchTags() async {
    final raw = _box.get(tagsKey);
    if (raw is! List) {
      return [];
    }
    return raw
        .whereType<Map>()
        .map((e) => TagModel.fromJson(Map<dynamic, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<void> persistTags(List<TagModel> tags) async {
    await _box.put(tagsKey, tags.map((e) => e.toJson()).toList());
  }

  @override
  Future<AppSettings> fetchSettings() async {
    final raw = _box.get(settingsKey);
    if (raw is! Map) {
      return const AppSettings();
    }
    final map = Map<dynamic, dynamic>.from(raw);
    return AppSettings(
      useDarkTheme: map['useDarkTheme'] as bool? ?? false,
      showDateTime: map['showDateTime'] as bool? ?? true,
    );
  }

  @override
  Future<void> persistSettings(AppSettings settings) async {
    await _box.put(settingsKey, {
      'useDarkTheme': settings.useDarkTheme,
      'showDateTime': settings.showDateTime,
    });
  }
}