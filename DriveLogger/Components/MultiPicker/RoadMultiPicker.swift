//
//  RoadMultiPicker.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/29/24.
//

import SwiftUI

struct RoadMultiPicker: View {
    @StateObject var viewModel: RoadMultiPickerViewModel
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]

    var body: some View {
        LazyVGrid(columns: columns) {
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
        .frame(maxWidth: 215)
    }
}


struct RoadMultiPicker_Previews: PreviewProvider {
    static var previews: some View {
        RoadMultiPicker(viewModel: RoadMultiPickerViewModel(selectedOptions: [RoadTypes.city, RoadTypes.residential]))
    }
}
