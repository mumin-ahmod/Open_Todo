import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/result.dart';
import '../../domain/entities/storage_profile.dart';
import '../../domain/entities/todo_item.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_storage_profile.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/toggle_todo.dart';
import '../../services/home_widget_service.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({
    required this._getTodos,
    required this._addTodo,
    required this._toggleTodo,
    required this._deleteTodo,
    required this._getStorageProfile,
    required this._homeWidgetService,
  }) : super(const TodoState()) {
    on<TodoStarted>(_onStarted);
    on<TodoAdded>(_onAdded);
    on<TodoToggled>(_onToggled);
    on<TodoDeleted>(_onDeleted);
  }

  final GetTodos _getTodos;
  final AddTodo _addTodo;
  final ToggleTodo _toggleTodo;
  final DeleteTodo _deleteTodo;
  final GetStorageProfile _getStorageProfile;
  final HomeWidgetService _homeWidgetService;

  Future<void> _onStarted(TodoStarted event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading, clearMessage: true));

    final profileResult = await _getStorageProfile();
    final todosResult = await _getTodos();

    if (todosResult case Error(:final failure)) {
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          message: failure.message,
        ),
      );
      return;
    }

    final todos = (todosResult as Success<List<TodoItem>>).value;
    final StorageProfile? profile = switch (profileResult) {
      Success<StorageProfile>(:final value) => value,
      Error() => null,
    };

    emit(
      state.copyWith(
        status: TodoStatus.success,
        todos: todos,
        storageProfile: profile,
        clearMessage: true,
      ),
    );

    await _homeWidgetService.syncTodos(state.todos);
  }

  Future<void> _onAdded(TodoAdded event, Emitter<TodoState> emit) async {
    final result = await _addTodo(event.title, tagIds: event.tagIds);
    switch (result) {
      case Success(:final value):
        final updated = [value, ...state.todos];
        emit(state.copyWith(todos: updated, clearMessage: true));
        await _homeWidgetService.syncTodos(updated);
      case Error(:final failure):
        emit(state.copyWith(message: failure.message));
    }
  }

  Future<void> _onToggled(TodoToggled event, Emitter<TodoState> emit) async {
    final result = await _toggleTodo(event.id);
    switch (result) {
      case Success(:final value):
        final updated = state.todos
            .map((t) => t.id == value.id ? value : t)
            .toList();
        emit(state.copyWith(todos: updated));
        await _homeWidgetService.syncTodos(updated);
      case Error(:final failure):
        emit(state.copyWith(message: failure.message));
    }
  }

  Future<void> _onDeleted(TodoDeleted event, Emitter<TodoState> emit) async {
    final result = await _deleteTodo(event.id);
    switch (result) {
      case Success():
        final updated = state.todos.where((t) => t.id != event.id).toList();
        emit(state.copyWith(todos: updated));
        await _homeWidgetService.syncTodos(updated);
      case Error(:final failure):
        emit(state.copyWith(message: failure.message));
    }
  }
}