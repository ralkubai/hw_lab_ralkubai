//
//  TempConverter.swift
//  TempConverterApp
//
//  Created by RK on 07/09/2026.
//

import Foundation

class TempConverter {

    //enum for temperature units
    enum TemperatureUnit: String {
        case fahrenheit = "ºF"
        case celsius = "ºC"
    }

    //MARK: fields
    var isConvertingCtoF: Bool = true
    var inputTemp: Int = 0
    var convertedTemp: Int?   //stores the conversion output or nil if invalid

    //Check if the input temperature is below absolute zero
    func isBelowAbsoluteZero() -> Bool {
        if isConvertingCtoF {
            return inputTemp > -273
        } else {
            return Double(inputTemp) > -459.67
        }
    }

    //Set the input units (use switch case instead of if-else)
    func setInputUnit(_ tempunit: TemperatureUnit) {
        switch tempunit {
        case .celsius:
            isConvertingCtoF = true
        case .fahrenheit:
            isConvertingCtoF = false
        }
    }

    //setter for temperature input
    func setInputTemp(_ temp: Int) {
        inputTemp = temp
    }

    //getter for converted temperature
    func getConvertedTemp() -> Int? {
        return convertedTemp
    }

    private func celsiusToFahrenheit() {
        convertedTemp = Int((Double(inputTemp) * 9.0 / 5.0) + 32.0)
    }

    private func fahrenheitToCelsius() {
        convertedTemp = Int((Double(inputTemp) - 32.0) * 5.0 / 9.0)
    }

    // Main convert function to validate and perform the conversion
    func convert() {
        guard isBelowAbsoluteZero() else {
            convertedTemp = nil
            return
        }
        isConvertingCtoF ? celsiusToFahrenheit() : fahrenheitToCelsius()
    }
}

