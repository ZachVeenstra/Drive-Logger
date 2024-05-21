//
//  DriveServices.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/20/24.
//

import Foundation
import WeatherKit
import MapKit
import CoreLocation

extension DriveViewModel {
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
