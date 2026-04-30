import Foundation
import SwiftUI

@MainActor
final class TodoStore: ObservableObject {
	@Published private(set) var todos: [Todo] = []

	private let fileURL: URL

	init(filename: String = "todos.json") {
		let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		self.fileURL = documents.appendingPathComponent(filename)
		load()
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
		guard let data = try? Data(contentsOf: fileURL) else { return }
		do {
			todos = try JSONDecoder().decode([Todo].self, from: data)
		} catch {
			// If decoding fails, keep an empty list (avoid crashing).
			todos = []
		}
	}

	private func save() {
		do {
			let data = try JSONEncoder().encode(todos)
			try data.write(to: fileURL, options: [.atomic])
		} catch {
			// Best-effort persistence: ignore write failures.
		}
	}
}

