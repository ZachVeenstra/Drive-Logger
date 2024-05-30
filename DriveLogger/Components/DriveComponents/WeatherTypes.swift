//
//  WeatherTypes.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/28/24.
//

enum WeatherTypes: CaseIterable, Identifiable, CustomStringConvertible {
    case clear
    case rain
    case snow

    var id: Self { self }

    var description: String {
        switch self {
        case .clear:
            return "Clear"
        case .rain:
            return "Rain"
        case .snow:
            return "Snow"
        }
    }

    var symbol: String {
        switch self {
        case .clear:
            return "custom.sun.max.rectangle"
        case .rain:
            return "custom.cloud.rain.rectangle"
        case .snow:
            return "custom.snowflake.rectangle"
        }
    }

    var selectedSymbol: String {
        switch self {
        case .clear:
            return "custom.sun.max.rectangle.fill"
        case .rain:
            return "custom.cloud.rain.rectangle.fill"
        case .snow:
            return "custom.snowflake.rectangle.fill"
        }
    }
}
