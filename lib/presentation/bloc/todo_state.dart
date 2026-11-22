import 'package:equatable/equatable.dart';

import '../../domain/entities/storage_profile.dart';
import '../../domain/entities/todo_item.dart';

enum TodoStatus { initial, loading, success, failure }

class TodoState extends Equatable {
  const TodoState({
    this.status = TodoStatus.initial,
    this.todos = const [],
    this.storageProfile,
    this.message,
  });

  final TodoStatus status;
  final List<TodoItem> todos;
  final StorageProfile? storageProfile;
  final String? message;

  int get pendingCount => todos.where((t) => !t.isCompleted).length;
  int get completedCount => todos.where((t) => t.isCompleted).length;

  TodoState copyWith({
    TodoStatus? status,
    List<TodoItem>? todos,
    StorageProfile? storageProfile,
    String? message,
    bool clearMessage = false,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      storageProfile: storageProfile ?? this.storageProfile,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, todos, storageProfile, message];
}