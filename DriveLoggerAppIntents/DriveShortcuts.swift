//
//  DriveShortcuts.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/25/24.
//

import AppIntents

struct DriveShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: StartDriveIntent(),
                    phrases: [
                        "Start a \(.applicationName)",
                        "Begin a \(.applicationName)",
                        "Start \(.applicationName)",
                        "Begin \(.applicationName)"
                    ],
                    shortTitle: "Start Drive",
                    systemImageName: "car.fill")
    }
}
