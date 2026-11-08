//
//  CustomCameraRepresentable.swift
//  EmojiHunter
//
//  Wraps the UIKit CameraViewController so it can be used inside SwiftUI.
//

import Foundation
import SwiftUI

struct CustomCameraRepresentable: UIViewControllerRepresentable {

    var emojiString: String                  // MobileNetV2 label text to look for
    @Binding var emojiFound: EmojiSearch     // Two-way link to the view model's emojiStatus

    /// Creates the camera controller once and connects its delegate to our Coordinator.
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController(emoji: emojiString)
        controller.delegate = context.coordinator
        return controller
    }

    /// Required by the protocol; nothing to update because a new controller is made for each emoji.
    func updateUIViewController(_ cameraViewController: CameraViewController, context: Context) {}

    /// Creates the Coordinator that receives "found" events and writes them back through the binding.
    func makeCoordinator() -> Coordinator {
        Coordinator(emojiFound: $emojiFound)
    }
}
