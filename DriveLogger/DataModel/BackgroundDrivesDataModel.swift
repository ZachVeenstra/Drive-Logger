//
//  BackgroundDrivesDataModel.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/25/24.
//

import Foundation
import CoreData

class BackgroundDrivesDataModel: ObservableObject {
    static let shared = BackgroundDrivesDataModel()
    let dataModel: DrivesDataModel
    let backgroundContext: NSManagedObjectContext


    init() {
        backgroundContext = DataController.shared.container.newBackgroundContext()
        dataModel = DrivesDataModel(moc: backgroundContext)
    }

    func createDrive() async {
        await backgroundContext.perform {
            let weather = self.dataModel.createWeather(isClear: true, isRain: false, isSnow: false)
            self.dataModel.createDrive(date: Date(),
                                       name: "Background drive",
                                       dayDuration: 6000,
                                       nightDuration: 6600,
                                       distance: 200,
                                       weather: weather,
                                       notes: "Created in the background"
            )
        }
    }
}
