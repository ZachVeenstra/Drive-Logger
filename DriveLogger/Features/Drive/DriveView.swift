//
//  DriveView.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 11/23/22.
//

import SwiftUI

struct DriveView: View {
    
    @AppStorage("totalSeconds") private var totalSeconds: Int = 0
//    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) private var dismiss
//    @StateObject private var drivesViewModel = DrivesViewModel()
    @StateObject private var driveViewModel = DriveViewModel()
    @EnvironmentObject private var drivesViewModel: DrivesViewModel
    
    var body: some View {
        VStack(spacing: 100) {
            Text("\(driveViewModel.timeLabel)")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Button("End Drive") {
                endDrive()
                dismiss()
            }
            .buttonStyle(ActionButtonStyle())
        }
        .fixedSize()
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Drive")
    }
    
    func endDrive() -> Void {
        drivesViewModel.createDrive(name: driveViewModel.getName(), duration: Int32(driveViewModel.secondsElapsed), distance: 0)
        totalSeconds += driveViewModel.secondsElapsed
    }
}

#Preview {
    DriveView()
}
