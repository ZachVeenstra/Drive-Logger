//
//  DriveDetailViewModel.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/26/24.
//

import Foundation

@MainActor

class DriveDetailViewModel: ObservableObject {
    @Published var dayHours: Int
    @Published var dayMinutes: Int
    @Published var daySeconds: Int
    @Published var nightHours: Int
    @Published var nightMinutes: Int
    @Published var nightSeconds: Int
    @Published var date: Date
    @Published var name: String
    @Published var distance: String
    @Published var didUpdateDate: Bool
    private var drive: Drive?

    private var dayDurationSeconds: Int32 {
        return Int32((TimeConverter.hoursToSeconds(from: self.dayHours)) +
                     (TimeConverter.minutesToSeconds(from: self.dayMinutes)) +
                     self.daySeconds)
    }
    private var nightDurationSeconds: Int32 {
        return Int32((TimeConverter.hoursToSeconds(from: self.nightHours)) +
                     (TimeConverter.minutesToSeconds(from: self.nightMinutes)) +
                     self.nightSeconds)
    }
    init() {
        dayHours = 0
        dayMinutes = 0
        daySeconds = 0
        nightHours = 0
        nightMinutes = 0
        nightSeconds = 0
        date = Date()
        name = Date().formattedDate
        distance = "0"
        drive = nil
        didUpdateDate = false
    }

    init(drive: Drive) {
        dayHours = TimeConverter.getHours(from: Int(drive.dayDuration))
        dayMinutes = TimeConverter.getMinutes(from: Int(drive.dayDuration))
        daySeconds = TimeConverter.getSeconds(from: Int(drive.dayDuration))
        nightHours = TimeConverter.getHours(from: Int(drive.nightDuration))
        nightMinutes = TimeConverter.getMinutes(from: Int(drive.nightDuration))
        nightSeconds = TimeConverter.getSeconds(from: Int(drive.nightDuration))
        name = drive.name ?? ""
        date = drive.date ?? Date()
        distance = String(drive.distance)
        self.drive = drive
        didUpdateDate = false
    }

    func submit(drivesDataModel: DrivesDataModel) {
        if let drive {
            drivesDataModel.editDrive(drive: drive, date: date, name: name, dayDuration: dayDurationSeconds, nightDuration: nightDurationSeconds, distance: Double(distance) ?? 0)
        } else {
            drivesDataModel.createDrive(date: date, name: name, dayDuration: dayDurationSeconds, nightDuration: nightDurationSeconds, distance: Double(distance) ?? 0)
        }
    }

    func recalculateName() {
        name = date.formattedDate
        didUpdateDate = false
    }
}
