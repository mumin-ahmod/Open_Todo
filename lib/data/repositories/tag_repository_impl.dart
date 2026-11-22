import 'package:uuid/uuid.dart';

import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/tag_item.dart';
import '../../domain/repositories/tag_repository.dart';
import '../datasources/preferences_local_data_source.dart';
import '../models/tag_model.dart';

class TagRepositoryImpl implements TagRepository {
  TagRepositoryImpl({
    required this._preferences,
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  final PreferencesLocalDataSource _preferences;
  final Uuid _uuid;

  @override
  Future<Result<List<TagItem>>> getTags() async {
    try {
      final models = await _preferences.fetchTags();
      return Success(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<TagItem>> addTag(String name) async {
    try {
      final trimmed = name.trim();
      if (trimmed.isEmpty) {
        return const Error(ValidationFailure('Tag name cannot be empty'));
      }
      final existing = await _preferences.fetchTags();
      final duplicate = existing.any(
        (t) => t.name.toLowerCase() == trimmed.toLowerCase(),
      );
      if (duplicate) {
        return const Error(ValidationFailure('Tag already exists'));
      }
      final model = TagModel(id: _uuid.v4(), name: trimmed);
      await _preferences.persistTags([...existing, model]);
      return Success(model.toEntity());
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteTag(String id) async {
    try {
      final existing = await _preferences.fetchTags();
      await _preferences.persistTags(existing.where((t) => t.id != id).toList());
      return const Success(null);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }
}