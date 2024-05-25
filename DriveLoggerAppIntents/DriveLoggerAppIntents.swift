//
//  DriveLoggerAppIntents.swift
//  DriveLoggerAppIntents
//
//  Created by Zach Veenstra on 5/25/24.
//

import AppIntents

struct DriveLoggerAppIntents: AppIntent {
    static var title: LocalizedStringResource = "DriveLoggerAppIntents"
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
