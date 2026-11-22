import 'package:open_todo/core/platform/app_platform.dart';
import 'package:open_todo/domain/entities/todo_item.dart';
import 'package:open_todo/services/home_widget_service.dart';

/// Avoids platform channel calls during widget/unit tests.
class FakeHomeWidgetService extends HomeWidgetService {
  @override
  Future<void> configure(AppPlatform platform) async {}

  @override
  Future<void> syncTodos(List<TodoItem> todos) async {}
}