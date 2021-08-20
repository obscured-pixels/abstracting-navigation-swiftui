import Foundation
import Combine

struct Todo: Identifiable {
    let id: UUID = UUID()
    let title: String
}

class TodoRepository: ObservableObject {

    static let shared = TodoRepository()

    @Published
    var todos: [Todo] = []

    func addTodo(title: String) -> AnyPublisher<Void, Never> {
        // Simulate an async request
        Deferred { [unowned self] in
            Future { promise in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    todos.append(Todo(title: title))
                    promise(.success(()))
                }

            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func delete(indexSet: IndexSet) {
        indexSet.forEach { index in
            todos.remove(at: index)
        }
    }
}
