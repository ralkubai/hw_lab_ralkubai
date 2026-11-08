//
//  Coordinator.swift
//  EmojiHunter
//
//  Bridges UIKit → SwiftUI: receives the camera's delegate callback and updates the binding.
//

import Foundation
import SwiftUI

class Coordinator: NSObject, EmojiFoundDelegate {
    @Binding var emojiFound: EmojiSearch   // Points at GameViewModel.emojiStatus

    /// Stores the binding. `_emojiFound` sets the property wrapper's storage directly.
    init(emojiFound: Binding<EmojiSearch>) {
        _emojiFound = emojiFound
    }

    /// Called by CameraViewController when the target is recognised; marks the round as found.
    func emojiWasFound(result: Bool) {
        print("emojiWasFound \(result)")
        emojiFound = .found
    }
}
