import SwiftUI
import WebKit
import Combine

struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: ViewModel

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator

        if let url = URL(string: viewModel.loadedURLString) {
            webView.load(URLRequest(url: url))
        }

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: viewModel.loadedURLString),
              webView.url != url else { return }
        webView.load(URLRequest(url: url))
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var cancellable: AnyCancellable?

        init(_ parent: WebView) {
            self.parent = parent
        }

        deinit {
            cancellable?.cancel()
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            //assigning replaces any previous subscription, so we never stack duplicates
            cancellable = parent.viewModel.webViewOptionsPublisher.sink { [weak self] option in
                switch option {
                case .back:
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
                    self?.parent.viewModel.shouldShowShareSheet = true
                }
            }
        }

        //keep the search bar showing the page we are actually on
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let current = webView.url?.absoluteString {
                parent.viewModel.urlString = current
                parent.viewModel.loadedURLString = current
            }
        }
    }
}
