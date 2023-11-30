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
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var drive: FetchedResults<Drive>
    @Environment(\.dismiss) var dismiss
    
    @State private var addViewShowing = false
    
    private let SECONDS_IN_HOUR: Int32 = 3600
    private let SECONDS_IN_MINUTE: Int32 = 60
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(drive) { drive in
                        NavigationLink(destination: EditDriveView(drive: drive)) {
                            HStack{
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(drive.name!)
                                        .bold()
                                        .accessibilityIdentifier("DriveElementName")
                                    
                                    // Derives the hours and minutes from the duration of the drive in seconds.
                                    Text("\(drive.duration / SECONDS_IN_HOUR)hrs  \(drive.duration % SECONDS_IN_HOUR / SECONDS_IN_MINUTE)mins")
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
            offsets.map { drive[$0]}.forEach {drive in
                totalSeconds -= Int(drive.duration)
                managedObjContext.delete(drive)
            }
                DataController().saveDrive(context: managedObjContext)
        }
    }
}

#Preview {
    LoggedDrives()
}
