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
    
    @State private var addViewShowing = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List {
                    ForEach(drivesDataModel.drives.sorted(using: [SortDescriptor(\.date, order: .reverse)])) { drive in
                        LoggedDriveItemView(drive: drive)
                    }
                    .onDelete(perform: deleteDrive)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Logged Drives")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addViewShowing.toggle()
                    } label: {
                        Label("Add drive", systemImage: "plus")
                    }.accessibilityIdentifier("AddDriveButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .sheet(isPresented: $addViewShowing) {
                AddDriveView()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func deleteDrive(offsets: IndexSet) {
        withAnimation {
            offsets.map { drivesDataModel.drives[$0]}.forEach {drive in
                drivesDataModel.deleteDrive(drive: drive)
            }
        }
    }
}

#Preview {
    LoggedDrivesView()
}
