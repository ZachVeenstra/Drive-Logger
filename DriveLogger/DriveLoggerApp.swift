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
    let moc = DataController.shared.container.viewContext

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(DrivesDataModel(moc: moc))
        }
    }
}
