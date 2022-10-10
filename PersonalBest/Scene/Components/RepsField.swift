//Created by Alexander Skorulis on 28/9/2022.

import ASSwiftUI
import ASKCore
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct RepsField {
    
    // Only ints are allowed but takes a double for consistency
    @Binding var value: Double?
    
    init(value: Binding<Double?>) {
        _value = value
    }
     
}

// MARK: - Rendering

extension RepsField: View {
    
    var body: some View {
        HStack {
            TextField("Reps", value: $value, format: .number)
                .keyboardType(.numberPad)
        }
    }
}

// MARK: - Previews

struct RepsField_Previews: PreviewProvider {
    
    static var previews: some View {
        StatefulPreviewWrapper(Double(0)) { value in
            RepsField(value: value)
        }
        
    }
}

