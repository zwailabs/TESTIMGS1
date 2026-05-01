import Foundation

@MainActor
final class AppRouter: ObservableObject {
	@Published var shouldPresentAddTodo = false

	func handle(url: URL) {
		guard url.scheme == "todomonochrome" else { return }
		if url.host == "add" {
			shouldPresentAddTodo = true
		}
	}
}

