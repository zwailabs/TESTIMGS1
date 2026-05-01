import SwiftUI

struct TodoRow: View {
	let todo: Todo
	let onToggle: () -> Void
	let onDelete: () -> Void

	var body: some View {
		HStack(spacing: 12) {
			Button(action: onToggle) {
				ZStack {
					RoundedRectangle(cornerRadius: 8, style: .continuous)
						.stroke(todo.isDone ? Theme.strokeStrong : Theme.stroke, lineWidth: 1)
						.frame(width: 28, height: 28)
						.background(todo.isDone ? Theme.textPrimary.opacity(0.16) : Color.white.opacity(0.04))
						.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
					if todo.isDone {
						Image(systemName: "checkmark")
							.font(.system(size: 12, weight: .bold))
							.foregroundStyle(Theme.icon)
					}
				}
			}
			.buttonStyle(.plain)
			.accessibilityLabel(todo.isDone ? "Mark as not done" : "Mark as done")

			Text(todo.title)
				.font(.system(size: 16, weight: .semibold, design: .rounded))
				.foregroundStyle(todo.isDone ? Theme.textTertiary : Theme.textPrimary)
				.strikethrough(todo.isDone, color: Theme.textTertiary)
				.lineLimit(2)

			Spacer(minLength: 8)

			Button(action: onDelete) {
				Image(systemName: "trash")
					.font(.system(size: 14, weight: .semibold))
					.foregroundStyle(Theme.iconMuted)
					.frame(width: 30, height: 30)
					.glassCard(cornerRadius: 10, interactive: true)
			}
			.buttonStyle(.plain)
			.accessibilityLabel("Delete")
		}
		.padding(14)
		.glassCard(cornerRadius: 22, tint: .white.opacity(0.06))
	}
}
