class NewTodoDraft {
  const NewTodoDraft({
    required this.title,
    this.tagIds = const [],
  });

  final String title;
  final List<String> tagIds;
}