import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../bloc/tag_bloc.dart';
import '../bloc/tag_event.dart';
import '../bloc/tag_state.dart';
import '../widgets/page_app_bar.dart';
import '../widgets/tag_chip.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTag() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      return;
    }
    context.read<TagBloc>().add(TagAdded(name));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppBar(title: 'Tags'),
      body: BlocConsumer<TagBloc, TagState>(
        listenWhen: (p, c) => c.message != null,
        listener: (context, state) {
          final message = state.message;
          if (message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Tags are optional. Create them here, then pick chips when adding a task.',
                style: TextStyle(color: AppColors.textMuted, height: 1.4),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _addTag(),
                      decoration: const InputDecoration(
                        hintText: 'New tag name',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _addTag,
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (state.tags.isEmpty)
                const Text(
                  'No tags yet.',
                  style: TextStyle(color: AppColors.textMuted),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.tags
                      .map(
                        (tag) => TagChip(
                          label: tag.name,
                          selected: true,
                          onDeleted: () =>
                              context.read<TagBloc>().add(TagRemoved(tag.id)),
                        ),
                      )
                      .toList(),
                ),
            ],
          );
        },
      ),
    );
  }
}