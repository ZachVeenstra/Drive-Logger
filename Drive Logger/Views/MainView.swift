//
//  SwiftUIView.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 11/20/22.
//

import SwiftUI
import CoreData

struct MainView: View {
    // Learned how to use UserDefaluts here: https://www.hackingwithswift.com/books/ios-swiftui/storing-user-settings-with-userdefaults
    
    // Stores the total amount of seconds the driver has driven
    @AppStorage("totalSeconds") private var totalSeconds: Int = 0
    
    private let SECONDS_IN_HOUR: Int = 3600
    private let SECONDS_IN_MINUTE: Int = 60

    var body: some View {
        NavigationStack{
            VStack {
                VStack {
                    Text("Total Hours")
                        .fontWeight(.bold)
                    
                    Text("\(totalSeconds / SECONDS_IN_HOUR)hrs  \(totalSeconds % SECONDS_IN_HOUR / SECONDS_IN_MINUTE)mins")
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
    MainView()
}
