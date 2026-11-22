import 'package:equatable/equatable.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

final class TodoStarted extends TodoEvent {
  const TodoStarted();
}

final class TodoAdded extends TodoEvent {
  const TodoAdded(this.title, {this.tagIds = const []});

  final String title;
  final List<String> tagIds;

  @override
  List<Object?> get props => [title, tagIds];
}

final class TodoToggled extends TodoEvent {
  const TodoToggled(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class TodoDeleted extends TodoEvent {
  const TodoDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}