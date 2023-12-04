//
//  DataController.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 12/6/22.
//
// This video was helpful with learning how to save entities using Core Data https://www.youtube.com/watch?v=O0FSDNOXCl0
import Foundation
import CoreData
import SwiftUI

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "DriveModel")
    
    static let shared = DataController()
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load data \(error.localizedDescription)")
            }
        }
    }
    
    func saveDrive(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("The drive was saved.")
        } catch {
            print("The drive could not be saved")
        }
    }
    
    func getTotalTime(context: NSManagedObjectContext) -> Int32 {
        var totalTime: Int32 = 0
        
        for drive in context.registeredObjects {
            totalTime += drive.value(forKey: "duration") as! Int32
        }
        
        return totalTime
    }
    
    func addDrive(drive: Drive, name: String, duration: Int32, distance: Double, context: NSManagedObjectContext) {
        drive.id = UUID()
        drive.date = Date()
        drive.name = name
        drive.duration = duration
        drive.distance = distance
    
        saveDrive(context: context)
    }
}
