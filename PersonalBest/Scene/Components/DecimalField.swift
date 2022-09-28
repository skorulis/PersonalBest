//Created by Alexander Skorulis on 28/9/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct DecimalField {
    
    let type: MeasurementType
    @Binding var value: Decimal?
}

// MARK: - Rendering

extension DecimalField: View {
    
    var body: some View {
        HStack {
            TextField(type.placeholder, value: $value, format: .number)
                .keyboardType(.decimalPad)
        }
    }
}

// MARK: - Type enrichment

private extension MeasurementType {
    
    var placeholder: String {
        switch self {
        case .reps: return "Reps"
        case .weight: return "Weight"
        case .distance: return "Distance"
        case .time: fatalError("Not supported")
        }
    }
    
}

// MARK: - Previews

struct DecimalField_Previews: PreviewProvider {
    
    static var previews: some View {
        StatefulPreviewWrapper(Decimal(0)) { value in
            DecimalField(type: .distance, value: value)
        }
        
    }
}

