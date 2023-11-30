//
//  EditDriveView.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 12/8/22.
// This video was helpful with learning how to edit entities using Core Data https://www.youtube.com/watch?v=O0FSDNOXCl0

import SwiftUI

struct EditDriveView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("totalSeconds") private var totalSeconds: Int = 0
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    @State private var date: Date = Date()
    @State private var name: String = ""
    @State private var distance: String = "0"
    @State private var durationSeconds: Int32 = 0
    
    private let SECONDS_IN_HOUR: Int32 = 3600
    private let SECONDS_IN_MINUTE: Int32 = 60
    
    var drive: FetchedResults<Drive>.Element

    
    var body: some View {
        VStack {
            Form {
                Section {
                    Text("Drive Name")
                        .font(.title3)
                    TextField("\(drive.name!)", text: $name)
                        .onAppear() {
                            name = drive.name!
                            date = drive.date!
                            distance = String(drive.distance)
                            durationSeconds = drive.duration
                            hours = Int(durationSeconds / SECONDS_IN_HOUR)
                            minutes = Int(durationSeconds % SECONDS_IN_HOUR / SECONDS_IN_MINUTE)
                            seconds = Int(durationSeconds % SECONDS_IN_MINUTE)
                        }
                        .accessibilityIdentifier("NameField")
                }

                Section {
                    Text("Drive Duration")
                        .font(.title3)
                    HStack {
                        TimePickerView(title: "hours", range: 0...23, selection: $hours)
                        TimePickerView(title: "min", range: 0...59, selection: $minutes)
                        TimePickerView(title: "sec", range: 0...59, selection: $seconds)
                    }
                }
                
                Section {
                    Text("Drive Distance")
                        .font(.title3)
                    TextField("Distance", text: $distance)
                        .keyboardType(.numberPad)
                        .accessibilityIdentifier("DistanceField")
                }
                
                Button("Submit") {
                    //TODO: Add an error if duration isn't a number
                    
                    let newDuration: Int32 = (Int32(self.hours) * SECONDS_IN_HOUR) + (Int32(self.minutes) * SECONDS_IN_MINUTE) + Int32(self.seconds)
                    
                    // Update the total seconds with the difference of the new duration and the old duration.
                    self.totalSeconds += Int(newDuration) - Int(durationSeconds)
                    
                    DataController().addDrive(drive: drive, name: name, duration: newDuration, distance: Double(distance) ?? 0, context: managedObjContext)
                    
                    dismiss()
                }
                .accessibilityIdentifier("SubmitButton")
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
