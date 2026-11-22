import 'package:flutter/foundation.dart';

/// Supported runtime platforms for local storage targeting.
enum AppPlatform {
  android,
  ios,
  macos,
  windows,
  linux,
  web,
  unknown,
}

extension AppPlatformX on AppPlatform {
  String get displayName => switch (this) {
        AppPlatform.android => 'Android',
        AppPlatform.ios => 'iOS',
        AppPlatform.macos => 'macOS',
        AppPlatform.windows => 'Windows',
        AppPlatform.linux => 'Linux',
        AppPlatform.web => 'Web',
        AppPlatform.unknown => 'Unknown',
      };

  bool get supportsHomeWidget => switch (this) {
        AppPlatform.android || AppPlatform.ios || AppPlatform.macos => true,
        _ => false,
      };
}

/// Resolves the current OS using Flutter's [defaultTargetPlatform].
class PlatformResolver {
  static AppPlatform get current {
    if (kIsWeb) {
      return AppPlatform.web;
    }
  return switch (defaultTargetPlatform) {
      TargetPlatform.android => AppPlatform.android,
      TargetPlatform.iOS => AppPlatform.ios,
      TargetPlatform.macOS => AppPlatform.macos,
      TargetPlatform.windows => AppPlatform.windows,
      TargetPlatform.linux => AppPlatform.linux,
      TargetPlatform.fuchsia => AppPlatform.unknown,
    };
  }
}