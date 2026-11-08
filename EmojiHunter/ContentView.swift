//
//  ContentView.swift
//  EmojiHunter
//
//  The game screen: camera (or NEXT screen) underneath, timer / emoji / game-over controls on top.
//

import SwiftUI

struct ContentView: View {
    // @State owns the @Observable view model for the life of this view
    @State private var viewModel = GameViewModel()

    /// Layer 1: NEXT screen after a round ends, otherwise the live camera.
    /// Layer 2: GAME OVER button or countdown, plus the emoji / result text.
    var body: some View {
        ZStack {
            // MARK: Layer 1 – background
            if (viewModel.showNext || viewModel.emojiStatus == .found) && viewModel.emojiStatus != .gameOver {
                // Round finished (found or time ran out): black screen with a NEXT button
                Color.black
                    .ignoresSafeArea()

                Button {
                    viewModel.startSearch()
                } label: {
                    Text("NEXT")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            } else {
                // Live camera hunting for the current emoji.
                // $ passes a Binding, so the camera's Coordinator can set emojiStatus to .found.
                CustomCameraRepresentable(emojiString: emojiObjects[viewModel.currentLevel].emojiName,
                                          emojiFound: $viewModel.emojiStatus)
                    // New id per level forces a fresh camera with the new target
                    // (otherwise restarting from GAME OVER would keep hunting the old emoji)
                    .id(viewModel.currentLevel)
                    .ignoresSafeArea()
            }

            // MARK: Layer 2 – messages at the bottom
            VStack {
                Spacer()

                if viewModel.emojiStatus == .gameOver {
                    // Last emoji done: red restart button
                    Button {
                        viewModel.restartGame()
                    } label: {
                        Text("GAME OVER\nTap to restart")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.bottom, 40)
                } else {
                    if viewModel.emojiStatus == .searching {
                        // Big yellow countdown, ticked by the view model's timer
                        Text("\(viewModel.timeRemaining)")
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundColor(.yellow)
                            .onReceive(viewModel.timer) { _ in
                                viewModel.adjustTime()
                            }
                    }

                    // Target emoji, "is FOUND", or "NOT FOUND"
                    viewModel.emojiResultText()
                        .foregroundColor(viewModel.emojiStatus == .notFound ? .red : .white)
                        .padding(.bottom, 20)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
