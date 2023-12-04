//
//  HomeModel.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 11/30/23.
//

import Foundation
import SwiftUI

class HomeModel: ObservableObject {
    private let secondsInHour: Int = 3600
    private let secondsInMinute: Int = 60
    
    @AppStorage("totalSeconds") private var totalSeconds: Int = 0
    
    @Published var seconds: Int = 0
    @Published var hours: Int = 0
    
    func getHours() -> Int {
        return totalSeconds / secondsInHour
    }
    
    func getMinutes() -> Int {
        return totalSeconds % secondsInHour / secondsInMinute
    }
}
