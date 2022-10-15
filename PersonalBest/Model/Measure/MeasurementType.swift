//Created by Alexander Skorulis on 27/9/2022.

import Foundation

enum MeasurementType: String, Codable, Identifiable {
    case reps
    case weight
    case distance
    case time
    
    var id: String { rawValue }
    
    var unitOptions: [UnitType] {
        switch self {
        case .reps:
            return [.reps]
        case .distance:
            return [
                .meters,
                .kilometers
            ]
        case .weight:
            return [
                .grams,
                .kilograms
            ]
        case .time:
            return [.seconds]
        }
    }
    
    var defaultUnit: UnitType {
        switch self {
        case .reps:
            return .reps
        case .distance:
            return .meters
        case .weight:
            return .grams
        case .time:
            return .seconds
        }
    }
    
    var name: String {
        return self.rawValue.capitalized
    }
    
    static func convert(value: Double, from: UnitType, to: UnitType) -> Double {
        let measure = Measurement(value: value, unit: from.unit)
        return measure.converted(to: to.unit).value
    }
    
    func convert(value: Double, from: UnitType) -> Double {
        return Self.convert(value: value, from: from, to: self.defaultUnit)
    }
    
    func convert(value: Double, to: UnitType) -> Double {
        return Self.convert(value: value, from: self.defaultUnit, to: to)
    }
}
