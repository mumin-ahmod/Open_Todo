import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_state.dart';
import '../widgets/page_app_bar.dart';

class DailyProgressPage extends StatelessWidget {
  const DailyProgressPage({super.key});

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    final local = date.toLocal();
    return local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppBar(title: 'Daily progress'),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          final addedToday =
              state.todos.where((t) => _isToday(t.createdAt)).length;
          final completedToday = state.todos
              .where(
                (t) =>
                    t.isCompleted &&
                    t.completedAt != null &&
                    _isToday(t.completedAt!),
              )
              .length;
          final pendingToday = state.todos
              .where((t) => !t.isCompleted && _isToday(t.createdAt))
              .length;
          final totalToday = addedToday == 0 ? 1 : addedToday;
          final progress = (completedToday / totalToday).clamp(0.0, 1.0);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                DateFormat.yMMMMEEEEd().format(DateTime.now()),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textMuted,
                    ),
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor:
                            AppColors.seedGreen.withValues(alpha: 0.12),
                        color: AppColors.seedGreen,
                      ),
                      Center(
                        child: Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _MetricCard(
                title: 'Completed today',
                value: '$completedToday',
                icon: Icons.check_circle_outline,
              ),
              const SizedBox(height: 12),
              _MetricCard(
                title: 'Added today',
                value: '$addedToday',
                icon: Icons.add_task_outlined,
              ),
              const SizedBox(height: 12),
              _MetricCard(
                title: 'Still active from today',
                value: '$pendingToday',
                icon: Icons.pending_actions_outlined,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.seedGreen),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.deepGreen,
          ),
        ),
      ),
    );
  }
}