import SwiftUI
import Combine

struct AddTodoView: View {
    @StateObject
    private var viewModel = ViewModel()
    @State
    private var title: String = ""
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter A Title Here", text: $title)
                }

                Section {
                    Button(action: {
                        viewModel.addTodo(title: title)
                    }) {
                        if viewModel.loading {
                            ProgressView()
                        } else {
                            Text("Submit")
                        }
                    }
                    .disabled(title.isEmpty && !viewModel.loading)
                }
            }
            .navigationBarTitle("Add Todo", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        viewModel.cancelTapped()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            .handleNavigation($viewModel.navigationDirection)
        }

    }
}

extension AddTodoView {
    class ViewModel: ObservableObject {
        private var todoRepository = TodoRepository.shared
        private var cancellables = Set<AnyCancellable>()
        @Published
        var navigationDirection: NavigationDirection?
        @Published
        var loading: Bool = false

        func addTodo(title: String) {
            loading = true
            todoRepository.addTodo(title: title)
                .sink { [unowned self] _ in
                    navigationDirection = .back
                }
                .store(in: &cancellables)
        }

        func cancelTapped() {
            navigationDirection = .back
        }
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
