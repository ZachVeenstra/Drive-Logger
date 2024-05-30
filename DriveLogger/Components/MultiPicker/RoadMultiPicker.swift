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


struct RoadMultiPicker_Previews: PreviewProvider {
    static var previews: some View {
        RoadMultiPicker(viewModel: RoadMultiPickerViewModel())
    }
}
