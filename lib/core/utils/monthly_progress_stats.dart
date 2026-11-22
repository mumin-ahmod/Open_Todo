import '../../domain/entities/todo_item.dart';

class DayActivity {
  const DayActivity({
    required this.day,
    required this.added,
    required this.completed,
  });

  final int day;
  final int added;
  final int completed;
}

/// Counts todos added and completed per calendar day for [month] (any day in that month).
List<DayActivity> buildMonthlyDayActivity(
  List<TodoItem> todos,
  DateTime month,
) {
  final anchor = DateTime(month.year, month.month);
  final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
  final added = List<int>.filled(daysInMonth, 0);
  final completed = List<int>.filled(daysInMonth, 0);

  for (final todo in todos) {
    final created = todo.createdAt.toLocal();
    if (created.year == anchor.year && created.month == anchor.month) {
      added[created.day - 1]++;
    }
    final doneAt = todo.completedAt?.toLocal();
    if (doneAt != null &&
        doneAt.year == anchor.year &&
        doneAt.month == anchor.month) {
      completed[doneAt.day - 1]++;
    }
  }

  return List.generate(
    daysInMonth,
    (index) => DayActivity(
      day: index + 1,
      added: added[index],
      completed: completed[index],
    ),
  );
}

int monthlyTotalAdded(List<DayActivity> days) =>
    days.fold(0, (sum, d) => sum + d.added);

int monthlyTotalCompleted(List<DayActivity> days) =>
    days.fold(0, (sum, d) => sum + d.completed);