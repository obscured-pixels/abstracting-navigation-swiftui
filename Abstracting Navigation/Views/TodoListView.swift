import SwiftUI

struct TodoListView: View {
    @StateObject
    private var viewModel = ViewModel()
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(viewModel.todos) { todo in
                        Button(action: {
                            viewModel.todoTapped(todo)
                        }) {
                            HStack(spacing: 0) {
                                Text(todo.title)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .imageScale(.small)
                                    .foregroundColor(.secondary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .onDelete(perform: viewModel.deleteTodos(indexSet:))
                }
                Button(action: {
                    viewModel.addTodoTapped()
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
                .padding([.bottom, .trailing])
            }
            .navigationTitle("Todos")
            .handleNavigation($viewModel.navigationDirection)
        }
    }
}

extension TodoListView {
    class ViewModel: ObservableObject {
        @Published
        var navigationDirection: NavigationDirection?
        @Published
        var todos: [Todo] = []
        private var todoRepository = TodoRepository.shared

        init() {
            todoRepository.$todos
                .assign(to: &$todos)
        }

        func addTodoTapped() {
            navigationDirection = .forward(destination: .addTodo, style: .present)
        }

        func todoTapped(_ todo: Todo) {
            navigationDirection = .forward(destination: .todoDetails(todo: todo), style: .push)
        }

        func deleteTodos(indexSet: IndexSet) {
            todoRepository.delete(indexSet: indexSet)
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
