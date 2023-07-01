//
//  LocationDataManager.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-06-01.
//

import Foundation
import CoreLocation
import CoreLocationUI


class LocationManager : NSObject, ObservableObject, CLLocationManagerDelegate {

  static let shared = LocationManager()

  // Published properties for observing changes in authorization status and location coordinates
  @Published var authorizationStatus: CLAuthorizationStatus?
  @Published var latitude: Double = 0
  @Published var longitude: Double = 0

  // CLLocationManager instance for managing location-related operations
  var locationManager: CLLocationManager

  override init() {
    locationManager = CLLocationManager()

    super.init()

    // Set the delegate to self and configure desired accuracy and distance filter
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = 10

    // Start monitoring significant location changes
    locationManager.startMonitoringSignificantLocationChanges()
  }

  // MARK: - CLLocationManagerDelegate methods

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    // Handle changes in location authorization status
    switch manager.authorizationStatus {
    case .authorizedWhenInUse:
      // Location services are available and authorized when in use

      // Update the authorization status property
      authorizationStatus = .authorizedWhenInUse

      // Request the current location
      locationManager.requestLocation()

      // Update the latitude and longitude properties on the main queue
      DispatchQueue.main.async {
        self.latitude = self.locationManager.location?.coordinate.latitude ?? 0
        self.longitude = self.locationManager.location?.coordinate.longitude ?? 0
        print("Hey, something is happening")
      }

    case .restricted:
      // Location services are restricted

      // Update the authorization status property
      authorizationStatus = .restricted

    case .denied:
      // Location services are denied by the user

      // Update the authorization status property
      authorizationStatus = .denied

    case .notDetermined:
      // Authorization not determined yet

      // Update the authorization status property
      authorizationStatus = .notDetermined

      // Request location authorization when in use
      manager.requestWhenInUseAuthorization()

    default:
      break
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Handle location updates

    // Retrieve the latest location coordinates
    guard let lat = locations.last?.coordinate.latitude, let lon = locations.last?.coordinate.longitude else { return }

    // Update the latitude and longitude properties on the main queue
    DispatchQueue.main.async {
      self.latitude = lat
      self.longitude = lon
    }

    // Print the updated location coordinates
    print("Your current updated location is:")
    print("Latitude: \(String(describing: self.latitude))")
    print("Longitude: \(String(describing: self.longitude))")
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    // Handle location manager errors
    print("Error: \(error.localizedDescription)")
  }
}
