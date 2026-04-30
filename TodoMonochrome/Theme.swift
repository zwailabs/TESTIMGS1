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

			RadialGradient(
				colors: [
					Color.white.opacity(0.15),
					Color.white.opacity(0.04),
					.clear
				],
				center: .topLeading,
				startRadius: 20,
				endRadius: 340
			)
			.offset(x: -60, y: -90)

			RadialGradient(
				colors: [
					Color.white.opacity(0.09),
					Color.white.opacity(0.03),
					.clear
				],
				center: .bottomTrailing,
				startRadius: 30,
				endRadius: 300
			)
			.offset(x: 60, y: 140)
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
			.overlay {
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
					.fill(Color.white.opacity(0.025))
			}
			.overlay(
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
					.strokeBorder(Theme.strokeStrong, lineWidth: 0.75)
			)
			.overlay(alignment: .top) {
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
					.stroke(
						LinearGradient(
							colors: [Color.white.opacity(0.34), .clear],
							startPoint: .top,
							endPoint: .center
						),
						lineWidth: 0.7
					)
			}
			.overlay(alignment: .bottomTrailing) {
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
					.stroke(
						LinearGradient(
							colors: [.clear, Color.black.opacity(0.18)],
							startPoint: .center,
							endPoint: .bottomTrailing
						),
						lineWidth: 0.8
					)
			}
			.shadow(color: Theme.glassShadow, radius: 12, x: 0, y: 6)
	}
}

extension View {
	func glassCard(cornerRadius: CGFloat) -> some View {
		modifier(GlassCardModifier(cornerRadius: cornerRadius))
	}
}
