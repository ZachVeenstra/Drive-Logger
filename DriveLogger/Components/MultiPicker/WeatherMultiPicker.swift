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
        GridItem(.flexible(), spacing: -40),
        GridItem(.flexible(), spacing: -40)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(viewModel.options) { option in
                let imageResource = viewModel.getImageResource(for: option)

                MultipleSelectionItem(title: option.description,
                                      imageResource: imageResource
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
