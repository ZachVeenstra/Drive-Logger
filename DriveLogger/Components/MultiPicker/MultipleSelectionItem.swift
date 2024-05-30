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
                Text(title)
                    .font(.subheadline)
            }
        }
        .contentTransition(.symbolEffect(.replace))
        .buttonStyle(BorderlessButtonStyle())
    }
}

#Preview {
    MultipleSelectionItem(title: RoadTypes.city.description,
                          imageResource: RoadTypes.city.symbol,
                          action: { }
    )
}
