import '../../core/utils/result.dart';
import '../entities/tag_item.dart';

abstract class TagRepository {
  Future<Result<List<TagItem>>> getTags();

  Future<Result<TagItem>> addTag(String name);

  Future<Result<void>> deleteTag(String id);
}