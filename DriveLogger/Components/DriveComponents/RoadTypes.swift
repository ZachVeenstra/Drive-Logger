//
//  RoadTypes.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/28/24.
//

import SwiftUI

enum RoadTypes: CaseIterable, Identifiable, CustomStringConvertible {
    case city
    case highway
    case residential
    case rural

    var id: Self { self }

    var description: String {
        switch self {
        case .city:
            return "City"
        case .highway:
            return "Highway"
        case .residential:
            return "Residential"
        case .rural:
            return "Rural"
        }
    }

    var symbol: String {
        switch self {
        case .city:
            return "custom.building.2.rectangle"
        case .highway:
            return "custom.gauge.with.dots.needle.67percent.rectangle"
        case .residential:
            return "custom.house.lodge.rectangle"
        case .rural:
            return "custom.tree.rectangle"
        }
    }

    var selectedSymbol: String {
        switch self {
        case .city:
            return "custom.building.2.rectangle.fill"
        case .highway:
            return "custom.gauge.with.dots.needle.67percent.rectangle.fill"
        case .residential:
            return "custom.house.lodge.rectangle.fill"
        case .rural:
            return "custom.tree.rectangle.fill"
        }
    }
}
