//Created by Alexander Skorulis on 28/9/2022.

import Foundation

enum KnownUnit: String, Codable, Identifiable {
    case reps // Reps
    case meters, kilometers // Distance
    case seconds // Time
    case grams, kilograms // Weight
    
    var unit: Dimension {
        switch self {
        case .reps:
            return UnitReps.reps
        case .meters:
            return UnitLength.meters
        case .kilometers:
            return UnitLength.kilometers
        case .seconds:
            return UnitDuration.seconds
        case .grams:
            return UnitMass.grams
        case .kilograms:
            return UnitMass.kilograms
        }
    }
    
    var symbolString: String {
        return unit.symbol
    }
    
    var id: String { rawValue }
    
    static func from(unit: Unit) -> KnownUnit {
        if unit == UnitReps.reps {
            return reps
        } else if unit == UnitLength.meters {
            return .meters
        } else if unit == UnitLength.kilometers {
            return .kilometers
        } else if unit == UnitDuration.seconds {
            return .seconds
        } else if unit == UnitMass.grams {
            return .grams
        } else if unit == UnitMass.kilograms {
            return .kilograms
        }
        
        fatalError("Unknown unit \(unit)")
    }
    
}

class UnitReps: Dimension {
    static let reps = UnitReps(symbol: "reps", converter: UnitConverterLinear(coefficient: 1))
    
    override class func baseUnit() -> Self {
        return reps as! Self
    }
}
