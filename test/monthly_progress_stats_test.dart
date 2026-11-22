import 'package:flutter_test/flutter_test.dart';
import 'package:open_todo/core/utils/monthly_progress_stats.dart';
import 'package:open_todo/domain/entities/todo_item.dart';

void main() {
  test('buildMonthlyDayActivity buckets by created and completed dates', () {
    final month = DateTime(2026, 11);
    final todos = [
      TodoItem(
        id: '1',
        title: 'a',
        isCompleted: true,
        createdAt: DateTime(2026, 11, 3, 10),
        completedAt: DateTime(2026, 11, 5, 12),
      ),
      TodoItem(
        id: '2',
        title: 'b',
        isCompleted: false,
        createdAt: DateTime(2026, 11, 3, 11),
      ),
      TodoItem(
        id: '3',
        title: 'c',
        isCompleted: true,
        createdAt: DateTime(2026, 10, 30),
        completedAt: DateTime(2026, 11, 5, 18),
      ),
    ];

    final days = buildMonthlyDayActivity(todos, month);

    expect(days[2].added, 2);
    expect(days[2].completed, 0);
    expect(days[4].added, 0);
    expect(days[4].completed, 2);
    expect(monthlyTotalAdded(days), 2);
    expect(monthlyTotalCompleted(days), 2);
  });
}