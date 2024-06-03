//
//  TimeConverter.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 12/5/23.
//

struct TimeConverter {
    static private let secondsInHour: Int = 3600
    static private let secondsInMinute: Int = 60

    static func getSeconds(from seconds: Int) -> Int {
        return seconds % secondsInMinute
    }
    
    static func getMinutes(from seconds: Int) -> Int {
        return seconds % secondsInHour / secondsInMinute
    }
    
    static func getHours(from seconds: Int) -> Int {
        return seconds / secondsInHour
    }
    
    static func hoursToSeconds(from hours: Int) -> Int {
        return hours * secondsInHour
    }
    
    static func minutesToSeconds(from minutes: Int) -> Int {
        return minutes * secondsInMinute
    }
}
