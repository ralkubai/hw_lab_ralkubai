import SwiftUI
import WebKit
import Combine

// WKWebView is a UIKit view, not a SwiftUI one. UIViewRepresentable is the
// bridge that lets us drop a UIKit view into a SwiftUI layout.
struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: ViewModel

    // Called once, when SwiftUI first creates the view.
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()

        // The Coordinator receives navigation callbacks (load started, finished, failed).
        webView.navigationDelegate = context.coordinator

        // Load the starting page.
        if let url = URL(string: viewModel.loadedURLString) {
            webView.load(URLRequest(url: url))
        }

        return webView
    }

    // Called every time a published property this view reads changes.
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Without this guard we would reload the same page over and over, since
        // didFinish updates loadedURLString, which triggers updateUIView again.
        guard let url = URL(string: viewModel.loadedURLString),
              webView.url != url else { return }

        webView.load(URLRequest(url: url))
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // The Coordinator is the go-between for UIKit and SwiftUI. It conforms to
    // WKNavigationDelegate, which is an Objective-C protocol, so it has to be a
    // class inheriting from NSObject rather than a struct.
    class Coordinator: NSObject, WKNavigationDelegate {

        // A reference back to the struct that created it, so we can reach the ViewModel.
        var parent: WebView

        // Holds the Combine subscription. If this is not stored somewhere, the
        // subscription is released immediately and the buttons stop working.
        var cancellable: AnyCancellable?

        init(_ parent: WebView) {
            self.parent = parent
        }

        deinit {
            // Tidy up the subscription when the Coordinator goes away.
            cancellable?.cancel()
        }

        // Fires each time a page starts loading. This is where we subscribe,
        // because by now we have a reference to the actual web view.
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

            // Assigning to cancellable cancels any earlier subscription first.
            // Without that, every page load would add another subscriber and a
            // single Back tap would fire several times.
            cancellable = parent.viewModel.webViewOptionsPublisher.sink { [weak self] option in

                // [weak self] avoids a retain cycle: the Coordinator holds the
                // subscription, and the closure would otherwise hold the Coordinator.

                switch option {
                case .back:
                    // canGoBack stops us calling goBack with no history.
                    if webView.canGoBack {
                        webView.goBack()
                    }
                case .forward:
                    if webView.canGoForward {
                        webView.goForward()
                    }
                case .refresh:
                    webView.reload()
                case .stop:
                    webView.stopLoading()
                case .share:
                    // Flipping this to true makes ContentView present the share sheet.
                    self?.parent.viewModel.shouldShowShareSheet = true
                }
            }
        }

        // Fires when a page finishes loading. Used to keep the search bar showing
        // the page we are actually on, which matters after Back and Forward.
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let current = webView.url?.absoluteString {
                parent.viewModel.urlString = current
                parent.viewModel.loadedURLString = current
            }
        }
    }
}
