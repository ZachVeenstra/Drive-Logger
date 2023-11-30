//
//  DriveView.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 11/23/22.
//

import SwiftUI

struct DriveView: View {
    
    @AppStorage("totalSeconds") private var totalSeconds: Int = 0
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) private var dismiss
    
    @State var timerRunning: Bool = true
    @State var currentSeconds: Int32 = 0
    @State private var name: String = "Drive on \(dateFormatter.string(from: Date()))"
    
    @State private var addViewShowing = false
    
    // Learned how to use timer here: https://www.youtube.com/watch?v=kIaO4UtzBHI
    
    // TODO: Make stopwatch work in background.
    private let stopWatch = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let secondsInHour: Int32 = 3600
    private let secondsInMinute: Int32 = 60
    
    var body: some View {
        VStack(spacing: 100) {
            Text("\(currentSeconds/secondsInHour):\(currentSeconds%secondsInHour/secondsInMinute):\(currentSeconds%secondsInMinute)")
                .onReceive(stopWatch) { _ in
                    if timerRunning {
                        currentSeconds += 1
                    }
                }
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Button("End Drive") {
                // TODO: Factor out this logic.
                timerRunning.toggle()
                let drive = Drive(context: managedObjContext)

                DataController().addDrive(drive: drive, name: name, duration: currentSeconds, distance: 0, context: managedObjContext)
                totalSeconds += Int(currentSeconds)
                dismiss()
            }
            .buttonStyle(ActionButtonStyle())
        }
        .fixedSize()
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Drive")
    }
}

private let dateFormatter: DateFormatter = {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    DriveView()
}
