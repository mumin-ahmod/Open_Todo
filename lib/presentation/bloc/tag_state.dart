import 'package:equatable/equatable.dart';

import '../../domain/entities/tag_item.dart';

enum TagStatus { initial, loading, success, failure }

class TagState extends Equatable {
  const TagState({
    this.status = TagStatus.initial,
    this.tags = const [],
    this.message,
  });

  final TagStatus status;
  final List<TagItem> tags;
  final String? message;

  TagState copyWith({
    TagStatus? status,
    List<TagItem>? tags,
    String? message,
    bool clearMessage = false,
  }) {
    return TagState(
      status: status ?? this.status,
      tags: tags ?? this.tags,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, tags, message];
}