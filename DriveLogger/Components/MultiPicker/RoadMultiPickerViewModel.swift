//
//  RoadMultiPickerViewModel.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/29/24.
//

import Foundation

class RoadMultiPickerViewModel: ObservableObject {
    @Published var options = RoadTypes.allCases

    @Published var city: Bool
    @Published var highway: Bool
    @Published var multilane: Bool
    @Published var residential: Bool
    @Published var roundabout: Bool
    @Published var rural: Bool

    init() {
        self.city = false
        self.highway = false
        self.multilane = false
        self.residential = false
        self.roundabout = false
        self.rural = false
    }

    init(city: Bool, highway: Bool, multilane: Bool, residential: Bool, roundabout: Bool, rural: Bool) {
        self.city = city
        self.highway = highway
        self.multilane = multilane
        self.residential = residential
        self.roundabout = roundabout
        self.rural = rural
    }

    func getImageResource(for option: RoadTypes) -> String {
        switch option {
        case .city:
            return city ? option.selectedSymbol : option.symbol
        case .highway:
            return highway ? option.selectedSymbol : option.symbol
        case .multilane:
            return multilane ? option.selectedSymbol : option.symbol
        case .residential:
            return residential ? option.selectedSymbol : option.symbol
        case .roundabout:
            return roundabout ? option.selectedSymbol : option.symbol
        case .rural:
            return rural ? option.selectedSymbol : option.symbol
        }
    }

    func toggleOption(option: RoadTypes) {
        switch option {
        case .city:
            self.city.toggle()
        case .highway:
            self.highway.toggle()
        case .multilane:
            self.multilane.toggle()
        case .residential:
            self.residential.toggle()
        case .roundabout:
            self.roundabout.toggle()
        case .rural:
            self.rural.toggle()
        }
    }
    
    func isOptionSelected(option: RoadTypes) -> Bool {
        switch option {
        case .city:
            return city
        case .highway:
            return highway
        case .multilane:
            return multilane
        case .residential:
            return residential
        case .roundabout:
            return roundabout
        case .rural:
            return rural
        }
    }
}
