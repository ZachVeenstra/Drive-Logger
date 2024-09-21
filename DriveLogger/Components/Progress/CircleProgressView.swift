import SwiftUI

struct CircleProgressView: View {
    let progress: Double
    let secondProgress: Double = 0.3
    var color: Color = .accentColor
    var symbolName: String? = nil  // Optional SF Symbol
    
    var dynamicColor: Color {
        return progress > 1 ? .green : color
    }
    
    var body: some View {
        GeometryReader { geometry in
            let circleSize = min(geometry.size.width, geometry.size.height)
            let symbolOffset = circleSize / 2
            
            ZStack {
                ZStack {
                    Circle()
                        .stroke(
                            dynamicColor.opacity(0.5),
                            lineWidth: circleSize * 0.2
                        )
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            dynamicColor,
                            style: StrokeStyle(
                                lineWidth: circleSize * 0.2,
                                lineCap: .round
                            )
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1), value: progress)
                }
                .frame(width: circleSize, height: circleSize)
                
                // Optional SF Symbol at the top
                if let symbolName = symbolName {
                    Image(systemName: symbolName)
                        .font(.system(size: circleSize * 0.1)) // Make symbol size relative to circle size
                        .foregroundColor(.white)
                        .offset(y: -symbolOffset)  // Offset relative to the circle size
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    CircleProgressView(progress: 0.7, color: .yellow, symbolName: "car.fill")  // Example with symbol
}
