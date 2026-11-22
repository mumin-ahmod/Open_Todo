import 'package:equatable/equatable.dart';

import '../../core/platform/app_platform.dart';

/// Describes where todos are persisted on the current device.
class StorageProfile extends Equatable {
  const StorageProfile({
    required this.platform,
    required this.storageDirectory,
    required this.engine,
  });

  final AppPlatform platform;
  final String storageDirectory;
  final String engine;

  @override
  List<Object?> get props => [platform, storageDirectory, engine];
}