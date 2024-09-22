//
//  DrivesDataModel.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 12/4/23.
//  Inspiration: https://www.hackingwithswift.com/forums/swift/trying-to-access-managed-object-context-through-a-model/23266
//

import Foundation
import CoreData

class DrivesDataModel: ObservableObject {
    let moc: NSManagedObjectContext
    
    @Published var drives: [Drive] = []
    @Published var driveInProgress: Drive? = nil

    init(moc: NSManagedObjectContext) {
        self.moc = moc
        NotificationCenter.default.addObserver(self, selector: #selector(fetchUpdates(_:)), name: .NSManagedObjectContextObjectsDidChange, object: nil)

        fetchDrives()
    }
    
    private func save() {
        do {
            try moc.save()
        } catch {
            print("Failed to save")
        }
    }

    func fetchDrives() {
        let request = Drive.fetchRequest()
        if var drives = try? moc.fetch(request) {
            drives.sort {
                $0.date! > $1.date!
            }
            self.drives = drives
        }
    }

    func fetchWeathers() {
        let request = WeatherType.fetchRequest()
        if let weathers = try? moc.fetch(request) {
            if let weather = weathers.first {
                if let drive = weather.drive {
                    print("\(drive.name ?? ""): \(weather.description)")
                } else {
                    print("No drive attatched...")
                }
            }
        }
    }

    @objc private func fetchUpdates(_ notification: Notification) {
        moc.perform {
            self.fetchDrives()
        }
    }

    func createDrive(date: Date, name: String, dayDuration: Int32, nightDuration: Int32, distance: Double, weatherViewModel: WeatherMultiPickerViewModel, roadViewModel: RoadMultiPickerViewModel, notes: String) {
        let drive = Drive(context: moc)
        drive.id = UUID()
        drive.weather = createWeather(weatherViewModel: weatherViewModel)
        drive.road = createRoad(roadViewModel: roadViewModel)

        editDrive(drive: drive,
                  date: date,
                  name: name,
                  dayDuration: dayDuration,
                  nightDuration: nightDuration,
                  distance: distance,
                  weatherViewModel: weatherViewModel,
                  roadViewModel: roadViewModel,
                  notes: notes)

        drives.append(drive)
    }

    func createBackgroundDrive(date: Date, name: String, dayDuration: Int32, nightDuration: Int32, distance: Double, weatherViewModel: WeatherMultiPickerViewModel, roadViewModel: RoadMultiPickerViewModel, notes: String) {
        if driveInProgress != nil {
            print("A drive is already in progrss!")
            return
        }
        let drive = Drive(context: moc)
        drive.id = UUID()
        drive.weather = createWeather(weatherViewModel: weatherViewModel)
        drive.road = createRoad(roadViewModel: roadViewModel)

        editDrive(drive: drive,
                  date: date,
                  name: name,
                  dayDuration: dayDuration,
                  nightDuration: nightDuration,
                  distance: distance,
                  weatherViewModel: weatherViewModel,
                  roadViewModel: roadViewModel,
                  notes: notes)

        driveInProgress = drive
    }

    func endBackgroundDrive(drive: Drive, date: Date, name: String, dayDuration: Int32, nightDuration: Int32, distance: Double, weatherViewModel: WeatherMultiPickerViewModel, roadViewModel: RoadMultiPickerViewModel, notes: String) {

        if driveInProgress == nil {
            print("No drive was started...")
            return
        }
        
        drive.date = date
        drive.name = name
        drive.dayDuration = dayDuration
        drive.nightDuration = nightDuration
        drive.distance = distance
        drive.notes = notes

        if let weather = drive.weather {
            editWeather(weather: weather, weatherViewModel: weatherViewModel)
        } else {
            drive.weather = createWeather(weatherViewModel: weatherViewModel)
        }

        if let road = drive.road {
            editRoad(road: road, roadViewModel: roadViewModel)
        } else {
            drive.road = createRoad(roadViewModel: roadViewModel)
        }

        drives.append(drive)
        self.driveInProgress = nil
        save()
    }

    func editDrive(drive: Drive, date: Date, name: String, dayDuration: Int32, nightDuration: Int32, distance: Double, weatherViewModel: WeatherMultiPickerViewModel, roadViewModel: RoadMultiPickerViewModel, notes: String) {
        drive.date = date
        drive.name = name
        drive.dayDuration = dayDuration
        drive.nightDuration = nightDuration
        drive.distance = distance
        drive.notes = notes

        if let weather = drive.weather {
            editWeather(weather: weather, weatherViewModel: weatherViewModel)
        } else {
            drive.weather = createWeather(weatherViewModel: weatherViewModel)
        }

        if let road = drive.road {
            editRoad(road: road, roadViewModel: roadViewModel)
        } else {
            drive.road = createRoad(roadViewModel: roadViewModel)
        }

        save()
    }

    func deleteDrive(drive: Drive) {
        if let weather = drive.weather {
            moc.delete(weather)
        }
        if let road = drive.road {
            moc.delete(road)
        }
        moc.delete(drive)

        do {
            try moc.save()

            if let index = drives.firstIndex(where: { drive.id == $0.id }) {
                drives.remove(at: index)
            }
        } catch {
            print("Error deleting drive")
        }
    }

    func createWeather(weatherViewModel: WeatherMultiPickerViewModel) -> WeatherType {
        let weather = WeatherType(context: moc)
        
        editWeather(weather: weather, weatherViewModel: weatherViewModel)

        return weather
    }

    func editWeather(weather: WeatherType, weatherViewModel: WeatherMultiPickerViewModel) {
        weather.isClear = weatherViewModel.isClear
        weather.isRain = weatherViewModel.isRain
        weather.isSnow = weatherViewModel.isSnow

        save()
    }

    private func createRoad(roadViewModel: RoadMultiPickerViewModel) -> RoadType {
        let road = RoadType(context: moc)

        editRoad(road: road, roadViewModel: roadViewModel)

        return road
    }

    private func editRoad(road: RoadType, roadViewModel: RoadMultiPickerViewModel) {
        road.city = roadViewModel.city
        road.highway = roadViewModel.highway
        road.multilane = roadViewModel.multilane
        road.residential = roadViewModel.residential
        road.roundabout = roadViewModel.roundabout
        road.rural = roadViewModel.rural

        save()
    }

    func getTotalSeconds() -> Int {
        var totalSeconds: Int32 = 0
        
        for drive in self.drives {
            totalSeconds += drive.dayDuration + drive.nightDuration
        }
        
        return Int(totalSeconds)
    }
    
    func getTotalNightSeconds() -> Int {
        var totalNightSeconds: Int32 = 0
        
        for drive in self.drives {
            totalNightSeconds += drive.nightDuration
        }
        
        return Int(totalNightSeconds)
    }
    
    func getTotalMinutes() -> Int {
        return TimeConverter.getMinutes(from: getTotalSeconds())
    }
    
    func getTotalHours() -> Int {
        return TimeConverter.getHours(from: getTotalSeconds())
    }
    
    func getTotalNightMinutes() -> Int {
        return TimeConverter.getMinutes(from: getTotalNightSeconds())
    }
    
    func getTotalNightHours() -> Int {
        return TimeConverter.getHours(from: getTotalNightSeconds())
    }
}
