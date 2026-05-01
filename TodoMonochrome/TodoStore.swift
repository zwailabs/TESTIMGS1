import Foundation
import SwiftUI

#if canImport(WidgetKit)
import WidgetKit
#endif

@MainActor
final class TodoStore: ObservableObject {
	@Published private(set) var todos: [Todo] = []

	init() {
		todos = TodoStorage.load()
	}

	var remainingCount: Int {
		todos.filter { !$0.isDone }.count
	}

	func add(title: String) {
		let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmed.isEmpty else { return }
		todos.insert(Todo(title: trimmed), at: 0)
		save()
	}

	func toggle(_ todo: Todo) {
		guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }
		todos[index].isDone.toggle()
		save()
	}

	func delete(_ todo: Todo) {
		todos.removeAll { $0.id == todo.id }
		save()
	}

	func clearCompleted() {
		todos.removeAll { $0.isDone }
		save()
	}

	private func load() {
		todos = TodoStorage.load()
	}

	private func save() {
		TodoStorage.save(todos)
		reloadWidgets()
	}

	private func reloadWidgets() {
		#if canImport(WidgetKit)
		if #available(iOS 14.0, *) {
			WidgetCenter.shared.reloadAllTimelines()
		}
		#endif
	}
}
