import SwiftUI

struct TodoDetailsView: View {
    let todo: Todo
    var body: some View {
        Text("Todo details for \(todo.title)")
            .font(.title)
            .navigationBarTitle("Todo Details", displayMode: .inline)
    }
}

struct TodoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailsView(todo: Todo(title: "Preview Todo"))
    }
}
