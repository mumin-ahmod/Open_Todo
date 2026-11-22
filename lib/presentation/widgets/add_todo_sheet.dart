import 'package:flutter/material.dart';

import '../../domain/entities/tag_item.dart';
import '../models/new_todo_draft.dart';
import 'tag_chip.dart';

class AddTodoSheet extends StatefulWidget {
  const AddTodoSheet({super.key, this.availableTags = const []});

  final List<TagItem> availableTags;

  @override
  State<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<AddTodoSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final Set<String> _selectedTagIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleTag(String id) {
    setState(() {
      if (_selectedTagIds.contains(id)) {
        _selectedTagIds.remove(id);
      } else {
        _selectedTagIds.add(id);
      }
    });
  }

  void _submit() {
    final title = _controller.text.trim();
    if (title.isEmpty) {
      return;
    }
    Navigator.of(context).pop(
      NewTodoDraft(
        title: title,
        tagIds: _selectedTagIds.toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'New task',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: const InputDecoration(
              hintText: 'What do you need to do?',
            ),
          ),
          if (widget.availableTags.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Tags (optional)',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.availableTags
                  .map(
                    (tag) => TagChip(
                      label: tag.name,
                      selected: _selectedTagIds.contains(tag.id),
                      onTap: () => _toggleTag(tag.id),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submit,
            child: const Text('Add task'),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom > 0 ? 0 : 4),
        ],
      ),
    );
  }
}