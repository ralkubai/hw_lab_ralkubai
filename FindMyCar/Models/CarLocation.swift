//
//  CarLocation.swift
//  FindMyCar
//
//  A map-ready description of where the car is: coordinate plus labels.
//

import Foundation
import CoreLocation

// Helper struct to make the car location identifiable for Map annotations.
// nonisolated: a plain value type, so it shouldn't be tied to the main actor.
nonisolated struct CarLocation: Identifiable {
    let id = UUID()                          // Unique id so SwiftUI/Map can track it
    let coordinate: CLLocationCoordinate2D   // Where the car is
    let title: String                        // Main label, e.g. "Your Car"
    let subtitle: String                     // Extra detail, e.g. the coordinates
}
