import SwiftUI

struct ContentView: View {
	@StateObject private var store = TodoStore()
	@State private var isPresentingAdd = false

	var body: some View {
		NavigationStack {
			ZStack {
				AppBackground()
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
							.glassCard(cornerRadius: 12)
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
				.glassCard(cornerRadius: 999)

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
						.glassCard(cornerRadius: 999)
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
				.foregroundStyle(Theme.icon)
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
		.glassCard(cornerRadius: 24)
	}
}
