import WidgetKit
import SwiftUI

struct TodoWidgetEntry: TimelineEntry {
	let date: Date
	let todos: [Todo]
}

struct TodoWidgetProvider: TimelineProvider {
	func placeholder(in context: Context) -> TodoWidgetEntry {
		TodoWidgetEntry(
			date: Date(),
			todos: [
				Todo(title: "Buy coffee"),
				Todo(title: "Reply to messages"),
				Todo(title: "Plan tomorrow")
			]
		)
	}

	func getSnapshot(in context: Context, completion: @escaping (TodoWidgetEntry) -> Void) {
		completion(TodoWidgetEntry(date: Date(), todos: TodoStorage.upcomingTodos(limit: 4)))
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<TodoWidgetEntry>) -> Void) {
		let entry = TodoWidgetEntry(date: Date(), todos: TodoStorage.upcomingTodos(limit: 4))
		let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date().addingTimeInterval(900)
		completion(Timeline(entries: [entry], policy: .after(refreshDate)))
	}
}

struct TodoListWidget: Widget {
	let kind = "TodoListWidget"

	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: TodoWidgetProvider()) { entry in
			TodoListWidgetView(entry: entry)
		}
		.configurationDisplayName("Todo List")
		.description("See your next todos and jump straight into adding one.")
		.supportedFamilies([.systemSmall, .systemMedium])
	}
}

struct TodoListWidgetView: View {
	@Environment(\.widgetFamily) private var family

	let entry: TodoWidgetEntry

	private var displayedTodos: [Todo] {
		switch family {
		case .systemSmall:
			return Array(entry.todos.prefix(2))
		default:
			return Array(entry.todos.prefix(4))
		}
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			HStack(alignment: .top) {
				VStack(alignment: .leading, spacing: 2) {
					Text("Todos")
						.font(.system(size: 16, weight: .semibold, design: .rounded))
						.foregroundStyle(.white)
					Text("\(entry.todos.count) upcoming")
						.font(.system(size: 12, weight: .medium, design: .rounded))
						.foregroundStyle(.white.opacity(0.7))
				}

				Spacer()

				Link(destination: AppConfig.addTodoURL) {
					Image(systemName: "plus")
						.font(.system(size: 14, weight: .bold))
						.foregroundStyle(.black.opacity(0.92))
						.frame(width: 30, height: 30)
						.background(Color.white, in: Circle())
				}
			}

			if displayedTodos.isEmpty {
				Spacer(minLength: 0)
				Text("No upcoming todos")
					.font(.system(size: 13, weight: .medium, design: .rounded))
					.foregroundStyle(.white.opacity(0.78))
				Spacer(minLength: 0)
			} else {
				ForEach(displayedTodos) { todo in
					HStack(spacing: 8) {
						Circle()
							.fill(Color.white.opacity(0.9))
							.frame(width: 6, height: 6)
						Text(todo.title)
							.font(.system(size: 13, weight: .semibold, design: .rounded))
							.foregroundStyle(.white)
							.lineLimit(1)
					}
				}
				Spacer(minLength: 0)
			}
		}
		.padding(16)
		.containerBackground(for: .widget) {
			LinearGradient(
				colors: [
					Color.black,
					Color(white: 0.18)
				],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
		}
	}
}

