import SwiftUI

struct AddTodoView: View {
	@Environment(\.dismiss) private var dismiss
	@State private var title: String = ""
	@FocusState private var isFocused: Bool

	let onAdd: (String) -> Void

	var body: some View {
		ZStack {
			Theme.bg.ignoresSafeArea()
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
						.background(Theme.card)
						.overlay(
							RoundedRectangle(cornerRadius: 14, style: .continuous)
								.stroke(Theme.stroke, lineWidth: 1)
						)
						.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

					Button(action: addAndDismiss) {
						Text("Add")
							.frame(maxWidth: .infinity)
							.font(.system(size: 16, weight: .semibold, design: .rounded))
							.foregroundStyle(Theme.bg)
							.padding(.vertical, 12)
							.background(Theme.textPrimary)
							.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
					}
					.disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
					.opacity(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.45 : 1.0)
				}

				Spacer()
			}
			.padding(16)
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

