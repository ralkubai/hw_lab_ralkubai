import Foundation
import Combine

// The set of actions the bottom bar can ask the web view to perform.
// Using an enum instead of separate booleans keeps the list of options fixed
// and lets the Coordinator handle them all in one switch statement.
enum WebViewOptions {
    case back
    case forward
    case share
    case refresh
    case stop
}

// ObservableObject lets SwiftUI views subscribe to this class, so any view
// reading a @Published property redraws when that property changes.
class ViewModel: ObservableObject {

    // What is currently typed in the search bar. Changes on every keystroke.
    @Published var urlString: String = "https://www.apple.com"

    // The URL the web view has actually been told to load. Kept separate from
    // urlString so the page only loads when the user submits, not as they type.
    @Published var loadedURLString: String = "https://www.apple.com"

    // The bottom bar buttons don't touch the web view directly, because the
    // WKWebView is created inside WebView and isn't visible from here.
    // Instead the buttons send an option through this publisher and the
    // Coordinator, which does hold the web view, listens and acts on it.
    @Published var webViewOptionsPublisher = PassthroughSubject<WebViewOptions, Never>()

    // Drives the .sheet modifier in ContentView. Set to true by the Coordinator
    // when a .share option comes through; SwiftUI sets it back to false on dismiss.
    @Published var shouldShowShareSheet: Bool = false

    // Called when the user presses Go on the keyboard.
    func loadURL() {
        var text = urlString.trimmingCharacters(in: .whitespacesAndNewlines)

        // Nothing to load if the field is empty.
        guard !text.isEmpty else { return }

        // WKWebView needs a scheme, so "apple.com" alone would fail. Add one if missing.
        if !text.lowercased().hasPrefix("http://") && !text.lowercased().hasPrefix("https://") {
            text = "https://" + text
        }

        urlString = text

        // Changing this is what actually triggers the load, because WebView's
        // updateUIView runs whenever a published property it reads changes.
        loadedURLString = text
    }

    // MARK: button actions
    // Each of these just publishes an option; the Coordinator does the work.

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
