//
//  LoggedDrives.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 12/6/22.
// This video was helpful with learning how to display entities using Core Data https://www.youtube.com/watch?v=O0FSDNOXCl0

import SwiftUI
import CoreData

struct LoggedDrivesView: View {
    @EnvironmentObject private var drivesDataModel: DrivesDataModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(drivesDataModel.drives) { drive in
                    LoggedDriveItemView(drive: drive)
                }
                .onDelete(perform: deleteDrive)
            }
            .listStyle(.plain)
        }
        .navigationTitle("Logged Drives")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: DriveDetailView()) {
                    Label("Add drive", systemImage: "plus")
                }.accessibilityIdentifier("AddDriveButton")
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }

    private func deleteDrive(offsets: IndexSet) {
        offsets.map { drivesDataModel.drives[$0] }.forEach {drive in
            drivesDataModel.deleteDrive(drive: drive)
        }
    }
}


struct LoggedDrivesView_Previews: PreviewProvider {
    static let moc = DataController.shared.container.viewContext

    static var previews: some View {
        LoggedDrivesView()
            .environmentObject(DrivesDataModel(moc: moc))
    }
}
