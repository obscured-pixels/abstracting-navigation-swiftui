import Foundation
import SwiftUI

class ViewFactory {

    @ViewBuilder
    func makeView(_ destination: NavigationDestination) -> some View {
        switch destination {
        case .todoList:
            TodoListView()
        case .addTodo:
            AddTodoView()
        case .todoDetails(let todo):
            TodoDetailsView(todo: todo)
        }
    }
}
