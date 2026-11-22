import '../../core/utils/result.dart';
import '../entities/todo_item.dart';
import '../repositories/todo_repository.dart';

class GetTodos {
  const GetTodos(this._repository);

  final TodoRepository _repository;

  Future<Result<List<TodoItem>>> call() => _repository.getTodos();
}