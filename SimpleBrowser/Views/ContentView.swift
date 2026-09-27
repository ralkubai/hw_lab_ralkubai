import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack {
            SearchBar(viewModel: viewModel)

            WebView(viewModel: viewModel)

            BottomBar(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.shouldShowShareSheet) {
            ShareSheet(activityItems: [viewModel.loadedURLString])
        }
    }
}

#Preview {
    ContentView()
}
