//
//  DriveModel.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 12/2/23.
//

import Foundation
import SwiftUI
import CoreData
import Combine
import ActivityKit

@MainActor
class DriveViewModel: ObservableObject {
    @Published private(set) var startTime: Date
    
    private var liveActivity: Activity<DriveLoggerWidgetAttributes>? = nil
    
    private let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    init() {
        startTime = .now
        
        self.startLiveActivity()
    }
    
    func getName() -> String {
        return "Drive on \(dateFormatter.string(from: Date()))"
    }
    
    func endDrive(drivesDataModel: DrivesDataModel) -> Void {
        drivesDataModel.createDrive(
            name: getName(),
            duration: Int32(Date.now.timeIntervalSince(startTime)),
            distance: 0
        )
        
        Task {
            await self.endLiveActivity()
        }
    }
}

private extension DriveViewModel {
    func startLiveActivity() {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                let attributes = DriveLoggerWidgetAttributes(startTime: startTime)
                let initialState = DriveLoggerWidgetAttributes.ContentState()
                
                liveActivity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: initialState, staleDate: nil),
                    pushType: nil)
            
            } catch {
                let errorMessage = """
                                    Couldn't start activity
                                    ------------------------
                                    \(String(describing: error))
                                    """
                print(errorMessage)
            }
        }
    }
    
    func endLiveActivity() async {
        guard let activity = liveActivity else {
            print("Activity was nil.")
            return
        }
        
        let finalContent = DriveLoggerWidgetAttributes.ContentState()
        
        await activity.end(
            ActivityContent(state: finalContent, staleDate: nil),
            dismissalPolicy: .immediate
        )
        
        self.liveActivity = nil
        print("Activity ended")
    }
}
