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

    private let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    init() {
        startTime = .now
        
        self.startLiveActivity()
    }
    
    func getName() -> String {
        return Date().formattedDate
    }
    
    func endDrive(drivesDataModel: DrivesDataModel) -> Void {
        let endTime: Date = Date.now
        let duration: Int32 = Int32(Date.now.timeIntervalSince(startTime))

        Task {
            let nightDuration: Int32

            do {
                if let location = locationManager.location {
                    nightDuration = Int32(try await getNightInterval(driveStart: startTime, driveEnd: endTime, location: location))
                } else {
                    nightDuration = 0
                }
            } catch {
                // TODO: Show splash prompting the user to enter night duration.
                nightDuration = 0
            }
            
            drivesDataModel.createDrive(
                date: startTime,
                name: getName(),
                dayDuration: duration - nightDuration,
                nightDuration: nightDuration,
                distance: 0,
                notes: ""
            )
        
            await self.endLiveActivity()
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

