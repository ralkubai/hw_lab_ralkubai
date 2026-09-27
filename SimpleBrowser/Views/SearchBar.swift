import SwiftUI

struct SearchBar: View {

    // Passed in from ContentView. @ObservedObject (not @StateObject) because
    // this view is using an object someone else owns.
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack {
            Text("URL:")
                .fontWeight(.bold)

            // The $ creates a binding, so typing updates viewModel.urlString directly.
            TextField("Enter URL", text: $viewModel.urlString)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.URL)                 // keyboard with . and / keys
                .textInputAutocapitalization(.never) // URLs are lowercase
                .autocorrectionDisabled(true)        // stop autocorrect mangling domains
                .submitLabel(.go)                    // return key reads "Go"
                .onSubmit {
                    // Only load once the user commits, otherwise the web view
                    // would try to load a new URL on every single keystroke.
                    viewModel.loadURL()
                }
        }
        .padding(.horizontal)
    }
}

#Preview {
    SearchBar(viewModel: ViewModel())
}
