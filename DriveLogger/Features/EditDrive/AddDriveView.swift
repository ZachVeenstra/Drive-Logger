//
//  AddDriveView.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 12/3/22.
//
// Lots of inspiration from: https://www.youtube.com/watch?v=O0FSDNOXCl0

import SwiftUI

struct AddDriveView: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @AppStorage("totalSeconds") private var totalSeconds: Int = 0
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    @State private var date: Date = Date()
    @State private var name: String = "Drive on \(dateFormatter.string(from: Date()))"
    @State private var distance: String = "0"
    @State private var durationSeconds: Int32 = 0
    
    private let SECONDS_IN_HOUR: Int32 = 3600
    private let SECONDS_IN_MINUTE: Int32 = 60

    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    Section {
                        Text("Drive Name")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        TextField("Name", text: $name)
                            .accessibilityIdentifier("NameField")
                    }

                    Section {
                        Text("Drive Duration")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        HStack {
                            TimePickerView(title: "hours", range: 0...23, selection: $hours)
                            TimePickerView(title: "min", range: 0...59, selection: $minutes)
                            TimePickerView(title: "sec", range: 0...59, selection: $seconds)
                        }
                    }
                                        
                    Section {
                        Text("Drive Distance")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        TextField("Distance", text: $distance)
                            .keyboardType(.numberPad)
                            .accessibilityIdentifier("DistanceField")
                        
                    }
                    Button("Submit") {
                        //TODO: Add an error if duration isn't a number
                        let drive = Drive(context: managedObjContext)
                        
                        let duration: Int32 = (Int32(self.hours) * SECONDS_IN_HOUR) + (Int32(self.minutes) * SECONDS_IN_MINUTE) + Int32(self.seconds)
                        self.totalSeconds += Int(duration)
                        
                        DataController().addDrive(drive: drive, name: name, duration: duration, distance: Double(distance) ?? 0, context: managedObjContext)
                        
                        dismiss()
                    }
                    .accessibilityIdentifier("SubmitButton")
                }
            }
        }
    }
}

// Taken from XCode's default persistence controller
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    AddDriveView()
}
