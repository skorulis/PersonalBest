//Created by Alexander Skorulis on 9/11/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct RecordEntryTags {
    
    let key: RecordKey
}

// MARK: - Rendering

extension RecordEntryTags: View {
    
    var body: some View {
        HStack {
            if let variant = key.variant {
                TextBadge(text: variant, color: .blue.opacity(0.3))
            }
            if let autoType = key.autoType {
                TextBadge(text: autoType.displayText, color: .orange.opacity(0.3))
            }
        }
    }
}

// MARK: - Previews

struct RecordEntryTags_Previews: PreviewProvider {
    
    static var previews: some View {
        let key = RecordKey(autoType: .volume, variant: "test")
        RecordEntryTags(key: key)
    }
}

