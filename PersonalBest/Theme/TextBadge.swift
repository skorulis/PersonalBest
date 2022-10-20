//Created by Alexander Skorulis on 19/10/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct TextBadge {
    
    let text: String
    let color: Color
    
}

// MARK: - Rendering

extension TextBadge: View {
    
    var body: some View {
        Text(text)
            .typography(.caption)
            .padding(.horizontal, 4)
            .padding(.vertical, 1)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
            )
    }
}

// MARK: - Previews

struct TextBadge_Previews: PreviewProvider {
    
    static var previews: some View {
        TextBadge(text: "Variant", color: .blue.opacity(0.3))
    }
}

