import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/platform/app_platform.dart';
import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> fetchTodos();

  Future<void> persistTodos(List<TodoModel> todos);

  Future<({AppPlatform platform, String path, String engine})> readStorageInfo();
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  TodoLocalDataSourceImpl(this._box);

  static const boxName = 'open_todo_v1';
  static const todosKey = 'todos';

  final Box<dynamic> _box;

  Box<dynamic> get hiveBox => _box;

  static Future<TodoLocalDataSourceImpl> create() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<dynamic>(boxName);
    return TodoLocalDataSourceImpl(box);
  }

  /// Lightweight Hive bootstrap for tests (avoids [Hive.initFlutter]).
  static Future<TodoLocalDataSourceImpl> createForTests(String directory) async {
    Hive.init(directory);
    final box = await Hive.openBox<dynamic>(boxName);
    return TodoLocalDataSourceImpl(box);
  }

  @override
  Future<List<TodoModel>> fetchTodos() async {
    final raw = _box.get(todosKey);
    if (raw is! List) {
      return [];
    }
    return raw
        .whereType<Map>()
        .map((e) => TodoModel.fromJson(Map<dynamic, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> persistTodos(List<TodoModel> todos) async {
    await _box.put(todosKey, todos.map((e) => e.toJson()).toList());
  }

  @override
  Future<({AppPlatform platform, String path, String engine})> readStorageInfo() async {
    final dir = await getApplicationSupportDirectory();
    return (
      platform: PlatformResolver.current,
      path: dir.path,
      engine: 'Hive (${Hive.isBoxOpen(boxName) ? boxName : boxName})',
    );
  }
}