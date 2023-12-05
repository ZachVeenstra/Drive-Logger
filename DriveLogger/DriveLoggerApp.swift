//
//  DriveLoggerApp.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 11/18/22.
//

import SwiftUI
import CoreData

@main
struct DriveLoggerApp: App {
//    @StateObject private var dataController = DataController()
    @StateObject private var drivesViewModel = DrivesViewModel()
//    @StateObject private var drivesViewModel = DrivesViewModel()
//    let moc = DataController().container.viewContext
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, drivesViewModel.container.viewContext)
//                .environmentObject(DrivesViewModel())
        }
    }
}
