import '../../core/utils/result.dart';
import '../entities/storage_profile.dart';
import '../entities/todo_item.dart';

/// Contract for todo persistence and reads used by the domain layer.
abstract class TodoRepository {
  Future<Result<List<TodoItem>>> getTodos();

  Future<Result<TodoItem>> addTodo(
    String title, {
    List<String> tagIds = const [],
  });

  Future<Result<TodoItem>> toggleTodo(String id);

  Future<Result<void>> deleteTodo(String id);

  Future<Result<StorageProfile>> getStorageProfile();
}