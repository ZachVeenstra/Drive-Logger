//
//  LoggedDriveItemView.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 12/5/23.
//

import SwiftUI

struct LoggedDriveItemView: View {
    @State var drive: Drive
    var body: some View {
        NavigationLink(destination: AddDriveView(drive: drive)) {
            HStack{
                VStack(alignment: .leading, spacing: 6) {
                    Text(drive.name!)
                        .bold()
                        .accessibilityIdentifier("DriveElementName")
                    
                    Text("\(drive.hours)hrs  \(drive.minutes)mins")
                        .accessibilityIdentifier("DriveElementTime")
                }
            }
        }
    }
}
