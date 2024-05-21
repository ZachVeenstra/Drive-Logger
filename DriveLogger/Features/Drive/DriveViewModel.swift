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
    
    private var liveActivity: Activity<DriveLoggerWidgetAttributes>? = nil
    
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

// MARK: LiveActivities
private extension DriveViewModel {
    func startLiveActivity() {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                let attributes = DriveLoggerWidgetAttributes(startTime: startTime)
                let initialState = DriveLoggerWidgetAttributes.ContentState()
                
                liveActivity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: initialState, staleDate: nil),
                    pushType: nil)
            
            } catch {
                let errorMessage = """
                                    Couldn't start activity
                                    ------------------------
                                    \(String(describing: error))
                                    """
                print(errorMessage)
            }
        }
    }
    
    func endLiveActivity() async {
        guard let activity = liveActivity else {
            print("Activity was nil.")
            return
        }
        
        let finalContent = DriveLoggerWidgetAttributes.ContentState()
        
        await activity.end(
            ActivityContent(state: finalContent, staleDate: nil),
            dismissalPolicy: .immediate
        )
        
        self.liveActivity = nil
        print("Activity ended")
    }
}

// MARK: Night hours / location
private extension DriveViewModel {
    func getCurrentLocation() -> CLLocation? {
        let locationManager = CLLocationManager()
        
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
            
            let currentLocation = locationManager.location
            
            locationManager.stopUpdatingLocation()
            
            return currentLocation
        } else {
            return nil
        }
    }
    
    func getWeather(location: CLLocation) async -> Weather? {
        let weatherService = WeatherService()
        
        do {
            let weather = try await weatherService.weather(for: location)
            return weather
        } catch {
            print("ERROR fetching weather: \(error)")
            return nil
        }
    }
    
    func getSunEvents(weather: Weather) -> SunEvents {
        return weather.dailyForecast[0].sun
    }
    
    func getSecondsDrivenDuringNight(driveStart: Date, driveEnd: Date, nightStart: Date, nightEnd: Date) throws -> Int32 {
        enum InputError: Error {
            case badInput
        }
        
        if driveEnd <= nightStart {
            return 0
        }
        else if driveStart < nightStart && driveEnd > nightStart {
            return Int32(driveEnd.timeIntervalSince(nightStart))
        }
        else if driveStart >= nightStart && driveEnd <= nightEnd {
            return Int32(driveEnd.timeIntervalSince(driveStart))
        }
        else if driveStart < nightEnd && driveEnd > nightEnd {
            return Int32(nightEnd.timeIntervalSince(driveStart))
        }
        else if driveStart >= nightEnd {
            return 0
        }
        else {
            throw InputError.badInput
        }
    }
    
    func getSecondsDrivenDuringNight(driveStart: Date, driveEnd: Date) async throws -> Int32 {
        enum DriveError: Error {
            case locationError
            case weatherError
            case timeError
        }
        
        var nightDuration: Int32 = 0
        let calendar = Calendar.current
        let minutesIntervalForNight = 30 // Night is starts 30 minutes after sunset and ends 30 minutes before sunrise, according to Michigan DMV.
        
        guard let location: CLLocation = getCurrentLocation() else {
            throw DriveError.locationError
        }
        
        guard let weather: Weather = await getWeather(location: location) else {
            throw DriveError.weatherError
        }
        
        let sunEvents: SunEvents = getSunEvents(weather: weather)
        
        // It is possible for the sun not to set or rise at extreme latitudes.
        guard let sunsetTime: Date = sunEvents.sunset else {
            // The sun didn't set, so there were no night hours.
            nightDuration = 0
            return nightDuration
        }
        guard let sunriseTime: Date = sunEvents.sunrise else {
            // The sun never rose, so there were only night hours.
            nightDuration = Int32(driveEnd.timeIntervalSince(driveStart))
            return nightDuration
        }
        
        guard let nightStart: Date = calendar.date(byAdding: .minute, value: minutesIntervalForNight, to: sunsetTime) else {
            throw DriveError.timeError
        }
        guard let nightEnd: Date = calendar.date(byAdding: .minute, value: -minutesIntervalForNight, to: sunriseTime) else {
            throw DriveError.timeError
        }
        
        return try getSecondsDrivenDuringNight(driveStart: driveStart, driveEnd: driveEnd, nightStart: nightStart, nightEnd: nightEnd)
    }
}
