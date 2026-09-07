//
//  ViewController.swift
//  TempConverterApp
//
//  Created by RK on 07/09/2026.
//

import Combine

class ViewController: ObservableObject {

    var tempConverter: TempConverter = TempConverter()

    @Published var inputTempString: String = "Temp"
    @Published var convertedTempString: String = "Temp"
    @Published var isConvertingCtoF: Bool = true

    func setInputTempString(_ temp: String) {
        inputTempString = temp
    }

    func setConvertedTempString() {
        let convertedTemp = tempConverter.getConvertedTemp()
        if let convertedTemp = convertedTemp {
            convertedTempString = String(convertedTemp)
        } else {
            convertedTempString = "N/A"
        }
    }

    //set the input temperature unit
    func setInputTempUnit() {
        isConvertingCtoF ? tempConverter.setInputUnit(.celsius) :
            tempConverter.setInputUnit(.fahrenheit)
    }

    func convert() {
        let inputTemp = Int(inputTempString) ?? -500
        setInputTempUnit()
        tempConverter.setInputTemp(inputTemp)
        tempConverter.convert()
        setConvertedTempString()
    }
}
