//
//  HomeView.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 11/20/22.
//

import SwiftUI
import CoreData

struct HomeView: View {
//    @StateObject private var drivesViewModel = DrivesViewModel()
    
    @EnvironmentObject private var drivesViewModel: DrivesViewModel
    
    var body: some View {
        NavigationStack{
            VStack {
                VStack {
                    Text("Total Hours")
                        .fontWeight(.bold)
                    
                    Text("\(drivesViewModel.getHours(from: drivesViewModel.getTotalSeconds()))hrs  \(drivesViewModel.getMinutes(from: drivesViewModel.getTotalSeconds()))mins")
                        .fontWeight(.semibold)
                        .accessibilityIdentifier("TotalTime")
                }
                .font(.largeTitle)
                
                VStack {
                    NavigationLink(destination: DriveView()) {
                        Text("Start Drive")
                    }
                    .buttonStyle(ActionButtonStyle())
                    
                    NavigationLink(destination: LoggedDrives()) {
                        Text("Logged Drives")
                    }
                    .buttonStyle(ActionButtonStyle())
                }
                .padding()
                
            }
            .fixedSize()
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
