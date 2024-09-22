//
//  MultipleSelectionItem.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 5/29/24.
//

import SwiftUI

struct MultipleSelectionItem: View {
    var title: String
    var imageResource: String
    var selected: Bool
    var action: () -> Void

    var body: some View {
        Button {
            withAnimation {
                self.action()
            }
        } label: {
            VStack {
                Image(imageResource)
                    .font(.largeTitle)
                    .foregroundColor(selected ? .selected : .accent) // Change color when selected
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(selected ? .selected : .accent) // Change color when selected
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}


#Preview {
    MultipleSelectionItem(title: RoadTypes.city.description,
                          imageResource: RoadTypes.city.symbol, 
                          selected: true,
                          action: { }
    )
}
