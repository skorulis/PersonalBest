//Created by Alexander Skorulis on 24/10/2022.

import Foundation
import SwiftUI

struct HalfTriangleShape: Shape {
    
    let position: Position
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width, y: 0))
        switch position {
        case .left:
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        case .right:
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

extension HalfTriangleShape {
    enum Position {
        case left, right
    }
}

struct HalfTriangleShape_Previews: PreviewProvider {
    
    static var previews: some View {
        ZStack {
            HalfTriangleShape(position: .left)
                .fill(Color.red)
            HalfTriangleShape(position: .right)
                .fill(Color.blue)
        }
    }
    
    
}
