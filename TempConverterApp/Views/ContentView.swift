//
//  ContentView.swift
//  TempConverterApp
//
//  Created by RK on 07/09/2026.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewController = ViewController()
    @State var inputTemp: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                //Setting the background color
                Color.blue
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.50)

                //for gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.gray]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.45)

                // MARK: Main Content
                VStack {
                    Spacer()

                    if viewController.isConvertingCtoF {
                        Text("\(viewController.convertedTempString) ºF")
                            .font(.largeTitle)
                            .fontWeight(.ultraLight)
                    } else {
                        Text("\(viewController.convertedTempString) ºC")
                            .font(.largeTitle)
                            .fontWeight(.ultraLight)
                    }

                    Spacer()

                    Text("Enter Temperature:")
                        .fontWeight(.bold)

                    TextField("temperature", text: $inputTemp)
                        .padding(.horizontal)
                        .frame(width: 200.0, height: 35.0)
                        .border(Color.white, width: 0.50)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numbersAndPunctuation)

                    Spacer()

                    HStack(alignment: .center) {
                        Text("ºF -> ºC")
                            .fontWeight(.bold)
                        Toggle(isOn: $viewController.isConvertingCtoF) {
                            Text("")
                        }
                        .labelsHidden()
                        .frame(width: 50)
                        .padding()
                        Text("ºC -> ºF")
                            .fontWeight(.bold)
                    }
                    .padding()

                    Button("Convert") {
                        //action
                        viewController.setInputTempString(self.inputTemp)
                        viewController.convert()
                    }//button styling
                    .padding(.all)
                    .background(Color.white)
                    .cornerRadius(15.0)

                    Spacer()

                    //Navigation link
                    NavigationLink(destination: infoView()) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 50)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
