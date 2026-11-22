import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../entities/todo_item.dart';
import '../repositories/todo_repository.dart';

class AddTodo {
  const AddTodo(this._repository);

  final TodoRepository _repository;

  Future<Result<TodoItem>> call(
    String title, {
    List<String> tagIds = const [],
  }) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return Future.value(
        const Error(ValidationFailure('Title cannot be empty')),
      );
    }
    return _repository.addTodo(trimmed, tagIds: tagIds);
  }
}