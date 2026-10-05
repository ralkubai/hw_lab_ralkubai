//
//  WebView.swift
//  SwiftRepos
//
//  SwiftUI wrapper around UIKit's WKWebView to show a repo's GitHub page.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL   // Page to load

    // Called once to create the underlying UIKit view
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    // Called whenever SwiftUI state changes; (re)loads the current URL
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }
}
