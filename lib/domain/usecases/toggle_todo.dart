import '../../core/utils/result.dart';
import '../entities/todo_item.dart';
import '../repositories/todo_repository.dart';

class ToggleTodo {
  const ToggleTodo(this._repository);

  final TodoRepository _repository;

  Future<Result<TodoItem>> call(String id) => _repository.toggleTodo(id);
}