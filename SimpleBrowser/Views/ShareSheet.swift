import SwiftUI
import UIKit

// UIActivityViewController is the standard iOS share sheet (Messages, Mail,
// Copy, and so on). Like WKWebView it is UIKit, so it needs a wrapper before
// SwiftUI can present it. This one wraps a view controller rather than a view,
// so it uses UIViewControllerRepresentable instead of UIViewRepresentable.
struct ShareSheet: UIViewControllerRepresentable {

    // Whatever we want to share. Here it is the current URL string.
    var activityItems: [Any]

    // Optional custom actions. Nil means just the system defaults.
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems,
                                 applicationActivities: applicationActivities)
    }

    // Nothing to update: the sheet is built fresh each time it is presented.
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
