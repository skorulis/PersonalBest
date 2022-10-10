//Created by Alexander Skorulis on 29/9/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct RecordValueDisplay {
    
    let value: Double
    let unit: UnitType
    
}

// MARK: - Rendering

extension RecordValueDisplay: View {
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(String(describing: value))
                .typography(.subtitle)
            Text(unit.symbolString)
                .typography(.smallBody)
                .baselineOffset(6)
        }
    }
}

// MARK: - Previews

struct RecordValueDisplay_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            RecordValueDisplay(value: 100, unit: .kilograms)
            RecordValueDisplay(value: 12, unit: .reps)
            RecordValueDisplay(value: 55.5, unit: .meters)
        }
        
    }
}

