import SwiftUI

struct BottomBar: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack {
            Spacer()

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
        .font(.title3)
        .padding(.vertical, 8)
    }
}

#Preview {
    BottomBar(viewModel: ViewModel())
}
