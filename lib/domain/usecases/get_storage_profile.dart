import '../../core/utils/result.dart';
import '../entities/storage_profile.dart';
import '../repositories/todo_repository.dart';

class GetStorageProfile {
  const GetStorageProfile(this._repository);

  final TodoRepository _repository;

  Future<Result<StorageProfile>> call() => _repository.getStorageProfile();
}