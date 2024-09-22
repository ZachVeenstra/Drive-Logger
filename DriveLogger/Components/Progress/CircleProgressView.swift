/// Based on: https://sarunw.com/posts/swiftui-circular-progress-bar/

import SwiftUI

struct CircleProgressView: View {
    let progress: Double
    var color: Color = .accentColor
    var symbolName: String? = nil
    
    private let degreesInCircle: Double = 360
    
    private let circleSizeFactor: Double = 0.2
    private let progressStart: Double = -90
    private let circleUnderlayOpacity: Double = 0.5
    private let circleOverlayFactor: Double = 0.5
    private let gradientDarknessFactor: Double = 0.15
    private let progressAnimationDuration: CGFloat = 1
    
    private let symbolSizeFactor: Double = 0.1
    
    
    func incomplete(progress: Double) -> Bool {
        return progress < 1
    }
    
    var gradient: AngularGradient {
        if incomplete(progress: progress) {
            return AngularGradient(
                gradient: Gradient(colors: [color, color.darker(by: gradientDarknessFactor * progress)]),
                center: .center,
                startAngle: .degrees(0),
                endAngle: .degrees(degreesInCircle * progress)
            )
        } else {
            return AngularGradient(
                gradient: Gradient(colors: [.completed, .completed]),
                center: .center,
                startAngle: .degrees(0),
                endAngle: .degrees(degreesInCircle)
            )
        }
    }
    
    var secondaryGradient: AngularGradient {
        if incomplete(progress: progress) {
            return AngularGradient(
                gradient: Gradient(colors: [color, color.darker(by: gradientDarknessFactor * (progress - circleOverlayFactor))]),
                center: .center,
                startAngle: .degrees(0),
                endAngle: .degrees(degreesInCircle * (progress - circleOverlayFactor))
            )
        } else {
            return AngularGradient(
                gradient: Gradient(colors: [.completed, .completed]),
                center: .center,
                startAngle: .degrees(0),
                endAngle: .degrees(degreesInCircle)
            )
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let circleSize = min(geometry.size.width, geometry.size.height)
            let symbolOffset = circleSize / 2
            
            ZStack {
                ZStack {
                    // Underlay
                    Circle()
                        .stroke(
                            color.opacity(circleUnderlayOpacity),
                            lineWidth: circleSize * circleSizeFactor
                        )
                    
                    // Progress
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            gradient,
                            style: StrokeStyle(
                                lineWidth: circleSize * circleSizeFactor,
                                lineCap: .round
                            )
                        )
                        .rotationEffect(.degrees(progressStart))
                        .animation(.easeInOut(duration: progressAnimationDuration), value: progress)
                    
                    /// This circle makes the end of the progress appear as if it goes underneath the start
                    Circle()
                        .trim(from: 0, to: progress - circleOverlayFactor)
                        .stroke(
                            secondaryGradient,
                            style: StrokeStyle(
                                lineWidth: circleSize * circleSizeFactor,
                                lineCap: .round
                            )
                        )
                        .rotationEffect(.degrees(progressStart))
                        .animation(.easeInOut(duration: progressAnimationDuration), value: progress)
                }
                .frame(width: circleSize, height: circleSize)
                
                if let symbolName = symbolName {
                    Image(systemName: symbolName)
                        .font(.system(size: circleSize * symbolSizeFactor))
                        .foregroundStyle(.white)
                        .offset(y: -symbolOffset)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

extension Color {
    /// Darken the color by a percentage
    func darker(by percentage: Double) -> Color {
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return Color(red: Double(max(r - CGFloat(percentage), 0)),
                     green: Double(max(g - CGFloat(percentage), 0)),
                     blue: Double(max(b - CGFloat(percentage), 0)),
                     opacity: Double(a))
    }
}

#Preview {
    CircleProgressView(progress: 0.97, symbolName: "car.fill")  // Example with symbol
}
