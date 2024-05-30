//
//  WeatherMultiPicker.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/29/24.
//

import SwiftUI

struct WeatherMultiPicker: View {
    @Binding var isClear: Bool
    @Binding var isRain: Bool
    @Binding var isSnow: Bool

    var body: some View {
        HStack {
            ForEach(WeatherTypes.allCases) { option in
                let imageResource = getImageResource(for: option)

                MultipleSelectionItem(title: option.description,
                                      imageResource: imageResource
                ) {
                    toggleOption(option: option)
                }
            }
            .padding()
        }
    }

    private func getImageResource(for option: WeatherTypes) -> String {
        switch option {
        case .clear:
            return isClear ? option.selectedSymbol : option.symbol
        case .rain:
            return isRain ? option.selectedSymbol : option.symbol
        case .snow:
            return isSnow ? option.selectedSymbol : option.symbol
        }
    }

    private func toggleOption(option: WeatherTypes) {
        switch option {
        case .clear:
            self.isClear.toggle()
        case .rain:
            self.isRain.toggle()
        case .snow:
            self.isSnow.toggle()
        }
    }
}

struct WeatherMultiPickerContentPreview: View {
    @State var isClear: Bool = true
    @State var isRain: Bool = false
    @State var isSnow: Bool = false

    var body: some View {
        WeatherMultiPicker(isClear: $isClear, isRain: $isRain, isSnow: $isSnow)
    }
}

struct WeatherMultiPicker_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMultiPickerContentPreview()
    }
}
