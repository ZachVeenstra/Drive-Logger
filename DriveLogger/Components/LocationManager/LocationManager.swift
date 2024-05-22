//
//  File.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/20/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

        static let shared = LocationManager()
        @Published var location: CLLocation?

        private override init() {
            super.init()
            manager.delegate = self
            manager.requestWhenInUseAuthorization()

            location = manager.location
            print(location ?? "No location provided.")
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            location = locations.first
        }

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            if manager.authorizationStatus == .authorizedWhenInUse {
                location = manager.location
            }
        }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
