//
//  BackgroundDrivesDataModel.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/25/24.
//

import Foundation
import CoreData
import WeatherKit
import MapKit
import CoreLocation
import ActivityKit

class BackgroundDrivesDataModel: ObservableObject {
    enum DriveError: Error {
        case locationError
        case weatherError
        case timeError
    }

    static let shared = BackgroundDrivesDataModel()
    let dataModel: DrivesDataModel
    let backgroundContext: NSManagedObjectContext
    let locationManager = LocationManager.shared

    var liveActivity: Activity<DriveLoggerWidgetAttributes>? = nil


    init() {
        backgroundContext = DataController.shared.container.newBackgroundContext()
        dataModel = DrivesDataModel(moc: backgroundContext)
    }

    func createDrive() async {
        await backgroundContext.perform {
            self.startLiveActivity()
            self.dataModel.createBackgroundDrive(date: Date(),
                                       name: "Background drive",
                                       dayDuration: 0,
                                       nightDuration: 0,
                                       distance: 0,
                                       weatherViewModel: WeatherMultiPickerViewModel(),
                                       roadViewModel: RoadMultiPickerViewModel(),
                                       notes: "Created in the background"
            )
        }
    }

    func endDrive() async {
        await backgroundContext.perform {
            if let drive = self.dataModel.driveInProgress {
                guard let startTime = drive.date else {
                    return
                }
                let endTime: Date = Date.now
                let duration: Int32 = Int32(Date.now.timeIntervalSince(startTime))

                Task {
                    let nightDuration: Int32

                    do {
                        if let location = self.locationManager.location {
                            nightDuration = Int32(try await self.getNightInterval(driveStart: startTime, driveEnd: endTime, location: location))
                        } else {
                            nightDuration = 0
                        }
                    } catch {
                        // TODO: Show splash prompting the user to enter night duration.
                        nightDuration = 0
                    }

                    // TODO: Fill out with real data.
                    let weatherViewModel = WeatherMultiPickerViewModel()
                    let roadViewModel = RoadMultiPickerViewModel()
                    self.dataModel.endBackgroundDrive(
                        drive: drive,
                        date: startTime,
                        name: self.formattedDate(date: startTime),
                        dayDuration: duration - nightDuration,
                        nightDuration: nightDuration,
                        distance: 0,
                        weatherViewModel: weatherViewModel,
                        roadViewModel: roadViewModel,
                        notes: ""
                    )

                    await self.endLiveActivity()
                }
            }
        }
    }

    func formattedDate(date: Date) -> String {
        let partOfDay: String

        switch Calendar.current.component(.hour, from: date) {
        case 5...11:
            partOfDay = "Morning"
        case 12...16:
            partOfDay = "Afternoon"
        case 17...20:
            partOfDay = "Evening"
        case 21...24, 0...4:
            partOfDay = "Night"
        default:
            partOfDay = date.description
        }

        let day = date.formatted(Date.FormatStyle().weekday(.wide))

        return "\(day) \(partOfDay) Drive"
    }

    private func getNightInterval(driveStart: Date, driveEnd: Date, location: CLLocation) async throws -> TimeInterval {
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
    
    func startLiveActivity() {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                let attributes = DriveLoggerWidgetAttributes(startTime: Date())
                let initialState = DriveLoggerWidgetAttributes.ContentState()

                liveActivity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: initialState, staleDate: nil),
                    pushType: nil)

                print("Live activity started")

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
