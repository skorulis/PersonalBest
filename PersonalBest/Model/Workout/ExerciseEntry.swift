//Created by Alexander Skorulis on 2/10/2022.

import Foundation

struct ExerciseEntry: Codable, Identifiable {
    let id: String
    var values: [MeasurementType: Double]
    var variant: String?
    
    init() {
        id = UUID().uuidString
        values = [:]
    }
    
    func duplicate() -> ExerciseEntry {
        var result = ExerciseEntry()
        result.variant = self.variant
        result.values = self.values
        return result
    }
    
}
