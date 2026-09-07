//
//  infoView.swift
//  TempConverterApp
//
//  Created by RK on 07/09/2026.
//

import SwiftUI

struct infoView: View {
    var body: some View {
        ZStack {
            Color.blue
                .edgesIgnoringSafeArea(.all)
                .opacity(0.50)

            VStack(spacing: 20) {
                Text("About TempConverter")
                    .font(.largeTitle)
                    .fontWeight(.ultraLight)

                Text("This is the ever-famous TempConverter turned into a working iOS app. Enter a temperature, flip the toggle to pick a direction, and tap Convert. Values below absolute zero and anything that isn't a number will show as N/A.")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding()
        }
        .navigationTitle("Info")
    }
}

#Preview {
    infoView()
}
