//Created by Alexander Skorulis on 29/9/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct RecordValueDisplay {
    
    let value: Decimal
    let unit: UnitType
    
}

// MARK: - Rendering

extension RecordValueDisplay: View {
    
    var body: some View {
        HStack(alignment: .top) {
            Text(String(describing: value))
                .font(.largeTitle)
            Text(unit.symbolString)
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
