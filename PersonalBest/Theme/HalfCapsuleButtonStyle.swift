//Created by Alexander Skorulis on 21/10/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct HalfCapsuleButtonStyle: ButtonStyle {
    
}

// MARK: - Rendering

extension HalfCapsuleButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(6)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                HalfCapsuleShape()
                    .fill(Color.white)
            )
            .shadow(color: Color.black.opacity(0.07), radius: 20)
    }
}

// MARK: - Previews

struct HalfCapsuleButtonStyle_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack(spacing: 20) {
            Button(action: {}) {
                Text("TEST")
            }
            .buttonStyle(HalfCapsuleButtonStyle())
            
            Button(action: {}) {
                Text("TEST")
                    .frame(height: 150)
            }
            .buttonStyle(HalfCapsuleButtonStyle())
        }
        
    }
}

