//
//  DriveDetailView.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 12/3/22.
//
// Lots of inspiration from: https://www.youtube.com/watch?v=O0FSDNOXCl0

import SwiftUI

struct DriveDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var drivesDataModel: DrivesDataModel
    @State private var dayHours: Int = 0
    @State private var dayMinutes: Int = 0
    @State private var daySeconds: Int = 0
    @State private var nightHours: Int = 0
    @State private var nightMinutes: Int = 0
    @State private var nightSeconds: Int = 0
    @State private var date: Date = Date()
    @State private var name: String = Date().formattedDate
    @State private var distance: String = "0"
    @State private var didUpdateDate: Bool = false
    private var dayDurationSeconds: Int32 {
        return Int32((TimeConverter().hoursToSeconds(from: self.dayHours)) +
                     (TimeConverter().minutesToSeconds(from: self.dayMinutes)) +
                     self.daySeconds)
    }
    private var nightDurationSeconds: Int32 {
        return Int32((TimeConverter().hoursToSeconds(from: self.nightHours)) +
                     (TimeConverter().minutesToSeconds(from: self.nightMinutes)) +
                     self.nightSeconds)
    }
    
    var drive: Drive?
    
    var body: some View {
        Form {
            Section {
                DatePicker(LocalizedStringKey(stringLiteral: "Date"), selection: $date)
                    .font(.title3)
                    .fontWeight(.bold)
                    .onChange(of: date) { oldValue, newValue in
                        didUpdateDate.toggle()
                    }
            }
            Section {
                Text("Drive Name")
                    .font(.title3)
                    .fontWeight(.bold)
                    .onAppear() {
                        if drive != nil {
                            dayHours = TimeConverter().getHours(from: Int(drive!.dayDuration))
                            dayMinutes = TimeConverter().getMinutes(from: Int(drive!.dayDuration))
                            daySeconds = TimeConverter().getSeconds(from: Int(drive!.dayDuration))
                            nightHours = TimeConverter().getHours(from: Int(drive!.nightDuration))
                            nightMinutes = TimeConverter().getMinutes(from: Int(drive!.nightDuration))
                            nightSeconds = TimeConverter().getSeconds(from: Int(drive!.nightDuration))
                            name = drive!.name ?? ""
                            date = drive!.date!
                            distance = String(drive!.distance)
                        }
                    }

                TextField("Name", text: $name)
                    .accessibilityIdentifier("NameField")
                if didUpdateDate {
                    Button("Recalculate Name") {
                        name = date.formattedDate
                        didUpdateDate.toggle()
                    }
                }
            }

            Section {
                Text("Day Duration")
                    .font(.title3)
                    .fontWeight(.bold)

                HStack {
                    TimePickerView(title: "hours", range: 0...23, selection: $dayHours)
                    TimePickerView(title: "min", range: 0...59, selection: $dayMinutes)
                    TimePickerView(title: "sec", range: 0...59, selection: $daySeconds)
                }
            }

            Section {
                Text("Night Duration")
                    .font(.title3)
                    .fontWeight(.bold)

                HStack {
                    TimePickerView(title: "hours", range: 0...23, selection: $nightHours)
                    TimePickerView(title: "min", range: 0...59, selection: $nightMinutes)
                    TimePickerView(title: "sec", range: 0...59, selection: $nightSeconds)
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
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    submit()
                    dismiss()
                }
                .accessibilityIdentifier("SubmitButton")
            }
        }
    }
    
    func submit() {
        if drive != nil {
            drivesDataModel.editDrive(drive: drive!, name: name, dayDuration: dayDurationSeconds, nightDuration: nightDurationSeconds, distance: Double(distance) ?? 0)
        } else {
            drivesDataModel.createDrive(name: name, dayDuration: dayDurationSeconds, nightDuration: nightDurationSeconds, distance: Double(distance) ?? 0)
        }
    }
}


private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


struct AddDriveView_Previews: PreviewProvider {
    static let moc = DataController.shared.container.viewContext
    
    static var previews: some View {
        DriveDetailView()
            .environmentObject(DrivesDataModel(moc: moc))
    }
}
