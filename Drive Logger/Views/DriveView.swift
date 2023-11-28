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
    
    private let stopWatch = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let SECONDS_IN_HOUR: Int32 = 3600
    private let SECONDS_IN_MINUTE: Int32 = 60
    
    var body: some View {
        ZStack{
            VStack{
                
                Text(("\(currentSeconds/SECONDS_IN_HOUR):\(currentSeconds%SECONDS_IN_HOUR/SECONDS_IN_MINUTE):\(currentSeconds%SECONDS_IN_MINUTE)"))
                    .padding(.bottom, 100.0)
                    .onReceive(stopWatch) { _ in
                        if timerRunning {
                            currentSeconds += 1
                        }
                    }
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                
                
                
                Button("End Drive") {
                    timerRunning.toggle()
                    let drive = Drive(context: managedObjContext)

                    DataController().addDrive(drive: drive, name: name, duration: currentSeconds, distance: 0, context: managedObjContext)

                    totalSeconds += Int(currentSeconds)

                    dismiss()
                }
                    .frame(width: /*@START_MENU_TOKEN@*/150.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/75.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .background(Color.accentColor)
                    .cornerRadius(20.0)
                    .padding(.top, 100.0)
            }
        }
        .navigationTitle("Drive")
    }
    
}

// Taken from XCode's default persistence controller
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct DriveView_Previews: PreviewProvider {
    static var previews: some View {
        DriveView()
    }
}
