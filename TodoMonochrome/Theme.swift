import SwiftUI

enum Theme {
	static let bg = Color(white: 0.03)
	static let bgElevated = Color.white.opacity(0.08)
	static let card = Color.white.opacity(0.09)
	static let stroke = Color.white.opacity(0.14)
	static let strokeStrong = Color.white.opacity(0.26)
	static let glassFill = Color.white.opacity(0.07)
	static let glassHighlight = Color.white.opacity(0.18)
	static let glassShadow = Color.black.opacity(0.42)
	static let textPrimary = Color.white
	static let textSecondary = Color(white: 0.72)
	static let textTertiary = Color(white: 0.55)
	static let icon = Color(white: 0.90)
	static let iconMuted = Color(white: 0.55)
	static let shadow = Color.black.opacity(0.55)
}

struct AppBackground: View {
	var body: some View {
		ZStack {
			LinearGradient(
				colors: [
					Color(white: 0.02),
					Color(white: 0.06),
					Color(white: 0.035)
				],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)

			Circle()
				.fill(Color.white.opacity(0.14))
				.frame(width: 260, height: 260)
				.blur(radius: 70)
				offset(x: -130, y: -240)

			Circle()
				.fill(Color.white.opacity(0.09))
				.frame(width: 220, height: 220)
				.blur(radius: 64)
				offset(x: 150, y: -110)

			Circle()
				.fill(Color.white.opacity(0.08))
				.frame(width: 240, height: 240)
				.blur(radius: 76)
				offset(x: 120, y: 280)
		}
		.ignoresSafeArea()
	}
}

struct GlassCardModifier: ViewModifier {
	var cornerRadius: CGFloat

	func body(content: Content) -> some View {
		content
			.background(
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
					.fill(
						LinearGradient(
							colors: [
								Color.white.opacity(0.16),
								Color.white.opacity(0.08),
								Color.black.opacity(0.10)
							],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
					)
			)
			.overlay(
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
					.strokeBorder(Theme.strokeStrong, lineWidth: 0.8)
			)
			.overlay(alignment: .top) {
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
					.stroke(
						LinearGradient(
							colors: [Color.white.opacity(0.34), .clear],
							startPoint: .top,
							endPoint: .center
						),
						lineWidth: 0.9
					)
					.blur(radius: 0.2)
			}
			.overlay(alignment: .bottomTrailing) {
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
					.stroke(
						LinearGradient(
							colors: [.clear, Color.black.opacity(0.18)],
							startPoint: .center,
							endPoint: .bottomTrailing
						),
						lineWidth: 1
					)
			}
			.shadow(color: Theme.glassShadow, radius: 20, x: 0, y: 10)
	}
}

extension View {
	func glassCard(cornerRadius: CGFloat) -> some View {
		modifier(GlassCardModifier(cornerRadius: cornerRadius))
	}
}
