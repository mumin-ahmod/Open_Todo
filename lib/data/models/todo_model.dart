import '../../domain/entities/todo_item.dart';

class TodoModel {
  const TodoModel({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
    this.note,
    this.tagIds = const [],
    this.completedAt,
  });

  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;
  final String? note;
  final List<String> tagIds;
  final DateTime? completedAt;

  factory TodoModel.fromEntity(TodoItem item) {
    return TodoModel(
      id: item.id,
      title: item.title,
      isCompleted: item.isCompleted,
      createdAt: item.createdAt,
      note: item.note,
      tagIds: item.tagIds,
      completedAt: item.completedAt,
    );
  }

  factory TodoModel.fromJson(Map<dynamic, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      note: json['note'] as String?,
      tagIds: (json['tagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'note': note,
      'tagIds': tagIds,
      if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
    };
  }

  TodoItem toEntity() {
    return TodoItem(
      id: id,
      title: title,
      isCompleted: isCompleted,
      createdAt: createdAt,
      note: note,
      tagIds: tagIds,
      completedAt: completedAt,
    );
  }

  TodoModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    String? note,
    List<String>? tagIds,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
      tagIds: tagIds ?? this.tagIds,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }
}