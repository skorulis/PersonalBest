//Created by Alexander Skorulis on 2/10/2022.

import Foundation

struct ExerciseEntry: Codable, Identifiable {
    let id: String
    var values: [MeasurementType: Decimal]
    
    init() {
        id = UUID().uuidString
        values = [:]
    }
    
}
