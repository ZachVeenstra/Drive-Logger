//
//  LoggedDriveItemView.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 12/5/23.
//

import SwiftUI

struct LoggedDriveItemView: View {
    @ObservedObject var drive: Drive
    var body: some View {
        NavigationLink(destination: DriveDetailView(drive: drive)) {
            VStack(alignment: .leading, spacing: 6) {
                Text(drive.name ?? "")
                    .bold()
                    .accessibilityIdentifier("DriveElementName")

                Text("\(TimeConverter().getHours(from: Int(drive.dayDuration + drive.nightDuration)))hrs  \(TimeConverter().getMinutes(from: Int(drive.dayDuration + drive.nightDuration)))mins")
                    .accessibilityIdentifier("DriveElementTime")
            }
        }
    }
}
