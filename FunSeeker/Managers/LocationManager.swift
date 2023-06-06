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

  @Published var authorizationStatus: CLAuthorizationStatus?
  @Published var latitude: Double = 0
  @Published var longitude: Double = 0

  var locationManager: CLLocationManager


   override init() {
     locationManager = CLLocationManager()

     super.init()
     locationManager.delegate = self
     locationManager.desiredAccuracy = kCLLocationAccuracyBest
     locationManager.distanceFilter = 10
     locationManager.startMonitoringSignificantLocationChanges()

   }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      switch manager.authorizationStatus {
      case .authorizedWhenInUse:  // Location services are available.
          // Insert code here of what should happen when Location services are authorized
          authorizationStatus = .authorizedWhenInUse
          locationManager.requestLocation()
        DispatchQueue.main.async {
          self.latitude = self.locationManager.location?.coordinate.latitude ?? 0
          self.longitude = self.locationManager.location?.coordinate.longitude ?? 0
          print("Hey biseyler oluyor")
        }
          break

      case .restricted:  // Location services currently unavailable.
          // Insert code here of what should happen when Location services are NOT authorized
          authorizationStatus = .restricted
          break

      case .denied:  // Location services currently unavailable.
          // Insert code here of what should happen when Location services are NOT authorized
          authorizationStatus = .denied
          break

      case .notDetermined:        // Authorization not determined yet.
          authorizationStatus = .notDetermined
          manager.requestWhenInUseAuthorization()
          break

      default:
          break
      }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
  // Insert code to handle location updates
//    print("Your current location is:")
//    print("Latitude: \(locationManager.location?.coordinate.latitude.description ?? "Error loading")")
//    print("Longitude: \(locationManager.location?.coordinate.longitude.description ?? "Error loading")")
//

    guard let lat = locations.last?.coordinate.latitude, let lon = locations.last?.coordinate.longitude else {return}

      DispatchQueue.main.async {
        self.latitude = lat
        self.longitude = lon
      }

    
    print("Your current updated location is:")
    print("Latitude: \(String(describing: self.latitude))")
    print("Longitude: \(String(describing: self.longitude))")
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
  print("error: \(error.localizedDescription)")
  }

}
