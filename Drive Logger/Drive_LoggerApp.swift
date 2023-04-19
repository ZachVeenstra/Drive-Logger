//
//  Drive_LoggerApp.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 11/18/22.
//

import SwiftUI
@main
struct Drive_LoggerApp: App {
    @StateObject private var dataController = DataController()
    
    //let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
