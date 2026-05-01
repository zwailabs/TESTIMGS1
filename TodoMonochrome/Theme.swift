import SwiftUI

enum Theme {
	static let bg = Color(white: 0.03)
	static let bgElevated = Color.white.opacity(0.08)
	static let card = Color.white.opacity(0.09)
	static let stroke = Color.white.opacity(0.14)
	static let strokeStrong = Color.white.opacity(0.26)
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
		LinearGradient(
			colors: [
				Color(white: 0.015),
				Color(white: 0.055),
				Color(white: 0.025)
			],
			startPoint: .topLeading,
			endPoint: .bottomTrailing
		)
		.ignoresSafeArea()
	}
}

struct GlassGroup<Content: View>: View {
	let spacing: CGFloat?
	let content: Content

	init(spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
		self.spacing = spacing
		self.content = content()
	}

	var body: some View {
		if #available(iOS 26.0, *) {
			GlassEffectContainer(spacing: spacing) {
				content
			}
		} else {
			content
		}
	}
}

struct GlassCardModifier: ViewModifier {
	@Environment(\.accessibilityReduceTransparency) private var reduceTransparency

	var cornerRadius: CGFloat
	var tint: Color?
	var interactive: Bool

	func body(content: Content) -> some View {
		if reduceTransparency {
			content
				.background(Theme.card, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
				.overlay(
					RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
						.stroke(Theme.stroke, lineWidth: 1)
				)
		} else if #available(iOS 26.0, *) {
			content
				.glassEffect(makeGlass(), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
		} else {
			content
				.background(Theme.card, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
				.overlay(
					RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
						.stroke(Theme.strokeStrong, lineWidth: 1)
				)
				.overlay(alignment: .top) {
					RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
						.stroke(
							LinearGradient(
								colors: [Color.white.opacity(0.22), .clear],
								startPoint: .top,
								endPoint: .center
							),
							lineWidth: 0.6
						)
				}
				.shadow(color: Theme.glassShadow, radius: 10, x: 0, y: 5)
		}
	}

	@available(iOS 26.0, *)
	private func makeGlass() -> Glass {
		var glass = Glass.regular
		if let tint {
			glass = glass.tint(tint)
		}
		if interactive {
			glass = glass.interactive(true)
		}
		return glass
	}
}

extension View {
	func glassCard(cornerRadius: CGFloat, tint: Color? = nil, interactive: Bool = false) -> some View {
		modifier(GlassCardModifier(cornerRadius: cornerRadius, tint: tint, interactive: interactive))
	}
}
