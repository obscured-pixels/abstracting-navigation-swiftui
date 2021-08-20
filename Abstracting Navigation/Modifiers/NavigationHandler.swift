import Combine
import SwiftUI

struct NavigationHandler: ViewModifier {
    @Binding
    var navigationDirection: NavigationDirection?
    var onDismiss: ((NavigationDestination) -> Void)?
    @State
    private var destination: NavigationDestination?
    @State
    private var sheetActive = false
    @State
    private var linkActive = false
    @Environment(\.presentationMode) var presentation
    let viewFactory = ViewFactory()
    func body(content: Content) -> some View {
        content
            .background(
                EmptyView()
                    .sheet(isPresented: $sheetActive, onDismiss: {
                        if let destination = destination {
                            onDismiss?(destination)
                        }
                    }) {
                        buildDestination(destination)
                    }
            )
            .background(
                NavigationLink(destination: buildDestination(destination), isActive: $linkActive) {
                    EmptyView()
                }
            )
            .onChange(of: navigationDirection, perform: { direction in
                switch direction {
                case .forward(let destination, let style):
                    self.destination = destination
                    switch style {
                    case .present:
                        sheetActive = true
                    case .push:
                        linkActive = true
                    }
                case .back:
                    presentation.wrappedValue.dismiss()
                case .none:
                    break
                }
                navigationDirection = nil
            })
    }

    @ViewBuilder
    private func buildDestination(_ destination: NavigationDestination?) -> some View {
        if let destination = destination {
            viewFactory.makeView(destination)
        } else {
            EmptyView()
        }
    }
}

extension View {
    func handleNavigation(_ navigationDirection: Binding<NavigationDirection?>,
                          onDismiss: ((NavigationDestination) -> Void)? = nil) -> some View {
        self.modifier(NavigationHandler(navigationDirection: navigationDirection,
                                        onDismiss: onDismiss))
    }
}
