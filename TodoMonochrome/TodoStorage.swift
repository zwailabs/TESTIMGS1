import Foundation

#if canImport(WidgetKit)
import WidgetKit
#endif

enum TodoStorage {
	private static let filename = "todos.json"

	static var fileURL: URL {
		let fileManager = FileManager.default
		if let sharedContainer = fileManager.containerURL(forSecurityApplicationGroupIdentifier: AppConfig.appGroupID) {
			return sharedContainer.appendingPathComponent(filename)
		}
		let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
		return documents.appendingPathComponent(filename)
	}

	static func load() -> [Todo] {
		guard let data = try? Data(contentsOf: fileURL) else { return [] }
		do {
			return try JSONDecoder().decode([Todo].self, from: data)
		} catch {
			return []
		}
	}

	static func save(_ todos: [Todo]) {
		do {
			let data = try JSONEncoder().encode(todos)
			try data.write(to: fileURL, options: [.atomic])
			reloadWidgets()
		} catch {
			// Best-effort persistence: ignore write failures.
		}
	}

	static func upcomingTodos(limit: Int) -> [Todo] {
		Array(load().filter { !$0.isDone }.prefix(limit))
	}

	private static func reloadWidgets() {
		#if canImport(WidgetKit)
		if #available(iOS 14.0, *) {
			WidgetCenter.shared.reloadAllTimelines()
		}
		#endif
	}
}

