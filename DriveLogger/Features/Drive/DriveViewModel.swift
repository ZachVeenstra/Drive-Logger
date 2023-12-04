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
            timeLabel = "\(getHours()):\(getMinutes()):\(getSeconds())"
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
    
//    func endDrive() -> Void {
//        let drive = Drive(context: moc)
//
//        DataController().addDrive(drive: drive, name: getName(), duration: Int32(secondsElapsed), distance: 0, context: moc)
//    }
    
    private func getHours() -> Int {
        return self.secondsElapsed / secondsInHour
    }
    
    private func getMinutes() -> Int {
        return self.secondsElapsed % secondsInHour / secondsInMinute
    }
    
    private func getSeconds() -> Int {
        return self.secondsElapsed % secondsInMinute
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
