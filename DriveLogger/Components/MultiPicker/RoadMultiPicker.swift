//
//  RoadMultiPicker.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/29/24.
//

import SwiftUI

struct RoadMultiPicker: View {
    @ObservedObject var viewModel: RoadMultiPickerViewModel
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


struct RoadMultiPicker_Previews: PreviewProvider {
    static var previews: some View {
        RoadMultiPicker(viewModel: RoadMultiPickerViewModel())
    }
}
