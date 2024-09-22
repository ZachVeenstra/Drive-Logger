//
//  WeatherMultiPickerViewModel.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 6/1/24.
//

import Foundation

class WeatherMultiPickerViewModel: ObservableObject {
    @Published var options = WeatherTypes.allCases

    @Published var isClear: Bool
    @Published var isRain: Bool
    @Published var isSnow: Bool

    init() {
        self.isClear = false
        self.isRain = false
        self.isSnow = false
    }

    init(clear: Bool, rain: Bool, snow: Bool) {
        self.isClear = clear
        self.isRain = rain
        self.isSnow = snow
    }

    func getImageResource(for option: WeatherTypes) -> String {
        switch option {
        case .clear:
            return isClear ? option.selectedSymbol : option.symbol
        case .rain:
            return isRain ? option.selectedSymbol : option.symbol
        case .snow:
            return isSnow ? option.selectedSymbol : option.symbol
        }
    }

    func toggleOption(option: WeatherTypes) {
        switch option {
        case .clear:
            self.isClear.toggle()
        case .rain:
            self.isRain.toggle()
        case .snow:
            self.isSnow.toggle()
        }
    }
    
    func isOptionSelected(option: WeatherTypes) -> Bool {
        switch option {
        case .clear:
            return isClear
        case .rain:
            return isRain
        case .snow:
            return isSnow
        }
    }
}
