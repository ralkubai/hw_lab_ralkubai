//
//  LocationManager.swift
//  FindMyCar
//
//  Gets the device's location with Core Location and saves/loads the car's
//  coordinate to a small plist file in the app's Documents folder.
//

import Foundation
import CoreLocation
import Observation

@Observable
class LocationManager: NSObject {   // NSObject is required for CLLocationManagerDelegate

    // MARK: - Observable Properties
    var coordinate = CarCoordinate()                                 // Saved car location ((0,0) = none)
    var authorizationStatus: CLAuthorizationStatus = .notDetermined  // Current location permission
    var locationError: String?                                       // Last error to show the user

    // MARK: - Private Properties
    @ObservationIgnored private let locationManager = CLLocationManager()          // Apple's location service
    @ObservationIgnored private let plistFileName = "Coordinates.plist"            // File the coordinate is saved in
    @ObservationIgnored private var locationSaveCompletion: (() -> Void)?          // Called once a save finishes

    // MARK: - Initialization

    /// Configures the CLLocationManager, reads the current permission, and loads any saved location.
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        authorizationStatus = locationManager.authorizationStatus
        loadLocation()
    }

    // MARK: - Public Methods

    /// Requests location permission if needed, then gets and saves the current location.
    /// `completion` runs once the location is saved, or once an error occurs.
    func saveCurrentLocation(completion: @escaping () -> Void = {}) {
        // Clear any previous errors
        locationError = nil

        // Store completion handler to call after location is saved
        locationSaveCompletion = completion

        // Check authorization status
        switch authorizationStatus {
        case .notDetermined:
            // Ask the user; locationManagerDidChangeAuthorization continues from here
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationError = "Location access denied. Please enable in Settings."
            locationSaveCompletion?()
            locationSaveCompletion = nil
            return
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        @unknown default:
            locationError = "Unknown authorization status"
            locationSaveCompletion?()
            locationSaveCompletion = nil
        }
    }

    /// Clears the saved car location (resets to (0, 0)) and saves that to the plist.
    func clearLocation() {
        coordinate = CarCoordinate()
        saveLocationToPlist()
    }

    // MARK: - Persistence Methods
    // This is such a small amount of data that we are just going to use
    // plist-based persistence using Codable.

    /// Saves the current coordinate to a plist file using PropertyListEncoder.
    private func saveLocationToPlist() {
        do {
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            let data = try encoder.encode(coordinate)
            try data.write(to: plistURL(), options: .atomic)   // atomic = no half-written files
        } catch {
            print("Error saving location: \(error.localizedDescription)")
            locationError = "Failed to save location"
        }
    }

    /// Loads the coordinate from the plist file, if one has been saved before.
    private func loadLocation() {
        let url = plistURL()

        // Nothing saved yet (first launch)
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            coordinate = try decoder.decode(CarCoordinate.self, from: data)
        } catch {
            print("Error loading location: \(error.localizedDescription)")
        }
    }

    // MARK: - Private Helper Methods

    /// Starts asking Core Location for position updates, if location services are on.
    private func startLocationUpdates() {
        guard CLLocationManager.locationServicesEnabled() else {
            locationError = "Location services are disabled"
            return
        }
        locationManager.startUpdatingLocation()
    }

    /// Returns the URL for the plist file in the app's Documents directory.
    private func plistURL() -> URL {
        URL.documentsDirectory.appendingPathComponent(plistFileName)
    }
}

// MARK: - CLLocationManagerDelegate
// The delegate is how CLLocationManager reports back to our app.

extension LocationManager: CLLocationManagerDelegate {

    /// Called when the user grants or changes location permission.
    /// If access is now allowed, starts getting the location.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        // If authorized, start getting location
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            startLocationUpdates()
        }
    }

    /// Called with new location fixes. Saves the latest one as the car's location, then stops updating.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Update coordinate
        coordinate = CarCoordinate(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )

        // Save to plist
        saveLocationToPlist()

        // Stop updating to conserve battery
        locationManager.stopUpdatingLocation()

        // Call completion handler after location is saved
        locationSaveCompletion?()
        locationSaveCompletion = nil
    }

    /// Called when Core Location can't get a location. Records the error and lets the UI respond.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = "Failed to get location: \(error.localizedDescription)"
        locationManager.stopUpdatingLocation()

        // Call completion handler even on error so UI can respond
        locationSaveCompletion?()
        locationSaveCompletion = nil
    }
}
