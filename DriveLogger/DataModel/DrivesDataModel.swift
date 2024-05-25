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

    init(moc: NSManagedObjectContext) {
        self.moc = moc
        
        fetchDrives()
    }
    
    private func save(drive: Drive) {
        do {
            try moc.save()
            drives.append(drive)
        } catch {
            print("Failed to save")
        }
    }

    func fetchDrives() {
        let request = Drive.fetchRequest()
        if let drives = try? moc.fetch(request) {
            self.drives = drives
        }
    }

    func createDrive(name: String, dayDuration: Int32, nightDuration: Int32, distance: Double) {
        let drive = Drive(context: moc)
        drive.id = UUID()
        drive.date = Date()
        drive.name = name
        drive.dayDuration = dayDuration
        drive.nightDuration = nightDuration
        drive.distance = distance

        save(drive: drive)
    }
    
    func editDrive(drive: Drive, name: String, dayDuration: Int32, nightDuration: Int32, distance: Double) {
        drives.removeAll { previousDrive in
            drive == previousDrive
        }
        
        drive.name = name
        drive.dayDuration = dayDuration
        drive.nightDuration = nightDuration
        drive.distance = distance
        
        save(drive: drive)
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
        return TimeConverter().getMinutes(from: getTotalSeconds())
    }
    
    func getTotalHours() -> Int {
        return TimeConverter().getHours(from: getTotalSeconds())
    }
    
    func getTotalNightMinutes() -> Int {
        return TimeConverter().getMinutes(from: getTotalNightSeconds())
    }
    
    func getTotalNightHours() -> Int {
        return TimeConverter().getHours(from: getTotalNightSeconds())
    }
}
