import SwiftUI

struct BottomBar: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        // Spacers between each button spread them evenly across the width.
        HStack {
            Spacer()

            // Each button calls a ViewModel method, which publishes an option
            // for the WebView's Coordinator to act on. The buttons never touch
            // the web view themselves.
            Button(action: viewModel.goBack) {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Button(action: viewModel.goForward) {
                Image(systemName: "chevron.right")
            }

            Spacer()

            Button(action: viewModel.share) {
                Image(systemName: "square.and.arrow.up")
            }

            Spacer()

            Button(action: viewModel.refresh) {
                Image(systemName: "arrow.clockwise")
            }

            Spacer()

            Button(action: viewModel.stop) {
                Image(systemName: "xmark")
            }

            Spacer()
        }
        .font(.title3)          // applies to every icon in the stack
        .padding(.vertical, 8)
    }
}

#Preview {
    BottomBar(viewModel: ViewModel())
}
