import 'package:equatable/equatable.dart';

sealed class TagEvent extends Equatable {
  const TagEvent();

  @override
  List<Object?> get props => [];
}

final class TagStarted extends TagEvent {
  const TagStarted();
}

final class TagAdded extends TagEvent {
  const TagAdded(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class TagRemoved extends TagEvent {
  const TagRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}