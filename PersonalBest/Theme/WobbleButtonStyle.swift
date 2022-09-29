//Created by Alexander Skorulis on 29/9/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct WobbleButtonStyle: ButtonStyle {
    
    let backgroundColor: Color
    
    init(backgroundColor: Color = .blue) {
        self.backgroundColor = backgroundColor
    }
    
}

// MARK: - Rendering

extension WobbleButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(bgShape(isPressed: configuration.isPressed))
    }
    
    private func bgShape(isPressed: Bool) -> some View {
        GeometryReader { proxy in
            MorphableShape(controlPoints: points(size: proxy.size, isPressed: isPressed))
                .fill(backgroundColor)
                .animation(animation, value: isPressed)
                
        }
    }
    
    private var animation: Animation {
        return .interpolatingSpring(mass: 1, stiffness: 30, damping: 15, initialVelocity: 25)
    }
    
    private func points(size: CGSize, isPressed: Bool ) -> AnimatableVector {
        if isPressed {
            return pressedPoints(size: size)
        } else {
            return basePoints(size: size)
        }
    }
    
    private func pressedPoints(size: CGSize) -> AnimatableVector {
        var base = basePoints(size: size)
        let centre = CGPoint(x: size.width / 2, y: size.height / 2)
        for i in stride(from: 0, to: base.values.count - 1, by: 2) {
            let point = CGPoint(x: base.values[i], y: base.values[i+1])
            let xDist = centre.x - abs(point.x - centre.x)
            let xMov = 2 * pow(xDist / centre.x, 0.5)
            base.values[i] = point.x * 0.99 + centre.x * 0.01
            if point.y > centre.y {
                base.values[i + 1] = point.y - xMov
            } else {
                base.values[i + 1] = point.y + xMov
            }
        }
        
        return base
    }
    
    
    private func basePoints(size: CGSize) -> AnimatableVector {
        let shape = RoundedRectangle(cornerRadius: 8)
        let points = shape.path(in: CGRect(origin: .zero, size: size)).controlPoints(count: 100)
        return points
    }
    
}

// MARK: - Previews

struct WobbleButtonStyle_Previews: PreviewProvider {
    
    static var previews: some View {
        Button("My button", action: {})
            .buttonStyle(WobbleButtonStyle(backgroundColor: .green))
    }
}

