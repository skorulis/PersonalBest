//Created by Alexander Skorulis on 22/10/2022.

import Foundation
import SwiftUI

struct HalfCapsuleShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let height2 = rect.size.height/2
        let arcX = rect.size.width - height2
        
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: arcX, y: 0))
        path.addArc(center: CGPoint(x: arcX, y: height2),
                    radius: height2,
                    startAngle: .degrees(-90),
                    endAngle: .degrees(90),
                    clockwise: false
        )
        path.addLine(to: CGPoint(x: arcX, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: .zero)
        return path
    }
}
