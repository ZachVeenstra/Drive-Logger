//
//  LoggedDrives.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 12/6/22.
// This video was helpful with learning how to display entities using Core Data https://www.youtube.com/watch?v=O0FSDNOXCl0

import SwiftUI
import CoreData

struct LoggedDrives: View {
    @AppStorage("totalSeconds") private var totalSeconds: Int = 0
    @StateObject private var drivesViewModel = DrivesViewModel()
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var addViewShowing = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(drivesViewModel.drives) { drive in
                        NavigationLink(destination: AddDriveView(drive: drive)) {
                            HStack{
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(drive.name!)
                                        .bold()
                                        .accessibilityIdentifier("DriveElementName")
                                    
                                    Text("\(drive.hours)hrs  \(drive.minutes)mins")
                                        .accessibilityIdentifier("DriveElementTime")
                                }
                            }
                        }
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
            offsets.map { drivesViewModel.drives[$0]}.forEach {drive in
                drivesViewModel.deleteDrive(moc: moc, drive: drive)
            }
        }
    }
}

#Preview {
    LoggedDrives()
}
