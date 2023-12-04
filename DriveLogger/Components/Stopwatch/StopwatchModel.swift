//
//  StopwatchModel.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 12/4/23.
//  Inspiration: https://medium.com/swlh/introduction-to-mvvm-with-swiftui-and-combine-f2f7a0dc8585
//

import Combine
import Foundation

enum StopwatchState {
    case running
    case notRunning
}

final class StopwatchModel {
    private let timeInterval: TimeInterval
    private var timer: AnyCancellable!
    
    @Published var timeElapsed = 0
    
    required init (timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    func start() {
        timer = Timer.publish(every: timeInterval, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { _ in
                self.timeElapsed += 1
            })
    }
    
    func stop() {
        self.timeElapsed = 0
        self.timer?.cancel()
    }
}
