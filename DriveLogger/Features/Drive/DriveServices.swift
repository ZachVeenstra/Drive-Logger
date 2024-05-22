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

    func getNightInterval(driveStart: Date, driveEnd: Date, location: CLLocation) async throws -> TimeInterval {
        let driveInterval = DateInterval(start: driveStart, end: driveEnd)

        let forecast = try await getDriveForecast(driveStart: driveStart, driveEnd: driveEnd, location: location)

        let adjustedSunEvents = getAdjustedSunEvents(from: forecast)
        let adjustedSunsets = adjustedSunEvents.sunsets
        let adjustedSunrises = adjustedSunEvents.sunrises

        var secondsDrivenDuringNight: TimeInterval = 0
        
        for index in adjustedSunsets.indices {
            if let adjustedSunset = adjustedSunsets[index] {
                if let adjustedSunrise = adjustedSunrises[index] {
                    let nightInterval = DateInterval(start: adjustedSunset, end: adjustedSunrise)
                    if let nightDriveInterval = driveInterval.intersection(with: nightInterval) {
                        secondsDrivenDuringNight += nightDriveInterval.duration
                    }
                }
            }
        }

        return secondsDrivenDuringNight
    }

    private func getForecast(location: CLLocation, start: Date, end: Date) async -> Forecast<DayWeather>? {
        let weatherService = WeatherService.shared
        let weather = try? await weatherService.weather(for: location, including: .daily(startDate: start, endDate: end))
        return weather
    }

    private func getDriveForecast(driveStart: Date, driveEnd: Date, location: CLLocation) async throws -> Forecast<DayWeather> {
        let calendar = Calendar.current

        guard let forecastStart: Date = calendar.date(byAdding: .day, value: -1, to: driveStart) else {
            throw DriveError.timeError
        }
        guard let forecastEnd: Date = Calendar.current.date(byAdding: .day, value: 2, to: driveEnd) else {
            throw DriveError.timeError
        }

        guard let forecast: Forecast<DayWeather> = await getForecast(location: location, start: forecastStart, end: forecastEnd) else {
            throw DriveError.weatherError
        }

        return forecast
    }

    private func getAdjustedSunEvents(from forecast: Forecast<DayWeather>) -> (sunsets: [Date?], sunrises: [Date?]) {
        let calendar = Calendar.current
        let minutesIntervalForNight = 30 // Night starts 30 minutes after sunset and ends 30 minutes before sunrise, according to Michigan DMV.

        var adjustedSunsets: [Date?] = forecast.forecast.map { weather in
            guard let sunset = weather.sun.sunset else {
                return nil
            }
            return calendar.date(byAdding: .minute, value: minutesIntervalForNight, to: sunset)
        }

        var adjustedSunrises: [Date?] = forecast.forecast.map { weather in
            guard let sunrise = weather.sun.sunrise else {
                return nil
            }
            return calendar.date(byAdding: .minute, value: -minutesIntervalForNight, to: sunrise)
        }

        adjustedSunsets.removeLast()
        adjustedSunrises.removeFirst()

        return (adjustedSunsets, adjustedSunrises)
    }
}
