//
//  DriveLoggerWidgetLiveActivity.swift
//  DriveLoggerWidget
//
//  Created by Zach Veenstra on 5/6/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DriveLoggerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {}
    
    var startTime: Date
}

struct DriveLoggerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DriveLoggerWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                Image(systemName: "list.clipboard")
                    .foregroundStyle(Color.accentColor)
                Text(context.attributes.startTime, style: .relative)
                    .font(.title)
            }
            .padding()
            .activityBackgroundTint(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.attributes.startTime, style: .relative)
                        .font(.largeTitle)
                }
            } compactLeading: {
                Image(systemName: "list.clipboard")
                    .foregroundStyle(Color.accentColor)
            } compactTrailing: {
                Text(context.attributes.startTime, style: .timer)
                    .frame(maxWidth: .minimum(50, 50), alignment: .leading)
            } minimal: {
                Image(systemName: "list.clipboard")
                    .foregroundStyle(Color.accentColor)
            }
        }
    }
}

extension DriveLoggerWidgetAttributes {
    fileprivate static var preview: DriveLoggerWidgetAttributes {
        DriveLoggerWidgetAttributes(startTime: .now)
    }
}

extension DriveLoggerWidgetAttributes.ContentState {
    fileprivate static var state: DriveLoggerWidgetAttributes.ContentState {
        DriveLoggerWidgetAttributes.ContentState()
     }
}

#Preview("Notification", as: .content, using: DriveLoggerWidgetAttributes.preview) {
   DriveLoggerWidgetLiveActivity()
} contentStates: {
    DriveLoggerWidgetAttributes.ContentState.state
}
