//
//  CarCoordinateTests.swift
//  FindMyCarTests
//
//  Swift Testing unit tests for the CarCoordinate value type.
//

import Testing
import Foundation   // Needed for PropertyListEncoder/Decoder (member import visibility is on)
@testable import FindMyCar

struct CarCoordinateTests {

    /// The default initializer gives (0, 0), the app's "no location" value.
    @Test func defaultInitializerIsZero() {
        let coord = CarCoordinate()
        #expect(coord.latitude == 0.0)
        #expect(coord.longitude == 0.0)
    }

    /// Custom latitude/longitude values are stored as given.
    @Test func customInitializerStoresValues() {
        let coord = CarCoordinate(latitude: 40.7128, longitude: -74.0060)
        #expect(coord.latitude == 40.7128)
        #expect(coord.longitude == -74.0060)
    }

    /// Equal coordinates compare equal; different ones don't.
    @Test func equalityWorks() {
        let a = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
        let b = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
        let c = CarCoordinate(latitude: 0, longitude: 0)
        #expect(a == b)
        #expect(a != c)
    }

    /// Encoding to a plist and decoding back gives the same coordinate.
    @Test func encodesAndDecodesRoundTrip() throws {
        let original = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
        let data = try PropertyListEncoder().encode(original)
        let decoded = try PropertyListDecoder().decode(CarCoordinate.self, from: data)
        #expect(decoded == original)
    }
}
