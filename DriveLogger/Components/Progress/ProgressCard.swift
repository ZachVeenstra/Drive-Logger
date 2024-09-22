//
//  ProgressCard.swift
//  DriveLogger
//
//  Created by Zach Veenstra on 9/20/24.
//

import SwiftUI

struct ProgressCard: View {
    let totalProgress: Double
    let nightProgress: Double
    let innerRatio: Double = 0.53
    let outerRatio: Double = 0.82
    
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geometry in
                    let outerCircleSize = min(geometry.size.width, geometry.size.height)
                    
                    CircleProgressView(progress: nightProgress, color: .nightProgress, symbolName: "moon.fill")
                        .frame(width: outerCircleSize * innerRatio, height: outerCircleSize * innerRatio)
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                    
                    CircleProgressView(progress: totalProgress, color: .totalProgress, symbolName: "car.fill")
                        .frame(width: outerCircleSize * outerRatio, height:  outerCircleSize * outerRatio)
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

#Preview {
    ProgressCard(totalProgress: 0.5, nightProgress: 0.1)
}
