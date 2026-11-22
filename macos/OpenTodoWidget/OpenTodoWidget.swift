import SwiftUI
import WidgetKit

private let appGroupId = "group.com.example.open_todo"

struct OpenTodoEntry: TimelineEntry {
    let date: Date
    let pendingCount: Int
    let titles: String
}

struct OpenTodoProvider: TimelineProvider {
    func placeholder(in context: Context) -> OpenTodoEntry {
        OpenTodoEntry(date: .now, pendingCount: 2, titles: "Plan sprint\nReview PRs")
    }

    func getSnapshot(in context: Context, completion: @escaping (OpenTodoEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<OpenTodoEntry>) -> Void) {
        let entry = readEntry()
        completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(900))))
    }

    private func readEntry() -> OpenTodoEntry {
        let prefs = UserDefaults(suiteName: appGroupId)
        let count = prefs?.integer(forKey: "pending_count") ?? 0
        let titles = prefs?.string(forKey: "todo_titles") ?? "All caught up"
        return OpenTodoEntry(date: .now, pendingCount: count, titles: titles)
    }
}

struct OpenTodoWidgetEntryView: View {
    var entry: OpenTodoProvider.Entry

    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.98, blue: 0.96)
            VStack(alignment: .leading, spacing: 8) {
                Text("Open Todo")
                    .font(.headline)
                    .foregroundStyle(Color(red: 0.11, green: 0.26, blue: 0.20))
                Text(entry.pendingCount == 1 ? "1 task left" : "\(entry.pendingCount) tasks left")
                    .font(.caption)
                    .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.31))
                Text(entry.titles)
                    .font(.caption)
                    .lineLimit(4)
                    .foregroundStyle(Color(red: 0.24, green: 0.31, blue: 0.27))
                Spacer(minLength: 0)
            }
            .padding()
        }
    }
}

@main
struct OpenTodoWidget: Widget {
    let kind: String = "OpenTodoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OpenTodoProvider()) { entry in
            OpenTodoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Open Todo")
        .description("See pending tasks at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}