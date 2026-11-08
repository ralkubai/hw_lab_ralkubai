//
//  GameViewModel.swift
//  EmojiHunter
//
//  Game logic: current level, 10-second round timer, and the found/not-found/game-over state.
//

import SwiftUI
import Observation
import Combine   // Timer.publish / autoconnect come from Combine

@Observable
class GameViewModel {

    // MARK: - Properties setup
    static let roundDuration = 10   // Seconds per round (no magic numbers)

    var currentLevel = 0      // Index into emojiObjects
    var showNext = false      // True when time ran out and the NEXT screen should show

    // Set up timer for the game (ignored by observation; views subscribe with .onReceive)
    @ObservationIgnored
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var timeRemaining = roundDuration

    // Set initial emoji status to searching
    var emojiStatus = EmojiSearch.searching

    // MARK: - Timer methods

    /// Creates a fresh 1-second timer for a new round.
    func instantiateTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }

    /// Stops the current timer.
    func cancelTimer() {
        self.timer.upstream.connect().cancel()
    }

    /// Called every second. Stops the timer if the emoji was found;
    /// otherwise counts down, and marks the round not found when time hits 0.
    func adjustTime() {
        if self.emojiStatus == .found {
            self.cancelTimer()
            self.timeRemaining = Self.roundDuration
        }
        else {
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
            else {
                self.emojiStatus = .notFound
                self.showNext = true
            }
        }
    }

    // MARK: - Gameplay methods

    /// Moves to the next emoji, or ends the game after the last one.
    func startSearch() {
        if self.currentLevel == emojiObjects.count - 1 {
            self.emojiStatus = .gameOver
        }
        else {
            self.currentLevel = self.currentLevel + 1
            startRound()
        }
    }

    /// Starts again from the first emoji.
    func restartGame() {
        self.currentLevel = 0
        startRound()
    }

    /// Resets the timer and state for a new round.
    func startRound() {
        self.timeRemaining = Self.roundDuration
        self.emojiStatus = .searching
        self.showNext = false
        self.instantiateTimer()
    }

    /// The text at the bottom of the screen: the target emoji, "is FOUND", or "NOT FOUND" (in red).
    func emojiResultText() -> Text {
        switch emojiStatus {
        case .found:
            return Text("\(emojiObjects[currentLevel].emoji) is FOUND")
                .font(.system(size: 50, design: .rounded))
                .fontWeight(.bold)
        case .notFound:
            return Text("\(emojiObjects[currentLevel].emoji) NOT FOUND")
                .font(.system(size: 50, design: .rounded))
                .foregroundColor(.red)
                .fontWeight(.bold)
        default:
            return Text(emojiObjects[currentLevel].emoji)
                .font(.system(size: 50, design: .rounded))
                .fontWeight(.bold)
        }
    }
}
