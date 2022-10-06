//Created by Alexander Skorulis on 7/10/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ShadowButtonStyle: ButtonStyle {
    
    let backgroundColor: Color
    
    init(backgroundColor: Color = .white) {
        self.backgroundColor = backgroundColor
    }
    
}

// MARK: - Rendering

extension ShadowButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        let dark: CGFloat = configuration.isPressed ? 0.05 : 0
        return configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.white.darken(percentage: dark), in: RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.1), radius: 20)
    }
    
}

// MARK: - Previews

struct ShadowButtonStyle_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            Button("My button", action: {})
                .buttonStyle(ShadowButtonStyle())
            
            Button(action: {}) {
                Text("Button content")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(ShadowButtonStyle())
        }
        .padding(16)
        
    }
}


