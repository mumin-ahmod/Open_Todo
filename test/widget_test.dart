import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_todo/core/theme/app_theme.dart';
import 'package:open_todo/core/utils/result.dart';
import 'package:open_todo/domain/entities/app_settings.dart';
import 'package:open_todo/domain/entities/tag_item.dart';
import 'package:open_todo/domain/repositories/settings_repository.dart';
import 'package:open_todo/domain/repositories/tag_repository.dart';
import 'package:open_todo/domain/usecases/add_todo.dart';
import 'package:open_todo/domain/usecases/delete_todo.dart';
import 'package:open_todo/domain/usecases/get_storage_profile.dart';
import 'package:open_todo/domain/usecases/get_todos.dart';
import 'package:open_todo/domain/usecases/toggle_todo.dart';
import 'package:open_todo/presentation/bloc/tag_bloc.dart';
import 'package:open_todo/presentation/bloc/tag_event.dart';
import 'package:open_todo/presentation/bloc/todo_bloc.dart';
import 'package:open_todo/presentation/bloc/todo_event.dart';
import 'package:open_todo/presentation/bloc/todo_state.dart';
import 'package:open_todo/presentation/cubit/settings_cubit.dart';
import 'package:open_todo/presentation/pages/home_page.dart';

import 'support/fake_home_widget_service.dart';
import 'support/in_memory_todo_repository.dart';

class _FakeSettingsRepository implements SettingsRepository {
  @override
  Future<Result<AppSettings>> getSettings() async => const Success(AppSettings());

  @override
  Future<Result<AppSettings>> saveSettings(AppSettings settings) async =>
      Success(settings);
}

class _FakeTagRepository implements TagRepository {
  @override
  Future<Result<List<TagItem>>> getTags() async => const Success([]);

  @override
  Future<Result<TagItem>> addTag(String name) async =>
      throw UnimplementedError();

  @override
  Future<Result<void>> deleteTag(String id) async =>
      throw UnimplementedError();
}

TodoBloc _buildTestBloc(InMemoryTodoRepository repository) {
  return TodoBloc(
    getTodos: GetTodos(repository),
    addTodo: AddTodo(repository),
    toggleTodo: ToggleTodo(repository),
    deleteTodo: DeleteTodo(repository),
    getStorageProfile: GetStorageProfile(repository),
    homeWidgetService: FakeHomeWidgetService(),
  );
}

Future<void> _pumpHome(WidgetTester tester, TodoBloc bloc) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: bloc),
          BlocProvider(
            create: (_) => SettingsCubit(_FakeSettingsRepository())..load(),
          ),
          BlocProvider(
            create: (_) => TagBloc(_FakeTagRepository())..add(const TagStarted()),
          ),
        ],
        child: const HomePage(),
      ),
    ),
  );
}

void main() {
  testWidgets('renders home screen and adds a todo', (tester) async {
    final repository = InMemoryTodoRepository();
    final bloc = _buildTestBloc(repository)..add(const TodoStarted());

    await _pumpHome(tester, bloc);
    await bloc.stream.firstWhere((s) => s.status == TodoStatus.success);
    await tester.pump();

    expect(find.text('Open Todo'), findsOneWidget);
    expect(find.text('No tasks yet'), findsOneWidget);

    await tester.tap(find.text('Add'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.enterText(find.byType(TextField), 'Ship release');
    await tester.tap(find.text('Add task'));
    await tester.pump();
    await bloc.stream.firstWhere(
      (s) => s.todos.any((t) => t.title == 'Ship release'),
    );
    await tester.pump();

    expect(find.text('Ship release'), findsOneWidget);
    expect(find.text('No tasks yet'), findsNothing);
  });
}