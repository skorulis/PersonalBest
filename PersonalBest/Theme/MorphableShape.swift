//Created by Alexander Skorulis on 29/9/2022.

import Foundation
import SwiftUI

struct MorphableShape: Shape {
    var controlPoints: AnimatableVector
    
    var animatableData: AnimatableVector {
        set { self.controlPoints = newValue }
        get { return self.controlPoints }
    }
    
    func point(x: Double, y: Double, rect: CGRect) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            
            path.move(to: self.point(x: self.controlPoints.values[0],
                                     y: self.controlPoints.values[1], rect: rect))
            
            var i = 2;
            while i < self.controlPoints.values.count-1 {
                path.addLine(to:  self.point(x: self.controlPoints.values[i],
                                             y: self.controlPoints.values[i+1], rect: rect))
                i += 2;
            }
            
            path.addLine(to:  self.point(x: self.controlPoints.values[0],
                                         y: self.controlPoints.values[1], rect: rect))
        }
    }
}
