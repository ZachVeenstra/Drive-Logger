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
            }
            Section {
                Text("Drive Name")
                    .font(.title3)
                    .fontWeight(.bold)

                TextField("Name", text: $viewModel.name)
                    .accessibilityIdentifier("NameField")
                if viewModel.didUpdateDate {
                    Button("Recalculate Name") {
                        viewModel.recalculateName()
                    }
                }
            }
            Section {
                Text("Day Duration")
                    .font(.title3)
                    .fontWeight(.bold)

                HStack {
                    TimePickerView(title: "hours", range: 0...23, selection: $viewModel.dayHours)
                    TimePickerView(title: "min", range: 0...59, selection: $viewModel.dayMinutes)
                    TimePickerView(title: "sec", range: 0...59, selection: $viewModel.daySeconds)
                }
            }
            Section {
                Text("Night Duration")
                    .font(.title3)
                    .fontWeight(.bold)

                HStack {
                    TimePickerView(title: "hours", range: 0...23, selection: $viewModel.nightHours)
                    TimePickerView(title: "min", range: 0...59, selection: $viewModel.nightMinutes)
                    TimePickerView(title: "sec", range: 0...59, selection: $viewModel.nightSeconds)
                }
            }
            Section {
                Text("Drive Distance")
                    .font(.title3)
                    .fontWeight(.bold)

                TextField("Distance", text: $viewModel.distance)
                    .keyboardType(.numberPad)
                    .accessibilityIdentifier("DistanceField")

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


private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


struct AddDriveView_Previews: PreviewProvider {
    static let moc = DataController.shared.container.viewContext
    
    static var previews: some View {
        let viewModel = DriveDetailViewModel()
        DriveDetailView(viewModel: viewModel)
            .environmentObject(DrivesDataModel(moc: moc))
    }
}
