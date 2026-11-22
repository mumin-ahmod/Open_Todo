import 'package:get_it/get_it.dart';

import '../../data/datasources/preferences_local_data_source.dart';
import '../../data/datasources/todo_local_data_source.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/repositories/tag_repository_impl.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/tag_repository.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_storage_profile.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/toggle_todo.dart';
import '../../presentation/bloc/tag_bloc.dart';
import '../../presentation/bloc/todo_bloc.dart';
import '../../presentation/cubit/settings_cubit.dart';
import '../../services/home_widget_service.dart';
import '../platform/app_platform.dart';

final sl = GetIt.instance;

Future<void> configureDependencies({
  HomeWidgetService? homeWidgetService,
  TodoLocalDataSource? localDataSource,
}) async {
  final dataSource =
      localDataSource ?? await TodoLocalDataSourceImpl.create();
  final widgetService = homeWidgetService ?? HomeWidgetService();
  final hiveBox = (dataSource as TodoLocalDataSourceImpl).hiveBox;
  final preferences = PreferencesLocalDataSourceImpl(hiveBox);

  sl
    ..registerSingleton<TodoLocalDataSource>(dataSource)
    ..registerSingleton<PreferencesLocalDataSource>(preferences)
    ..registerLazySingleton<TodoRepository>(
      () => TodoRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton<TagRepository>(
      () => TagRepositoryImpl(preferences: sl()),
    )
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetTodos(sl()))
    ..registerLazySingleton(() => AddTodo(sl()))
    ..registerLazySingleton(() => ToggleTodo(sl()))
    ..registerLazySingleton(() => DeleteTodo(sl()))
    ..registerLazySingleton(() => GetStorageProfile(sl()))
    ..registerSingleton<HomeWidgetService>(widgetService)
    ..registerLazySingleton(() => SettingsCubit(sl()))
    ..registerFactory(
      () => TodoBloc(
        getTodos: sl(),
        addTodo: sl(),
        toggleTodo: sl(),
        deleteTodo: sl(),
        getStorageProfile: sl(),
        homeWidgetService: sl(),
      ),
    )
    ..registerFactory(() => TagBloc(sl()));

  if (homeWidgetService == null) {
    await sl<HomeWidgetService>().configure(PlatformResolver.current);
  }
}