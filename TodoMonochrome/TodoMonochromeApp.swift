import SwiftUI

@main
struct TodoMonochromeApp: App {
	@StateObject private var router = AppRouter()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(router)
				.tint(Theme.textPrimary)
				.preferredColorScheme(.dark)
				.onOpenURL { url in
					router.handle(url: url)
				}
		}
	}
}
