# Open Todo

Cross-platform Flutter todo app with **local-only storage**, a **minimal green UI**, **clean architecture**, and **home screen widgets** on supported platforms.

## Features

- Add, complete, and delete todos — all persisted locally on the device
- Detects the runtime platform (Android, iOS, macOS, Windows) and stores data in that OS app sandbox via Hive + `path_provider`
- Material 3 minimal green theme, light/dark aware
- Android home screen widget (ready to add from the launcher)
- macOS WidgetKit sample target (`macos/OpenTodoWidget/`) for Notification Center widgets (requires Xcode target setup)

## Architecture

```
lib/
  core/           # theme, DI, platform, errors, Result type
  domain/         # entities, repository contracts, use cases
  data/           # models, Hive data source, repository impl
  presentation/   # BLoC + pages/widgets
  services/       # home_widget sync
```

Patterns: dependency inversion (domain ← data), single-responsibility use cases, `Result<T>` for failures, `get_it` composition root.

## Run

```bash
flutter pub get
flutter run
```

Platform examples:

```bash
flutter run -d macos
flutter run -d windows
flutter run -d android
flutter run -d ios
```

## Home widgets

### Android

The app registers `OpenTodoHomeWidgetProvider`. After installing the app:

1. Long-press the home screen → **Widgets**
2. Find **Open Todo** and place it on the home screen

The widget updates whenever todos change inside the app.

### iOS / macOS

Flutter updates shared widget data through the [`home_widget`](https://pub.dev/packages/home_widget) plugin using App Group `group.com.example.open_todo`.

To enable on Apple platforms:

1. Open `ios/Runner.xcworkspace` or `macos/Runner.xcodeproj` in Xcode
2. Add a **Widget Extension** (use `macos/OpenTodoWidget/OpenTodoWidget.swift` as a starting point)
3. Enable the same App Group on both the Runner target and the widget extension
4. Set the widget kind to `OpenTodoWidget` (matches `HomeWidgetService`)

> Windows and Linux do not expose Flutter-friendly home widgets; the app still stores todos locally and shows the active storage path in the UI.

## Testing

```bash
flutter test
flutter analyze
```

## License

Open source — customize and ship freely.