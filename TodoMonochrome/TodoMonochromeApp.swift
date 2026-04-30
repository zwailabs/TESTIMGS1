import SwiftUI

@main
struct TodoMonochromeApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.tint(Theme.textPrimary)
				.preferredColorScheme(.dark)
		}
	}
}
