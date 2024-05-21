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
        return "Drive on \(dateFormatter.string(from: Date()))"
    }
    
    func endDrive(drivesDataModel: DrivesDataModel) -> Void {
        let endTime: Date = Date.now
        let duration: Double = Date.now.timeIntervalSince(startTime)
        
        Task {
            let nightDuration: Int32
            
            do {
                nightDuration = try await getSecondsDrivenDuringNight(driveStart: startTime, driveEnd: endTime)
            } catch {
                // TODO: Show splash prompting the user to enter night duration.
                nightDuration = 0
            }
            
            drivesDataModel.createDrive(
                name: getName(),
                dayDuration: Int32(duration) - nightDuration,
                nightDuration: nightDuration,
                distance: 0
            )
        
            await self.endLiveActivity()
        }
    }
}
