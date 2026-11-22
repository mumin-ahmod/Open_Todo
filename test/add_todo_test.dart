import 'package:flutter_test/flutter_test.dart';
import 'package:open_todo/core/error/failures.dart';
import 'package:open_todo/core/utils/result.dart';
import 'package:open_todo/domain/entities/storage_profile.dart';
import 'package:open_todo/domain/entities/todo_item.dart';
import 'package:open_todo/domain/repositories/todo_repository.dart';
import 'package:open_todo/domain/usecases/add_todo.dart';

class _FakeTodoRepository implements TodoRepository {
  @override
  Future<Result<TodoItem>> addTodo(
    String title, {
    List<String> tagIds = const [],
  }) async {
    return Success(
      TodoItem(
        id: '1',
        title: title,
        isCompleted: false,
        createdAt: DateTime.utc(2026),
      ),
    );
  }

  @override
  Future<Result<void>> deleteTodo(String id) => throw UnimplementedError();

  @override
  Future<Result<List<TodoItem>>> getTodos() => throw UnimplementedError();

  @override
  Future<Result<StorageProfile>> getStorageProfile() =>
      throw UnimplementedError();

  @override
  Future<Result<TodoItem>> toggleTodo(String id) => throw UnimplementedError();
}

void main() {
  group('AddTodo', () {
    final useCase = AddTodo(_FakeTodoRepository());

    test('rejects blank titles', () async {
      final result = await useCase('   ');
      expect(result, isA<Error>());
      expect((result as Error).failure, isA<ValidationFailure>());
    });

    test('trims titles before saving', () async {
      final result = await useCase('  Buy milk  ');
      expect(result, isA<Success<TodoItem>>());
      expect((result as Success<TodoItem>).value.title, 'Buy milk');
    });
  });
}