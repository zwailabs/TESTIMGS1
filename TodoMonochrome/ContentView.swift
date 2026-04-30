import SwiftUI

struct ContentView: View {
	@StateObject private var store = TodoStore()
	@State private var isPresentingAdd = false

	var body: some View {
		NavigationStack {
			ZStack {
				Theme.bg.ignoresSafeArea()
				ScrollView {
					LazyVStack(spacing: 12) {
						header
						if store.todos.isEmpty {
							emptyState
						} else {
							todoList
						}
					}
					.padding(.horizontal, 16)
					.padding(.top, 12)
					.padding(.bottom, 28)
				}
			}
			.navigationTitle("")
			.navigationBarTitleDisplayMode(.inline)
			.toolbarBackground(Theme.bg, for: .navigationBar)
			.toolbarColorScheme(.dark, for: .navigationBar)
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Text("Todos")
						.font(.system(size: 28, weight: .semibold, design: .rounded))
						.foregroundStyle(Theme.textPrimary)
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						isPresentingAdd = true
					} label: {
						Image(systemName: "plus")
							.font(.system(size: 16, weight: .semibold))
							.foregroundStyle(Theme.textPrimary)
							.frame(width: 36, height: 36)
							.background(Theme.bgElevated)
							.overlay(
								RoundedRectangle(cornerRadius: 12, style: .continuous)
									.stroke(Theme.stroke, lineWidth: 1)
							)
							.clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
					}
					.accessibilityLabel("Add Todo")
				}
			}
			.sheet(isPresented: $isPresentingAdd) {
				AddTodoView { title in
					withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
						store.add(title: title)
					}
				}
				.presentationDetents([.height(280), .medium])
				.presentationDragIndicator(.visible)
			}
		}
	}

	private var header: some View {
		HStack(alignment: .firstTextBaseline) {
			Text("\(store.remainingCount) left")
				.font(.system(size: 14, weight: .semibold, design: .rounded))
				.foregroundStyle(Theme.textSecondary)
				.padding(.horizontal, 12)
				.padding(.vertical, 8)
				.background(Theme.bgElevated)
				.overlay(
					RoundedRectangle(cornerRadius: 999, style: .continuous)
						.stroke(Theme.stroke, lineWidth: 1)
				)
				.clipShape(RoundedRectangle(cornerRadius: 999, style: .continuous))

			Spacer()

			if store.todos.contains(where: { $0.isDone }) {
				Button {
					withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
						store.clearCompleted()
					}
				} label: {
					Text("Clear completed")
						.font(.system(size: 14, weight: .semibold, design: .rounded))
						.foregroundStyle(Theme.textPrimary)
						.padding(.horizontal, 12)
						.padding(.vertical, 8)
						.background(Theme.bgElevated)
						.overlay(
							RoundedRectangle(cornerRadius: 999, style: .continuous)
								.stroke(Theme.stroke, lineWidth: 1)
						)
						.clipShape(RoundedRectangle(cornerRadius: 999, style: .continuous))
				}
			}
		}
	}

	private var todoList: some View {
		ForEach(store.todos) { todo in
			TodoRow(
				todo: todo,
				onToggle: {
					withAnimation(.spring(response: 0.30, dampingFraction: 0.9)) {
						store.toggle(todo)
					}
				},
				onDelete: {
					withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
						store.delete(todo)
					}
				}
			)
		}
	}

	private var emptyState: some View {
		VStack(spacing: 10) {
			Image(systemName: "checklist")
				.font(.system(size: 28, weight: .semibold))
				.foregroundStyle(Theme.iconMuted)
				.padding(.top, 10)

			Text("No todos yet")
				.font(.system(size: 18, weight: .semibold, design: .rounded))
				.foregroundStyle(Theme.textPrimary)

			Text("Tap + to add your first task.")
				.font(.system(size: 14, weight: .medium, design: .rounded))
				.foregroundStyle(Theme.textSecondary)
		}
		.frame(maxWidth: .infinity)
		.padding(18)
		.background(Theme.card)
		.overlay(
			RoundedRectangle(cornerRadius: 18, style: .continuous)
				.stroke(Theme.stroke, lineWidth: 1)
		)
		.clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
		.shadow(color: Theme.shadow, radius: 16, x: 0, y: 8)
	}
}
