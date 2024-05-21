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

        @Published var location: CLLocation?

        override init() {
            super.init()
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
            location = manager.location
            print(location ?? "No location provided.")
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            location = locations.first
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
