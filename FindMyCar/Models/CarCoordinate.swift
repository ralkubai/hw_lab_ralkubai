//
//  CarCoordinate.swift
//  FindMyCar
//
//  The car's latitude/longitude in a Codable form so it can be saved to a plist.
//

import Foundation

// Codable struct for plist persistence; Equatable so coordinates can be compared.
// nonisolated: keeps this value type usable from tests and encoders outside the main actor.
nonisolated struct CarCoordinate: Codable, Equatable {
    var latitude: Double
    var longitude: Double

    /// Creates a coordinate. Defaults to (0, 0), which the app treats as "no location saved".
    init(latitude: Double = 0.0, longitude: Double = 0.0) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
