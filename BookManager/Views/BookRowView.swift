import SwiftUI

struct BookRowView: View {
    var book: Book

    var body: some View {
        NavigationLink(
            destination: BookDetailView(book: book),
            label: {
                Text(book.title)
                    .fontWeight(.bold)
                    .font(.body)
            })
    }
}

#Preview {
    NavigationStack {
        List {
            BookRowView(book: Book(title: "Emma", author: "Jane Austen", gender: "Female", displayed: true))
        }
    }
}
