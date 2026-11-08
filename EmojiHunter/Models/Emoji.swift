//
//  Emoji.swift
//  EmojiHunter
//
//  Game data: the emojis to hunt, the search states, and the "found" delegate protocol.
//

import Foundation

// Class-bound (AnyObject) so whoever holds the delegate can keep it as a weak reference.
protocol EmojiFoundDelegate: AnyObject {
    /// Called by the camera when the classifier recognises the target object.
    func emojiWasFound(result: Bool)
}

/// The state of the current round.
enum EmojiSearch {
    case found       // Object recognised in time
    case notFound    // Timer ran out
    case searching   // Round in progress
    case gameOver    // Past the last emoji
}

/// One emoji to hunt.
/// `emojiName` must appear inside MobileNetV2's label for that object
/// (e.g. the label "ballpoint, ballpoint pen, ballpen, Biro" contains "pen").
struct EmojiModel: Identifiable {
    let id = UUID()
    var emoji: String
    var emojiName: String
}

// The emojis hunted, in order. Names are lowercase pieces of MobileNetV2 (ImageNet) labels.
let emojiObjects: [EmojiModel] = [
    EmojiModel(emoji: "💻", emojiName: "laptop"),     // "laptop, laptop computer"
    EmojiModel(emoji: "⌨️", emojiName: "keyboard"),   // "computer keyboard, keypad"
    EmojiModel(emoji: "🖱️", emojiName: "mouse"),      // "mouse, computer mouse"
    EmojiModel(emoji: "🖊️", emojiName: "pen"),        // "ballpoint, ballpoint pen…" / "fountain pen"
    EmojiModel(emoji: "☕️", emojiName: "mug"),        // "coffee mug"
    EmojiModel(emoji: "📱", emojiName: "cellular")    // "cellular telephone, cellular phone…"
]
