//Created by Alexander Skorulis on 13/11/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ActivityTypeCell {
    
    let type: ActivityTrackingType
}

// MARK: - Rendering

extension ActivityTypeCell: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(type.name)
                .typography(.subtitle)
            Text(measuresText)
                .typography(.smallBody)
        }
    }
    
    var measuresText: String {
        return type.measurements.map { $0.type.name }.joined(separator: ", ")
    }
}

// MARK: - Previews

struct ActivityTypeCell_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            ActivityTypeCell(type: .weightlifting)
            
            ActivityTypeCell(type: .reps)
        }
        
    }
}

