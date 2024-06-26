//
//  DriveDetailView.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 12/3/22.
//
// Lots of inspiration from: https://www.youtube.com/watch?v=O0FSDNOXCl0

import SwiftUI

struct DriveDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var drivesDataModel: DrivesDataModel
    @StateObject var viewModel: DriveDetailViewModel

    var body: some View {
        Form {
            Section {
                DatePicker(LocalizedStringKey(stringLiteral: "Date"), selection: $viewModel.date)
                    .font(.title3)
                    .fontWeight(.bold)
                    .onChange(of: viewModel.date) {
                        viewModel.didUpdateDate = true
                    }
                    .labelsHidden()
            } header: {
                Text("Date")
                    .font(.title3)
                    .fontWeight(.bold)
            }

            Section {
                TextField("Name", text: $viewModel.name)
                    .accessibilityIdentifier("NameField")
                if viewModel.didUpdateDate {
                    Button("Recalculate Name") {
                        viewModel.recalculateName()
                    }
                }
            } header: {
                Text("Drive Name")
                    .font(.title3)
                    .fontWeight(.bold)
            }

            Section {
                HStack {
                    TimePickerView(title: "hours", range: 0...23, selection: $viewModel.dayHours)
                    TimePickerView(title: "min", range: 0...59, selection: $viewModel.dayMinutes)
                    TimePickerView(title: "sec", range: 0...59, selection: $viewModel.daySeconds)
                }
            } header: {
                Text("Day Duration")
                    .font(.title3)
                    .fontWeight(.bold)
            }

            Section {
                HStack {
                    TimePickerView(title: "hours", range: 0...23, selection: $viewModel.nightHours)
                    TimePickerView(title: "min", range: 0...59, selection: $viewModel.nightMinutes)
                    TimePickerView(title: "sec", range: 0...59, selection: $viewModel.nightSeconds)
                }
            } header: {
                Text("Night Duration")
                    .font(.title3)
                    .fontWeight(.bold)
            }

            Section {
                RoadMultiPicker(viewModel: viewModel.roadViewModel)
            } header: {
                Text("Road Types")
                    .font(.title3)
                    .fontWeight(.bold)
            }

            Section {
                WeatherMultiPicker(viewModel: viewModel.weatherViewModel)
            } header: {
                Text("Weather Conditions")
                    .font(.title3)
                    .fontWeight(.bold)
            }

            Section {
                TextField("Distance", text: $viewModel.distance)
                    .keyboardType(.numberPad)
                    .accessibilityIdentifier("DistanceField")
            } header: {
                Text("Drive Distance")
                    .font(.title3)
                    .fontWeight(.bold)
            }

            Section {
                TextEditor(text: $viewModel.notes)
            } header: {
                Text("Notes")
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    viewModel.submit(drivesDataModel: drivesDataModel)
                    dismiss()
                }
                .accessibilityIdentifier("SubmitButton")
            }
        }
    }
}

struct AddDriveView_Previews: PreviewProvider {
    static let moc = DataController.shared.container.viewContext
    
    static var previews: some View {
        let viewModel = DriveDetailViewModel()
        DriveDetailView(viewModel: viewModel)
            .environmentObject(DrivesDataModel(moc: moc))
    }
}
