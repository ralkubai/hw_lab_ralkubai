
import SwiftUI

struct ContentView: View {

    // @StateObject means this view owns the ViewModel and SwiftUI keeps the same
    // instance alive across redraws. The child views take it as @ObservedObject
    // instead, since they are handed an object that already exists.
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        // The three pieces stack vertically: search bar on top, web view filling
        // the middle, buttons at the bottom.
        VStack {
            SearchBar(viewModel: viewModel)

            WebView(viewModel: viewModel)

            BottomBar(viewModel: viewModel)
        }
        // Presents the iOS share sheet whenever shouldShowShareSheet becomes true.
        // The $ makes it a two-way binding so dismissing the sheet sets it back to false.
        .sheet(isPresented: $viewModel.shouldShowShareSheet) {
            ShareSheet(activityItems: [viewModel.loadedURLString])
        }
    }
}

#Preview {
    ContentView()
}
