//
//  DriveView.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 11/23/22.
//

import SwiftUI

struct DriveView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var drivesDataModel: DrivesDataModel
    @StateObject private var driveViewModel = DriveViewModel()
    
    var body: some View {
        VStack(spacing: 100) {
            Text(driveViewModel.startTime, style: .relative)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Button("End Drive") {
                driveViewModel.endDrive(drivesDataModel: drivesDataModel)
                dismiss()
            }
            .buttonStyle(ActionButtonStyle())
            .fixedSize()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Drive")
    }
}


struct DriveView_Previews: PreviewProvider {
    static let moc = DataController.shared.container.viewContext
    
    static var previews: some View {
        DriveView()
            .environmentObject(DrivesDataModel(moc: moc))
    }
}
