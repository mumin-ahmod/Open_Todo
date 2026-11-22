import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/tag_item.dart';
import '../bloc/tag_bloc.dart';
import '../bloc/tag_state.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../cubit/settings_cubit.dart';
import '../models/new_todo_draft.dart';
import '../widgets/add_todo_sheet.dart';
import '../widgets/app_drawer.dart';
import '../widgets/todo_list_tile.dart';
import '../widgets/todo_stats_row.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<TagItem> _tagsForTodo(List<String> ids, List<TagItem> all) {
    return all.where((t) => ids.contains(t.id)).toList();
  }

  Future<void> _openAddSheet(BuildContext context) async {
    final tags = context.read<TagBloc>().state.tags;
    final draft = await showModalBottomSheet<NewTodoDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddTodoSheet(availableTags: tags),
    );

    if (draft != null && context.mounted) {
      context.read<TodoBloc>().add(
            TodoAdded(draft.title, tagIds: draft.tagIds),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final showDateTime = context.watch<SettingsCubit>().state.showDateTime;

    return BlocConsumer<TodoBloc, TodoState>(
      listenWhen: (previous, current) => current.message != null,
      listener: (context, state) {
        final message = state.message;
        if (message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      },
      builder: (context, state) {
        return BlocBuilder<TagBloc, TagState>(
          builder: (context, tagState) {
            return Scaffold(
              drawer: const AppDrawer(),
              appBar: AppBar(
                title: const Text('Open Todo'),
              ),
              body: state.status == TodoStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () async {
                        context.read<TodoBloc>().add(const TodoStarted());
                        await context.read<TodoBloc>().stream.firstWhere(
                              (s) => s.status != TodoStatus.loading,
                            );
                      },
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                        children: [
                          Text(
                            'Stay focused.\nGet things done.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  height: 1.4,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.55),
                                ),
                          ),
                          const SizedBox(height: 20),
                          TodoStatsRow(
                            pending: state.pendingCount,
                            completed: state.completedCount,
                          ),
                          const SizedBox(height: 24),
                          if (state.todos.isEmpty)
                            const _EmptyState()
                          else
                            ...state.todos.map(
                              (todo) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: TodoListTile(
                                  todo: todo,
                                  tags: _tagsForTodo(todo.tagIds, tagState.tags),
                                  showDateTime: showDateTime,
                                  onToggle: () => context
                                      .read<TodoBloc>()
                                      .add(TodoToggled(todo.id)),
                                  onDelete: () => context
                                      .read<TodoBloc>()
                                      .add(TodoDeleted(todo.id)),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => _openAddSheet(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add'),
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap Add to create your first todo.\nData stays on this device.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}