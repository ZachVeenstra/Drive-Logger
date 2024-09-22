//
//  EndDriveIntent.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 6/3/24.
//


import AppIntents

struct EndDriveIntent: AppIntent {
    static var title: LocalizedStringResource = "End Drive"

    func perform() async throws -> some IntentResult {
        await BackgroundDrivesDataModel.shared.endDrive()
        return .result()
    }
}
