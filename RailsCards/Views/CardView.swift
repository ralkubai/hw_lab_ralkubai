import SwiftUI

struct CardView: View {
    @State private var viewModel = CardViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink(destination: DefinitionView(viewModel: viewModel)) {
                    Text(viewModel.flashcard.command)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .frame(width: 350, height: 200)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0).stroke(Color.gray)
            )
            .onAppear {
                viewModel.drawNewCard()
            }
        }
    }
}

#Preview {
    CardView()
}
