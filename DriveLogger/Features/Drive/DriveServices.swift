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
    enum DriveError: Error {
        case locationError
        case weatherError
        case timeError
    }
    
    func getForecast(location: CLLocation, start: Date, end: Date) async -> Forecast<DayWeather>? {
        let weatherService = WeatherService.shared
        let weather = try? await weatherService.weather(for: location, including: .daily(startDate: start, endDate: end))
        return weather
    }
    
    func getSunEvents(weather: Weather) -> SunEvents {
        return weather.dailyForecast[0].sun
    }

    func getNightInterval(driveStart: Date, driveEnd: Date, location: CLLocation) async throws -> DateInterval {
        let calendar = Calendar.current
        let minutesIntervalForNight = 30 // Night starts 30 minutes after sunset and ends 30 minutes before sunrise, according to Michigan DMV.

        guard let forecastStart: Date = calendar.date(byAdding: .day, value: -1, to: driveStart) else {
            throw DriveError.timeError
        }
        guard let forecastEnd: Date = Calendar.current.date(byAdding: .day, value: 1, to: driveEnd) else {
            throw DriveError.timeError
        }

        guard let forecast: Forecast<DayWeather> = await getForecast(location: location, start: forecastStart, end: forecastEnd) else {
            throw DriveError.weatherError
        }

        var beginningOfNights: [Date?] = forecast.forecast.map { weather in
            guard let sunset = weather.sun.sunset else {
                return nil
            }
            return calendar.date(byAdding: .minute, value: minutesIntervalForNight, to: sunset)
        }

        var endingOfNights: [Date?] = forecast.forecast.map { weather in
            guard let sunrise = weather.sun.sunrise else {
                return nil
            }
            return calendar.date(byAdding: .minute, value: -minutesIntervalForNight, to: sunrise)
        }

        endingOfNights.removeFirst() // We don't need to know the sunrise of the day before.
        beginningOfNights.removeLast() // We don't need to know the sunset of the day after.

        guard let nightStart = beginningOfNights[0] else {
            return DateInterval(start: driveStart, duration: 0)
        }

        guard let nightEnd = beginningOfNights[0] else {
            return DateInterval(start: driveStart, end: driveEnd) // There was no sunset, so the night never ended.
        }

        return DateInterval(start: nightStart, end: nightEnd)
    }

    func getSecondsDrivenDuringNight(driveInterval: DateInterval, nightInterval: DateInterval) throws -> Int32 {
        if let nightDriveInterval = driveInterval.intersection(with: nightInterval) {
            return Int32(nightDriveInterval.duration)
        } else {
            return 0
        }
    }
    
    func getSecondsDrivenDuringNight(driveStart: Date, driveEnd: Date, location: CLLocation) async throws -> Int32 {
        let driveInterval: DateInterval = DateInterval(start: driveStart, end: driveEnd)
        let calendar = Calendar.current
        let nightInterval = try await self.getNightInterval(driveStart: driveStart, driveEnd: driveEnd, location: location)

        return try getSecondsDrivenDuringNight(driveInterval: driveInterval, nightInterval: nightInterval)
    }
}
