import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var library: Library

    var body: some View {
        NavigationStack {
            List {
                ForEach(library.books) { book in
                    BookRowView(book: book)
                }
                .onDelete(perform: removeRows)
            }
            .navigationTitle("Library")
        }
    }

    func removeRows(at offsets: IndexSet) {
        library.books.remove(atOffsets: offsets)
    }
}

#Preview {
    LibraryView()
        .environmentObject(Library())
}
