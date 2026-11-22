import 'package:uuid/uuid.dart';

import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/storage_profile.dart';
import '../../domain/entities/todo_item.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_data_source.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl({
    required this._localDataSource,
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  final TodoLocalDataSource _localDataSource;
  final Uuid _uuid;

  @override
  Future<Result<List<TodoItem>>> getTodos() async {
    try {
      final models = await _localDataSource.fetchTodos();
      return Success(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<TodoItem>> addTodo(
    String title, {
    List<String> tagIds = const [],
  }) async {
    try {
      final existing = await _localDataSource.fetchTodos();
      final model = TodoModel(
        id: _uuid.v4(),
        title: title,
        isCompleted: false,
        createdAt: DateTime.now().toUtc(),
        tagIds: tagIds,
      );
      final updated = [model, ...existing];
      await _localDataSource.persistTodos(updated);
      return Success(model.toEntity());
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<TodoItem>> toggleTodo(String id) async {
    try {
      final existing = await _localDataSource.fetchTodos();
      final index = existing.indexWhere((e) => e.id == id);
      if (index == -1) {
        return const Error(CacheFailure('Todo not found'));
      }
      final wasCompleted = existing[index].isCompleted;
      final nowComplete = !wasCompleted;
      final toggled = existing[index].copyWith(
        isCompleted: nowComplete,
        completedAt: nowComplete ? DateTime.now().toUtc() : null,
        clearCompletedAt: !nowComplete,
      );
      final updated = [...existing]..[index] = toggled;
      await _localDataSource.persistTodos(updated);
      return Success(toggled.toEntity());
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteTodo(String id) async {
    try {
      final existing = await _localDataSource.fetchTodos();
      final updated = existing.where((e) => e.id != id).toList();
      await _localDataSource.persistTodos(updated);
      return const Success(null);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<StorageProfile>> getStorageProfile() async {
    try {
      final info = await _localDataSource.readStorageInfo();
      return Success(
        StorageProfile(
          platform: info.platform,
          storageDirectory: info.path,
          engine: info.engine,
        ),
      );
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }
}