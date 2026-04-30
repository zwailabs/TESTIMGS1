import SwiftUI

struct AddTodoView: View {
	@Environment(\.dismiss) private var dismiss
	@State private var title: String = ""
	@FocusState private var isFocused: Bool

	let onAdd: (String) -> Void

	var body: some View {
		ZStack {
			AppBackground()
			VStack(alignment: .leading, spacing: 14) {
				HStack {
					Text("New Todo")
						.font(.system(size: 22, weight: .semibold, design: .rounded))
						.foregroundStyle(Theme.textPrimary)
					Spacer()
					Button("Cancel") { dismiss() }
						.font(.system(size: 15, weight: .semibold, design: .rounded))
						.foregroundStyle(Theme.textSecondary)
				}

				VStack(spacing: 10) {
					TextField("What do you need to do?", text: $title)
						.focused($isFocused)
						.textInputAutocapitalization(.sentences)
						.autocorrectionDisabled(false)
						.submitLabel(.done)
						.onSubmit(addAndDismiss)
						.font(.system(size: 16, weight: .semibold, design: .rounded))
						.foregroundStyle(Theme.textPrimary)
						.padding(.horizontal, 12)
						.padding(.vertical, 12)
						.glassCard(cornerRadius: 18)

					Button(action: addAndDismiss) {
						Text("Add")
							.frame(maxWidth: .infinity)
							.font(.system(size: 16, weight: .semibold, design: .rounded))
							.foregroundStyle(Color.black.opacity(0.92))
							.padding(.vertical, 12)
							.background(
								LinearGradient(
									colors: [
										Color.white.opacity(0.95),
										Color.white.opacity(0.72)
									],
									startPoint: .topLeading,
									endPoint: .bottomTrailing
								),
								in: RoundedRectangle(cornerRadius: 18, style: .continuous)
							)
							.overlay(
								RoundedRectangle(cornerRadius: 18, style: .continuous)
									.stroke(Color.white.opacity(0.24), lineWidth: 1)
							)
							.shadow(color: Color.white.opacity(0.14), radius: 12, x: 0, y: 3)
					}
					.disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
					.opacity(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.45 : 1.0)
				}

				Spacer()
			}
			.padding(16)
			.glassCard(cornerRadius: 28)
			.padding(12)
		}
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				isFocused = true
			}
		}
	}

	private func addAndDismiss() {
		onAdd(title)
		dismiss()
	}
}
