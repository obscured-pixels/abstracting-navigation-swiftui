import Foundation

enum NavigationDestination {
    case todoList
    case addTodo
    case todoDetails(todo: Todo)
}
