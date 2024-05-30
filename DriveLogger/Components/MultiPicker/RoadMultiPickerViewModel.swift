//
//  RoadMultiPickerViewModel.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/29/24.
//

import Foundation

class RoadMultiPickerViewModel: ObservableObject {
    @Published var options = RoadTypes.allCases
    @Published var selectedOptions: Set<RoadTypes>

    init() {
        self.selectedOptions = Set<RoadTypes>()
    }

    init(selectedOptions: Set<RoadTypes>) {
        self.selectedOptions = selectedOptions
    }

    func getImageResource(for option: RoadTypes) -> String {
        return self.selectedOptions.contains(option.id) ?
            option.selectedSymbol : option.symbol
    }

    func toggleOption(option: RoadTypes) {
        if self.selectedOptions.contains(option.id) {
            self.selectedOptions.remove(option.id)
        } else {
            self.selectedOptions.insert(option.id)
        }
    }
}
