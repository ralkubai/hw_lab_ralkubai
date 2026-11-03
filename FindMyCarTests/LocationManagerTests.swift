//
//  LocationManagerTests.swift
//  FindMyCarTests
//
//  Tests LocationManager's state handling (not the Core Location callbacks themselves).
//

import Testing
import CoreLocation
@testable import FindMyCar

// @MainActor because LocationManager is main-actor-isolated by default
@MainActor
struct LocationManagerTests {

    /// A new manager starts with no saved location.
    /// Note: it loads the plist on init, so this fails if the app already saved a location
    /// in this simulator — run the tests before using "Here's My Car", or reset the simulator.
    @Test func startsWithZeroCoordinate() {
        let manager = LocationManager()
        #expect(manager.coordinate == CarCoordinate())
    }

    /// clearLocation() resets the coordinate back to (0, 0).
    @Test func clearLocationResetsCoordinate() {
        let manager = LocationManager()
        manager.coordinate = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
        manager.clearLocation()
        #expect(manager.coordinate == CarCoordinate())
    }

    /// When location access is denied, saving produces an error message instead of a location.
    @Test func deniedAuthorizationProducesError() {
        let manager = LocationManager()
        manager.authorizationStatus = .denied
        manager.saveCurrentLocation()
        #expect(manager.locationError != nil)
    }
}
