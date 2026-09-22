import SwiftUI
import Charts

struct ChartsView: View {
    @EnvironmentObject var library: Library

    var body: some View {
        VStack {
            Text("Books by Author Gender")
                .font(.headline)

            Chart {
                BarMark(
                    x: .value("Mount", "Male"),
                    y: .value("Value", library.getMaleAuthoredBooks().count)
                )
                BarMark(
                    x: .value("Mount", "Female"),
                    y: .value("Value", library.getFemaleAuthoredBooks().count)
                )
                .foregroundStyle(.pink)
            }
            .frame(height: 250)
            .padding(20)

            Text("Books by Popular Authors")
                .font(.headline)

            Chart {
                BarMark(
                    x: .value("Mount", "Shakespeare"),
                    y: .value("Value", library.getBooksFor("William Shakespeare").count)
                )
                .foregroundStyle(.green)
                BarMark(
                    x: .value("Mount", "Tolkien"),
                    y: .value("Value", library.getBooksFor("J.R.R. Tolkien").count)
                )
                .foregroundStyle(.green)
                BarMark(
                    x: .value("Mount", "Austen"),
                    y: .value("Value", library.getBooksFor("Jane Austen").count)
                )
                .foregroundStyle(.green)
                BarMark(
                    x: .value("Mount", "Dickens"),
                    y: .value("Value", library.getBooksFor("Charles Dickens").count)
                )
                .foregroundStyle(.green)
                BarMark(
                    x: .value("Mount", "Bronte"),
                    y: .value("Value", library.getBooksFor("Charlotte Bronte").count)
                )
                .foregroundStyle(.green)
            }
            .frame(height: 250)
            .padding(20)

            Spacer() // To push the charts to the top instead of centering
        }
        .padding()
    }
}

#Preview {
    ChartsView()
        .environmentObject(Library())
}
