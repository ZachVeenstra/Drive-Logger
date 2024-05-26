//
//  HomeView.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 11/20/22.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @EnvironmentObject private var drivesDataModel: DrivesDataModel
    
    var body: some View {
        NavigationStack{
            VStack {
                VStack {
                    Text("Total Time")
                        .fontWeight(.bold)
                    
                    Text("\(drivesDataModel.getTotalHours())hrs  \(drivesDataModel.getTotalMinutes())mins")
                        .fontWeight(.semibold)
                        .accessibilityIdentifier("TotalTime")
                }
                .font(.largeTitle)
                
                VStack {
                    Text("Total Night Time")
                        .fontWeight(.bold)
                    Text("\(drivesDataModel.getTotalNightHours())hrs  \(drivesDataModel.getTotalNightMinutes())mins")
                        .fontWeight(.semibold)
                        .accessibilityIdentifier("TotalTime")
                }
                
                VStack {
                    NavigationLink(destination: DriveView()) {
                        Text("Start Drive")
                    }
                    .buttonStyle(ActionButtonStyle())
                    
                    NavigationLink(destination: LoggedDrivesView()) {
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


struct HomeView_Previews: PreviewProvider {
    static let moc = DataController.shared.container.viewContext
    
    static var previews: some View {
        HomeView()
            .environmentObject(DrivesDataModel(moc: moc))
    }
}
