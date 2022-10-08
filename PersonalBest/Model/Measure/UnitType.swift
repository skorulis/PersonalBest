//Created by Alexander Skorulis on 28/9/2022.

import Foundation

enum UnitType: String, Codable {
    case reps // Reps
    case meters, kilometers // Distance
    case seconds // Time
    case kilograms // Weight
    
    var unit: Dimension {
        switch self {
        case .reps:
            return UnitReps.reps
        case .meters:
            return UnitLength.meters
        case .kilometers:
            return UnitLength.meters
        case .seconds:
            return UnitDuration.seconds
        case .kilograms:
            return UnitMass.kilograms
        }
    }
    
    var symbolString: String {
        return unit.symbol
    }
    
}

class UnitReps: Dimension {
    static let reps = UnitReps(symbol: "reps")
}
