//
//  DriveModel.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 12/2/23.
//

import Foundation
import SwiftUI
import CoreData
import Combine
import ActivityKit
import WeatherKit
import MapKit
import CoreLocation

@MainActor
class DriveViewModel: ObservableObject {
    @Published private(set) var startTime: Date
    
    var liveActivity: Activity<DriveLoggerWidgetAttributes>? = nil
    let locationManager = LocationManager.shared
    
    init() {
        startTime = .now
        
        self.startLiveActivity()
        Task {
            do {
                let _ = try await StartDriveIntent().perform()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getName() -> String {
        return Date().formattedDate
    }
    
    func endDrive(drivesDataModel: DrivesDataModel) -> Void {
        Task {
            await self.endLiveActivity()
            do {
                let _ = try await EndDriveIntent().perform()
            } catch {
                print(error.localizedDescription)
            }

        }
    }
}

extension Date {
    var formattedDate: String {
        let partOfDay: String

        switch Calendar.current.component(.hour, from: self) {
        case 5...11:
            partOfDay = "Morning"
        case 12...16:
            partOfDay = "Afternoon"
        case 17...20:
            partOfDay = "Evening"
        case 21...24, 0...4:
            partOfDay = "Night"
        default:
            partOfDay = self.description
        }

        let day = self.formatted(Date.FormatStyle().weekday(.wide))

        return "\(day) \(partOfDay) Drive"
    }
}

