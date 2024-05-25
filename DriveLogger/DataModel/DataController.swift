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

    static let shared = DataController()

    static var preview: DataController = {
        let result = DataController(inMemory: true)
        let viewContext = result.container.viewContext

        return result
    }()

    let context = NSManagedObjectContext(.privateQueue)

    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DriveModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        let driveModelURL = URL.storeURL(for: "group.com.zachveenstra.drivelogger", databaseName: "DriveModel")
        let storeDescription = NSPersistentStoreDescription(url: driveModelURL)
        container.persistentStoreDescriptions = [storeDescription]

        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load data \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

public extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Unable to create URL for \(appGroup)")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
