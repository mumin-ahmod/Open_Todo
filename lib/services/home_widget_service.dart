import 'package:home_widget/home_widget.dart';

import '../core/platform/app_platform.dart';
import '../domain/entities/todo_item.dart';

/// Pushes todo summaries to platform home-screen widgets where supported.
class HomeWidgetService {
  static const androidProvider =
      'com.example.open_todo.OpenTodoHomeWidgetProvider';
  static const iosWidgetName = 'OpenTodoWidget';
  static const macWidgetName = 'OpenTodoWidget';
  static const appGroupId = 'group.com.example.open_todo';

  Future<void> configure(AppPlatform platform) async {
    if (!platform.supportsHomeWidget) {
      return;
    }
    try {
      if (platform == AppPlatform.ios || platform == AppPlatform.macos) {
        await HomeWidget.setAppGroupId(appGroupId);
      }
    } catch (_) {
      // Widget extension may not be linked yet on this build.
    }
  }

  Future<void> syncTodos(List<TodoItem> todos) async {
    final platform = PlatformResolver.current;
    if (!platform.supportsHomeWidget) {
      return;
    }

    final active = todos.where((t) => !t.isCompleted).take(5).toList();
    final titles = active.map((t) => t.title).join('\n');
    final pendingCount = todos.where((t) => !t.isCompleted).length;

    try {
      await HomeWidget.saveWidgetData<String>('todo_titles', titles);
      await HomeWidget.saveWidgetData<int>('pending_count', pendingCount);
      await HomeWidget.saveWidgetData<String>(
        'updated_at',
        DateTime.now().toIso8601String(),
      );

      if (platform == AppPlatform.android) {
        await HomeWidget.updateWidget(
          qualifiedAndroidName: androidProvider,
        );
      } else if (platform == AppPlatform.ios) {
        await HomeWidget.updateWidget(
          name: iosWidgetName,
          iOSName: iosWidgetName,
        );
      } else if (platform == AppPlatform.macos) {
        await HomeWidget.updateWidget(
          name: macWidgetName,
          iOSName: macWidgetName,
        );
      }
    } catch (_) {
      // Home screen widget targets are optional per platform build.
    }
  }
}