import SwiftUI

struct SearchBar: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack {
            Text("URL:")
                .fontWeight(.bold)

            TextField("Enter URL", text: $viewModel.urlString)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .submitLabel(.go)
                .onSubmit {
                    viewModel.loadURL()
                }
        }
        .padding(.horizontal)
    }
}

#Preview {
    SearchBar(viewModel: ViewModel())
}
