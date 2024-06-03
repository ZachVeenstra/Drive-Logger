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
    case multilane
    case residential
    case roundabout
    case rural

    var id: Self { self }

    var description: String {
        switch self {
        case .city:
            return "City"
        case .multilane:
            return "Multi-Lane"
        case .highway:
            return "Highway"
        case .residential:
            return "Residential"
        case .roundabout:
            return "Roundabout"
        case .rural:
            return "Rural"
        }
    }

    var symbol: String {
        switch self {
        case .city:
            return "custom.building.2.rectangle"
        case .multilane:
            return "custom.road.lanes.rectangle"
        case .highway:
            return "custom.gauge.with.dots.needle.67percent.rectangle"
        case .residential:
            return "custom.house.lodge.rectangle"
        case .roundabout:
            return "custom.circle.circle.rectangle"
        case .rural:
            return "custom.tree.rectangle"
        }
    }

    var selectedSymbol: String {
        switch self {
        case .city:
            return "custom.building.2.rectangle.fill"
        case .multilane:
            return "custom.road.lanes.rectangle.fill"
        case .highway:
            return "custom.gauge.with.dots.needle.67percent.rectangle.fill"
        case .residential:
            return "custom.house.lodge.rectangle.fill"
        case .roundabout:
            return "custom.circle.circle.rectangle.fill"
        case .rural:
            return "custom.tree.rectangle.fill"
        }
    }
}
