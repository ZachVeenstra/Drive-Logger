//
//  DrivesViewModel.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 12/4/23.
//

import Foundation
import CoreData
import SwiftUI


class DrivesViewModel: ObservableObject {
    
//    let container = NSPersistentContainer(name: "DriveModel")
    let moc: NSManagedObjectContext
    
    private let secondsInHour: Int = 3600
    private let secondsInMinute: Int = 60
    
    @Published var drives: [Drive] = []

    init(moc: NSManagedObjectContext) {
        self.moc = moc
        
        fetchData(moc: moc)
    }

    func fetchData(moc: NSManagedObjectContext) {
        let request = Drive.fetchRequest()
        if let drives = try? moc.fetch(request) {
            self.drives = drives
        }
    }

    func createDrive(name: String, duration: Int32, distance: Double) {
        let drive = Drive(context: moc)
        drive.id = UUID()
        drive.date = Date()
        drive.name = name
        drive.duration = duration
        drive.hours = duration / Int32(secondsInHour)
        drive.minutes = duration % Int32(secondsInHour) / Int32(secondsInMinute)
        drive.distance = distance

        do {
            try moc.save()
            drives.append(drive)
        } catch {
            print("Failed to add drive")
        }
    }
    
    func editDrive(drive: Drive, name: String, duration: Int32, distance: Double) {
        drives.removeAll { previousDrive in
            drive == previousDrive
        }
        
        drive.name = name
        drive.duration = duration
        drive.hours = duration / Int32(secondsInHour)
        drive.minutes = duration % Int32(secondsInHour) / Int32(secondsInMinute)
        drive.distance = distance
        
        do {
            try moc.save()
            drives.append(drive)
        } catch {
            print("Failed to add drive")
        }
    }

    func deleteDrive(drive: Drive) {
        moc.delete(drive)

        do {
            try moc.save()

            if let index = drives.firstIndex(where: { drive.id == $0.id }) {
                drives.remove(at: index)
            }
        } catch {
            print("Error deleting task")
        }
    }
    
    func getTotalSeconds() -> Int {
        var totalTime: Int32 = 0
        
        for drive in self.drives {
            totalTime += drive.duration
        }
        
        return Int(totalTime)
    }
    
    func getMinutes(from seconds: Int) -> Int {
        return seconds % secondsInHour / secondsInMinute
    }
    
    func getHours(from seconds: Int) -> Int {
        return seconds / secondsInHour
    }
    
    func hoursToSeconds(from hours: Int) -> Int {
        return hours * secondsInHour
    }
    
    func minutesToSeconds(from minutes: Int) -> Int {
        return minutes * secondsInMinute
    }
}
