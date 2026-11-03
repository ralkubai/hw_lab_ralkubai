//
//  MapView.swift
//  FindMyCar
//
//  Map showing the user's location and a car pin at the saved location.
//

import SwiftUI
import MapKit

struct MapView: View {
    // MARK: - Properties

    // Plain property: @Observable lets SwiftUI track reads without a wrapper
    var locationManager: LocationManager
    @State private var position: MapCameraPosition = .automatic   // Where the map camera is pointed

    // MARK: - Computed Properties

    /// The saved car location as a CLLocationCoordinate2D for MapKit.
    private var carCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: locationManager.coordinate.latitude,
            longitude: locationManager.coordinate.longitude
        )
    }

    /// True when a car location has been saved ((0, 0) means none).
    private var hasLocation: Bool {
        locationManager.coordinate.latitude != 0 || locationManager.coordinate.longitude != 0
    }

    // MARK: - Body

    /// Builds the map with the user and car markers, map controls, and the coordinate info card.
    var body: some View {
        ZStack {
            Map(position: $position) {
                // User location marker (blue dot)
                UserAnnotation()

                // Car location marker (only show if location is saved)
                if hasLocation {
                    Annotation("Your Car is Here", coordinate: carCoordinate) {
                        VStack(spacing: 4) {
                            Image(systemName: "car.fill")
                                .font(.title)
                                .foregroundColor(.red)
                                .padding(8)
                                .background(Circle().fill(Color.white))
                                .shadow(radius: 3)

                            Text("Your Car")
                                .font(.caption)
                                .padding(4)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(4)
                                .shadow(radius: 2)
                        }
                    }
                }
            }
            .mapControls {
                MapUserLocationButton()   // Jump to the user's location
                MapCompass()
                MapScaleView()
            }
            .ignoresSafeArea()
            .onAppear {
                updateMapPosition()
            }
            // Re-center if the saved location changes while the map is open
            .onChange(of: locationManager.coordinate) { _, _ in
                updateMapPosition()
            }

            // Info card at top
            VStack {
                if hasLocation {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Car Location")
                            .font(.headline)
                        Text("Lat: \(String(format: "%.6f", carCoordinate.latitude))")
                            .font(.caption)
                        Text("Lon: \(String(format: "%.6f", carCoordinate.longitude))")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
                }
                Spacer()
            }
        }
        .navigationTitle("Map View")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helper Methods

    /// Centers the map camera on the car, zoomed to roughly a few city blocks.
    private func updateMapPosition() {
        guard hasLocation else { return }

        let region = MKCoordinateRegion(
            center: carCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )

        position = .region(region)
    }
}

// MARK: - Preview
#Preview {
    let manager = LocationManager()
    // Set a sample location for preview (CMU coordinates)
    manager.coordinate = CarCoordinate(latitude: 40.444644, longitude: -79.945424)
    return NavigationStack {
        MapView(locationManager: manager)
    }
}
