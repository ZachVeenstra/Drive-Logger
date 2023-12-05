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

//@MainActor
class DataController: ObservableObject {
    
    static let shared = DataController()
    
    let container = NSPersistentContainer(name: "DriveModel")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load data \(error.localizedDescription)")
            }
        }
    }
}
