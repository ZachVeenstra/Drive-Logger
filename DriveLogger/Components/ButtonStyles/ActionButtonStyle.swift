//
//  ActionButtonModifier.swift
//  Drive Logger
//
//  Created by Zach Veenstra on 11/28/23.
//

import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    
    private let cornerRadius: Double = 10
    private let pressedScale: Double = 1.05
    private let unpressedScale: Double = 1
    private let animationLength: Double = 0.05
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .font(.title2)
            .fontWeight(.heavy)
            .background(configuration.isPressed ? .actionButtonPressed : .actionButton)
            .cornerRadius(cornerRadius)
            .scaleEffect(configuration.isPressed ? pressedScale : unpressedScale)
            .animation(.easeOut(duration: animationLength), value: configuration.isPressed)
    }
}

private struct ActionButtonView: View {
    var body: some View {
        Button("Example") {}
        .buttonStyle(ActionButtonStyle())
    }
}

#Preview {
    ActionButtonView()
}
