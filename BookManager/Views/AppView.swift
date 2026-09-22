import SwiftUI

struct AppView: View {
    @StateObject private var library = Library()

    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Library")
                }

            NewBookView()
                .tabItem {
                    Image(systemName: "rectangle.stack.badge.plus")
                    Text("New Book")
                }

            ChartsView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Charts")
                }
        } //end braces of TabView()
        .environmentObject(library)
    }
}

#Preview {
    AppView()
}
