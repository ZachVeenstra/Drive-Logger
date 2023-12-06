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

class DriveViewModel: ObservableObject {
    let secondsInHour: Int = 3600
    let secondsInMinute: Int = 60
    @Published private(set) var secondsElapsed: Int = 0 {
        didSet{
            let tc = TimeConverter()
            let hours: Int = tc.getHours(from: self.secondsElapsed)
            let minutes: Int = tc.getMinutes(from: self.secondsElapsed)
            let seconds: Int = tc.getSeconds(from: self.secondsElapsed)
            
            timeLabel = "\(hours):\(minutes):\(seconds)"
        }
    }
    
    @Published private(set) var timeLabel = ""
    
    private var cancellable: AnyCancellable!
    private var stopwatch = StopwatchModel(timeInterval: 1)
    
    init() {
        cancellable = stopwatch.$timeElapsed
            .assign(to: \DriveViewModel.secondsElapsed, on: self)
        stopwatch.start()
    }
    
    deinit {
        stopwatch.stop()
        cancellable.cancel()
    }
    
    func getName() -> String {
        return "Drive on \(dateFormatter.string(from: Date()))"
    }
    
    func endDrive(drivesDataModel: DrivesDataModel) -> Void {
        drivesDataModel.createDrive(name: getName(), duration: Int32(secondsElapsed), distance: 0)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
