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
    
    private let BUTTON_WIDTH : Double = 200
    private let BUTTON_HEIGHT : Double = 70
    private let C_RADIUS : Double = 15
    private let SECONDS_IN_HOUR: Int = 3600
    private let SECONDS_IN_MINUTE: Int = 60

    var body: some View {
        NavigationView{
            ZStack{
                VStack(alignment: .center){
                    
                    // Displays the title
                    Text("Total Hours")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // Displays the total driving time.
                    Text("\(totalSeconds / SECONDS_IN_HOUR)hrs  \(totalSeconds % SECONDS_IN_HOUR / SECONDS_IN_MINUTE)mins")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 50)
                        .accessibilityIdentifier("TotalTime")
                    
                    VStack{
                        
                        // The Start Drive Button links to the DriveView.
                        NavigationLink(destination: DriveView()) {
                            Text("Start Drive")
                        }
                            .frame(width: BUTTON_WIDTH, height: BUTTON_HEIGHT)
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.heavy)
                            .background(Color.accentColor)
                            .cornerRadius(C_RADIUS)
                            .padding(.top, 50)
                        
                        // The Add Drive button links the the logged drives view.
                        NavigationLink(destination: LoggedDrives()) {
                            Text("Add Drive")
                        }
                            .frame(width: BUTTON_WIDTH, height: BUTTON_HEIGHT)
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.heavy)
                            .background(Color.accentColor)
                            .cornerRadius(C_RADIUS)
                    }
                }
            }
            .navigationTitle("Home")
        }
        // This makes sure the main view and (DriveView or LoggedDrives) aren't
        // displayed next to one another in landscape orientation
        .navigationViewStyle(.stack)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
