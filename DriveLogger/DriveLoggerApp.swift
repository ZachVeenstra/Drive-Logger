//
//  DriveLoggerApp.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 11/18/22.
//

import SwiftUI
@main
struct DriveLoggerApp: App {
    @StateObject private var dataController = DataController()
//    let moc = DataController().container.viewContext
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
//                .environmentObject(DataController(moc: moc))
        }
    }
}
