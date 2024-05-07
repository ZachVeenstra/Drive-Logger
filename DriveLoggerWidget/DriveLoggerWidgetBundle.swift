//
//  DriveLoggerWidgetBundle.swift
//  DriveLoggerWidget
//
//  Created by Zach Veenstra on 5/6/24.
//

import WidgetKit
import SwiftUI

@main
struct DriveLoggerWidgetBundle: WidgetBundle {
    var body: some Widget {
        DriveLoggerWidget()
        DriveLoggerWidgetLiveActivity()
    }
}
