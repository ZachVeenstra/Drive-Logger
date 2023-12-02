//
//  HomeView.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 11/20/22.
//

import SwiftUI
import CoreData

struct HomeView: View {

    @StateObject private var homeModel = HomeModel()
    
    var body: some View {
        NavigationStack{
            VStack {
                VStack {
                    Text("Total Hours")
                        .fontWeight(.bold)
                    
                    Text("\(homeModel.getHours())hrs  \(homeModel.getMinutes())mins")
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
