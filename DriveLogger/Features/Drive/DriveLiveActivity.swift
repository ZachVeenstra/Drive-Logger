//
//  DriveLiveActivity.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/20/24.
//

import Foundation
import ActivityKit

extension DriveViewModel {
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
