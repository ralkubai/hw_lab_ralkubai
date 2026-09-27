import Foundation
import Combine

//options for the web view buttons
enum WebViewOptions {
    case back
    case forward
    case share
    case refresh
    case stop
}

class ViewModel: ObservableObject {

    @Published var urlString: String = "https://www.apple.com"
    @Published var loadedURLString: String = "https://www.apple.com"
    @Published var webViewOptionsPublisher = PassthroughSubject<WebViewOptions, Never>()
    @Published var shouldShowShareSheet: Bool = false

    //called when the user submits the text field
    func loadURL() {
        var text = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        if !text.lowercased().hasPrefix("http://") && !text.lowercased().hasPrefix("https://") {
            text = "https://" + text
        }

        urlString = text
        loadedURLString = text
    }

    // MARK: button actions
    func goBack() {
        webViewOptionsPublisher.send(.back)
    }

    func goForward() {
        webViewOptionsPublisher.send(.forward)
    }

    func share() {
        webViewOptionsPublisher.send(.share)
    }

    func refresh() {
        webViewOptionsPublisher.send(.refresh)
    }

    func stop() {
        webViewOptionsPublisher.send(.stop)
    }
}
