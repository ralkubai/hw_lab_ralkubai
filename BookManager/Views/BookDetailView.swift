import SwiftUI

struct BookDetailView: View {
    var book: Book

    var body: some View {
        VStack {
            Text(book.title)
                .font(.title)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .padding([.top], 40)
            Text("Author: \(book.author)")
                .font(.title3)
                .fontWeight(.bold)
                .padding(5)
            Text("Author Gender: \(book.gender)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .padding(20)

            Spacer() // To force the content to the top
        }
        .navigationTitle("Book Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        BookDetailView(book: Book(title: "Emma", author: "Jane Austen", gender: "Female", displayed: true))
    }
}
