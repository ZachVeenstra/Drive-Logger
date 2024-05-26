//
//  StartDriveIntent.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/25/24.
//

//import AppIntents
//
//struct StartDriveIntent: AppIntent {
//    static var title: LocalizedStringResource = "Start Drive"
//
//    func perform() async throws -> some IntentResult {
//        let backgroundContext = DataController.shared.container.newBackgroundContext()
//        await backgroundContext.perform {
//            DrivesDataModel(moc: backgroundContext).createDrive(name: "Lol 2", dayDuration: 6000, nightDuration: 6600, distance: 200)
//            try! backgroundContext.save()
//        }
//
//        return .result()
//    }
//}
