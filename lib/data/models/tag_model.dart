import '../../domain/entities/tag_item.dart';

class TagModel {
  const TagModel({required this.id, required this.name});

  final String id;
  final String name;

  factory TagModel.fromJson(Map<dynamic, dynamic> json) {
    return TagModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  TagItem toEntity() => TagItem(id: id, name: name);

  factory TagModel.fromEntity(TagItem item) =>
      TagModel(id: item.id, name: item.name);
}