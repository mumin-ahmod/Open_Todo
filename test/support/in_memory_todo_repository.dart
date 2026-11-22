import 'package:open_todo/core/error/failures.dart';
import 'package:open_todo/core/platform/app_platform.dart';
import 'package:open_todo/core/utils/result.dart';
import 'package:open_todo/domain/entities/storage_profile.dart';
import 'package:open_todo/domain/entities/todo_item.dart';
import 'package:open_todo/domain/repositories/todo_repository.dart';

class InMemoryTodoRepository implements TodoRepository {
  final List<TodoItem> _items = [];

  @override
  Future<Result<List<TodoItem>>> getTodos() async => Success(List.unmodifiable(_items));

  @override
  Future<Result<TodoItem>> addTodo(
    String title, {
    List<String> tagIds = const [],
  }) async {
    final item = TodoItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      isCompleted: false,
      createdAt: DateTime.now().toUtc(),
      tagIds: tagIds,
    );
    _items.insert(0, item);
    return Success(item);
  }

  @override
  Future<Result<TodoItem>> toggleTodo(String id) async {
    final index = _items.indexWhere((e) => e.id == id);
    if (index == -1) {
      return const Error(CacheFailure('Todo not found'));
    }
    final updated = _items[index].copyWith(isCompleted: !_items[index].isCompleted);
    _items[index] = updated;
    return Success(updated);
  }

  @override
  Future<Result<void>> deleteTodo(String id) async {
    _items.removeWhere((e) => e.id == id);
    return const Success(null);
  }

  @override
  Future<Result<StorageProfile>> getStorageProfile() async {
    return const Success(
      StorageProfile(
        platform: AppPlatform.macos,
        storageDirectory: '/memory',
        engine: 'In-memory test store',
      ),
    );
  }
}