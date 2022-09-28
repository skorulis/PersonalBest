//Created by Alexander Skorulis on 27/9/2022.

import Foundation

enum MeasurementType: String, Codable, Identifiable {
    case reps
    case weight
    case distance
    case time
    
    var id: String { rawValue }
}
