import 'package:equatable/equatable.dart';

class TagItem extends Equatable {
  const TagItem({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  TagItem copyWith({String? id, String? name}) {
    return TagItem(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  List<Object?> get props => [id, name];
}