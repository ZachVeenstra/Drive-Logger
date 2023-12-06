//
//  TimeConverter.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 12/5/23.
//

import Foundation

class TimeConverter {
    private let secondsInHour: Int = 3600
    private let secondsInMinute: Int = 60
    
    func getMinutes(from seconds: Int) -> Int {
        return seconds % secondsInHour / secondsInMinute
    }
    
    func getHours(from seconds: Int) -> Int {
        return seconds / secondsInHour
    }
    
    func hoursToSeconds(from hours: Int) -> Int {
        return hours * secondsInHour
    }
    
    func minutesToSeconds(from minutes: Int) -> Int {
        return minutes * secondsInMinute
    }
}
