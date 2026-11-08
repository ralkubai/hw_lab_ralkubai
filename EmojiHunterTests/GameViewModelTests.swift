//
//  GameViewModelTests.swift
//  EmojiHunterTests
//
//  Swift Testing unit tests for GameViewModel's timer and gameplay logic (no camera needed).
//

import Testing
@testable import EmojiHunter

// @MainActor because GameViewModel is main-actor-isolated by default
@MainActor
struct GameViewModelTests {

    /// A new game starts searching at level 0 with a full timer.
    @Test func startingStateIsSearching() {
        let vm = GameViewModel()
        #expect(vm.emojiStatus == .searching)
        #expect(vm.currentLevel == 0)
        #expect(vm.timeRemaining == GameViewModel.roundDuration)
    }

    /// Each tick while searching takes one second off the clock.
    @Test func adjustTimeDecrementsWhileSearching() {
        let vm = GameViewModel()
        let startingTime = vm.timeRemaining
        vm.adjustTime()
        #expect(vm.timeRemaining == startingTime - 1)
    }

    /// When time runs out, the round is marked not found and NEXT is shown.
    @Test func adjustTimeMarksNotFoundWhenTimeExpires() {
        let vm = GameViewModel()
        vm.timeRemaining = 0
        vm.adjustTime()
        #expect(vm.emojiStatus == .notFound)
        #expect(vm.showNext == true)
    }

    /// Once found, the timer resets to the full round length.
    @Test func adjustTimeResetsWhenFound() {
        let vm = GameViewModel()
        vm.emojiStatus = .found
        vm.timeRemaining = 3
        vm.adjustTime()
        #expect(vm.timeRemaining == GameViewModel.roundDuration)
    }

    /// startSearch moves to the next emoji and starts a new round (unless already on the last one).
    @Test func startSearchAdvancesLevel() {
        let vm = GameViewModel()
        let starting = vm.currentLevel
        vm.startSearch()
        // Only asserts advancement if we're not at the last level
        if starting < emojiObjects.count - 1 {
            #expect(vm.currentLevel == starting + 1)
            #expect(vm.emojiStatus == .searching)
        }
    }

    /// Restarting goes back to the first emoji in the searching state.
    @Test func restartGameResetsLevel() {
        let vm = GameViewModel()
        vm.currentLevel = 3
        vm.restartGame()
        #expect(vm.currentLevel == 0)
        #expect(vm.emojiStatus == .searching)
    }
}
