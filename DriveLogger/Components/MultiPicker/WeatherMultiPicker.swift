//
//  WeatherMultiPicker.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/29/24.
//

import SwiftUI

struct WeatherMultiPicker: View {
    @ObservedObject var viewModel: WeatherMultiPickerViewModel
    let columns = [
        GridItem(.flexible(), spacing: -40),
        GridItem(.flexible(), spacing: -40),
        GridItem(.flexible(), spacing: -40)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(viewModel.options, id: \.self) { option in
                let imageResource = viewModel.getImageResource(for: option)
                let isSelected = viewModel.isOptionSelected(option: option)

                MultipleSelectionItem(title: option.description,
                                      imageResource: imageResource,
                                      selected: isSelected
                ) {
                    viewModel.toggleOption(option: option)
                }
            }
            .padding()
        }
    }
}


struct WeaterMultiPicker_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMultiPicker(viewModel: WeatherMultiPickerViewModel())
    }
}
